defmodule Isox.Xsd.Compiler do
  # Resolve recursivamente as definições lidas pelo Xsd.Reader numa árvore
  # de Isox.Schema — sem indireção por nome: todo tipo referenciado
  # já sai embutido no lugar.
  #
  # Cobre o subconjunto de XSD usado pelo catálogo (confirmado por varredura
  # em todos os XSDs de v5.12.1/v5.13.1): element, complexType,
  # simpleType/restriction, choice, group (só ref, nunca aninhado fora de
  # uma sequência ou escolha), simpleContent/extension/attribute (o padrão
  # valor+moeda, ex. IntrBkSttlmAmt), element ref= e xs:any (tratado como
  # opaco — é só o <Sgntr>).
  #
  # xs:group ref= dentro de um xs:choice (só ocorre em reda.022) vira uma
  # opção só — a lista de elementos do grupo inteiro (Schema.Choice), não
  # elementos soltos achatados na escolha. Um grupo de 1 elemento e um
  # grupo de N elementos são tratados igual: a opção é sempre a lista de
  # elementos do grupo.
  #
  # Suporte de mix catalog.gen — não é API pública da lib.
  @moduledoc false

  alias Isox.Schema.{Attribute, Choice, ComplexType, Element, SimpleType}
  alias Isox.Xsd.Reader

  @doc "Resolve o elemento raiz de um XSD já lido em `Reader.t()` para um `Schema.Element`."
  @spec resolve_root(Reader.t()) :: Element.t()
  def resolve_root(%{root_name: name, root_type: type, definitions: definitions}) do
    %Element{tag: name, type: resolve_type_by_name(type, definitions)}
  end

  @doc "Resolve um `<xs:element>` (com `type=`, `ref=` ou tipo anônimo aninhado) para um `Schema.Element`."
  @spec resolve_element(tuple(), map()) :: Element.t()
  def resolve_element(node, definitions) do
    min = occurrence(node, "minOccurs", 1)
    max = occurrence(node, "maxOccurs", 1)

    cond do
      ref = Reader.attribute(node, "ref") ->
        {:element, ref_node} = Map.fetch!(definitions, ref)
        %{resolve_element(ref_node, definitions) | min: min, max: max}

      type_name = Reader.attribute(node, "type") ->
        %Element{
          tag: Reader.attribute(node, "name"),
          type: resolve_type_by_name(type_name, definitions),
          min: min,
          max: max
        }

      true ->
        child =
          node
          |> Reader.child_elements()
          |> Enum.find(&(Reader.local_tag(&1) in ["complexType", "simpleType"]))

        %Element{
          tag: Reader.attribute(node, "name"),
          type: resolve_inline_type(child, definitions),
          min: min,
          max: max
        }
    end
  end

  defp resolve_type_by_name("xs:" <> base, _definitions), do: %SimpleType{base: base}

  defp resolve_type_by_name(name, definitions) do
    case Map.fetch!(definitions, name) do
      {:complex_type, node} -> resolve_complex_type(node, definitions)
      {:simple_type, node} -> resolve_simple_type(node)
    end
  end

  defp resolve_inline_type(node, definitions) do
    case Reader.local_tag(node) do
      "complexType" -> resolve_complex_type(node, definitions)
      "simpleType" -> resolve_simple_type(node)
    end
  end

  @doc """
  Resolve um `<xs:complexType>` para `Schema.ComplexType`, ou `:opaque`
  quando o único conteúdo é `xs:any` (o caso do `<Sgntr>`).
  """
  @spec resolve_complex_type(tuple(), map()) :: ComplexType.t() | :opaque
  def resolve_complex_type(node, definitions) do
    children = Reader.child_elements(node)

    cond do
      simple_content = Enum.find(children, &(Reader.local_tag(&1) == "simpleContent")) ->
        resolve_simple_content(simple_content, definitions)

      container = Enum.find(children, &(Reader.local_tag(&1) in ["sequence", "choice"])) ->
        cond do
          any_only?(container) ->
            :opaque

          Reader.local_tag(container) == "choice" ->
            %ComplexType{
              content: [resolve_choice(container, definitions)],
              attributes: resolve_direct_attributes(children, definitions)
            }

          true ->
            %ComplexType{
              content: resolve_container(container, definitions),
              attributes: resolve_direct_attributes(children, definitions)
            }
        end

      true ->
        %ComplexType{content: []}
    end
  end

  defp any_only?(container) do
    case Reader.child_elements(container) do
      [single] -> Reader.local_tag(single) == "any"
      _ -> false
    end
  end

  defp resolve_container(node, definitions) do
    node
    |> Reader.child_elements()
    |> Enum.flat_map(fn child ->
      case Reader.local_tag(child) do
        "element" -> [resolve_element(child, definitions)]
        "choice" -> [resolve_choice(child, definitions)]
        "group" -> resolve_group_ref(child, definitions)
        _ -> []
      end
    end)
  end

  defp resolve_choice(node, definitions) do
    options =
      node
      |> Reader.child_elements()
      |> Enum.flat_map(fn child ->
        case Reader.local_tag(child) do
          "element" -> [resolve_element(child, definitions)]
          # o grupo inteiro é 1 opção (a lista dos seus elementos) — não
          # achata os elementos do grupo como opções soltas da escolha,
          # senão um grupo de N campos vira N opções independentes em vez
          # de "todos os N juntos, ou nenhum" (bug real: perdia campo no
          # parse quando duas opções de grupo compartilhavam nome de tag).
          "group" -> [resolve_group_ref(child, definitions)]
          _ -> []
        end
      end)

    %Choice{
      options: options,
      min: occurrence(node, "minOccurs", 1),
      max: occurrence(node, "maxOccurs", 1)
    }
  end

  defp resolve_group_ref(node, definitions) do
    name = Reader.attribute(node, "ref")
    {:group, group_node} = Map.fetch!(definitions, name)

    group_node
    |> Reader.child_elements()
    |> Enum.find(&(Reader.local_tag(&1) in ["sequence", "choice"]))
    |> resolve_container(definitions)
  end

  defp resolve_direct_attributes(children, definitions) do
    children
    |> Enum.filter(&(Reader.local_tag(&1) == "attribute"))
    |> Enum.map(&resolve_attribute(&1, definitions))
  end

  defp resolve_attribute(node, definitions) do
    type_name = Reader.attribute(node, "type")

    %Attribute{
      tag: Reader.attribute(node, "name"),
      type: resolve_type_by_name(type_name, definitions),
      required: Reader.attribute(node, "use") != "optional"
    }
  end

  defp resolve_simple_content(node, definitions) do
    extension =
      node |> Reader.child_elements() |> Enum.find(&(Reader.local_tag(&1) == "extension"))

    base = Reader.attribute(extension, "base")

    attributes =
      extension
      |> Reader.child_elements()
      |> resolve_direct_attributes(definitions)

    %ComplexType{text: resolve_type_by_name(base, definitions), attributes: attributes}
  end

  @doc "Resolve um `<xs:simpleType>` (sempre `restriction`) para `Schema.SimpleType`."
  @spec resolve_simple_type(tuple()) :: SimpleType.t()
  def resolve_simple_type(node) do
    restriction =
      node |> Reader.child_elements() |> Enum.find(&(Reader.local_tag(&1) == "restriction"))

    "xs:" <> base = Reader.attribute(restriction, "base")
    children = Reader.child_elements(restriction)

    %SimpleType{
      base: base,
      pattern: single_value(children, "pattern"),
      enum: values(children, "enumeration"),
      max_length: integer_value(children, "maxLength"),
      min_length: integer_value(children, "minLength"),
      fraction_digits: integer_value(children, "fractionDigits"),
      total_digits: integer_value(children, "totalDigits"),
      min_inclusive: single_value(children, "minInclusive"),
      max_inclusive: single_value(children, "maxInclusive")
    }
  end

  defp single_value(children, tag) do
    case Enum.find(children, &(Reader.local_tag(&1) == tag)) do
      nil -> nil
      node -> Reader.attribute(node, "value")
    end
  end

  defp values(children, tag) do
    case Enum.filter(children, &(Reader.local_tag(&1) == tag)) do
      [] -> nil
      found -> Enum.map(found, &Reader.attribute(&1, "value"))
    end
  end

  defp integer_value(children, tag) do
    case single_value(children, tag) do
      nil -> nil
      value -> String.to_integer(value)
    end
  end

  defp occurrence(node, attribute, default) do
    case Reader.attribute(node, attribute) do
      nil -> default
      "unbounded" -> :unbounded
      value -> String.to_integer(value)
    end
  end
end
