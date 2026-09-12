defmodule PixSpiCatalog.Xml.Codec do
  @moduledoc """
  Motor genérico de `parse`/`build` orientado a `PixSpiCatalog.Schema` — não
  conhece nenhuma mensagem específica, só percorre a árvore do schema contra
  o XML (na entrada) ou contra o termo genérico (na saída).

  O termo genérico é: valor simples vira string; elemento complexo normal
  vira mapa `%{tag => valor}` (lista quando `max` permite repetição);
  `simpleContent` (valor + atributo, ex. `IntrBkSttlmAmt`) vira
  `%{value: ..., attributes: %{tag => valor}}`; `:opaque` (`<Sgntr>`) vira a
  string do XML interno, sem interpretar.

  Validação (pattern/enum/tamanho) acontece no `parse`; o `build` confia no
  termo que recebe.

  `compile_template/3` + `render/2` são a terceira API do ADR 0003: compila
  um termo com lacunas (`gap/1`) uma vez, e cada renderização só preenche
  as lacunas — sem percorrer o schema de novo.
  """

  import PixSpiCatalog.Xml.Records

  alias PixSpiCatalog.Schema.{Attribute, Choice, ComplexType, Element, SimpleType}

  @doc "Parseia um XML contra o schema (a raiz, um `Schema.Element`)."
  @spec parse(Element.t(), binary()) :: {:ok, term()} | {:error, String.t()}
  def parse(%Element{} = schema, xml) when is_binary(xml) do
    # bytes crus, não codepoints já decodificados: o prólogo declara
    # encoding="UTF-8" e é o próprio xmerl quem decodifica a partir disso.
    {node, _rest} = :xmerl_scan.string(:binary.bin_to_list(xml))
    {:ok, extract_type(node, schema.type)}
  rescue
    e -> {:error, Exception.message(e)}
  catch
    # XML malformado faz o xmerl sair com exit, não raise — e isso não pode
    # derrubar o processo chamador; é entrada não confiável (PSP), não bug.
    :exit, reason -> {:error, inspect(reason)}
  end

  @doc """
  Monta o XML (com prólogo) a partir do termo genérico, contra o schema.

  `namespace`, quando dado, vira o `xmlns` da tag raiz — namespace é
  declaração XML, não um `xs:attribute` do schema, então não é modelado
  como atributo comum; sem ele, o XML montado não teria como ser
  redespachado por `Registry.parse/1`.
  """
  @spec build(Element.t(), term(), String.t() | nil) :: {:ok, binary()} | {:error, String.t()}
  def build(%Element{} = schema, term, namespace \\ nil) do
    body =
      schema
      |> build_element(term)
      |> inject_xmlns(schema.tag, namespace)

    {:ok, ~s(<?xml version="1.0" encoding="UTF-8"?>) <> body}
  rescue
    e -> {:error, Exception.message(e)}
  end

  defp inject_xmlns(body, _tag, nil), do: body

  defp inject_xmlns(body, tag, namespace) do
    String.replace(body, "<#{tag}>", ~s(<#{tag} xmlns="#{escape_attribute(namespace)}">),
      global: false
    )
  end

  # --- template canônico (ADR 0003) ---

  @typedoc "Template compilado: trechos fixos intercalados com lacunas a preencher depois."
  @type template :: [binary() | {:gap, atom()}]

  @doc """
  Marcador de lacuna: usa no lugar de um valor real, num termo passado para
  `compile_template/3`, pra dizer "isso varia, preenche depois".
  """
  @spec gap(atom()) :: binary()
  def gap(key) when is_atom(key), do: <<0>> <> Atom.to_string(key) <> <<0>>

  @doc """
  Compila `{schema, termo com lacunas}` num template canônico: monta o XML
  normalmente (reaproveita `build/3`, mesma árvore, mesma validação de
  atributo obrigatório) e depois separa os trechos fixos das lacunas — sem
  percorrer o schema de novo. Pensado pro caminho quente do simulador: o
  custo de percorrer a árvore é pago uma vez aqui, não a cada mensagem.
  """
  @spec compile_template(Element.t(), term(), String.t() | nil) ::
          {:ok, template()} | {:error, String.t()}
  def compile_template(%Element{} = schema, term_with_gaps, namespace \\ nil) do
    with {:ok, xml} <- build(schema, term_with_gaps, namespace) do
      {:ok, split_gaps(xml)}
    end
  end

  @doc "Preenche as lacunas de um template já compilado, produzindo o XML final."
  @spec render(template(), %{atom() => term()}) :: binary()
  def render(template, variable_fields) do
    Enum.map_join(template, "", fn
      {:gap, key} -> variable_fields |> Map.fetch!(key) |> to_string() |> escape_text()
      fixed -> fixed
    end)
  end

  @gap_regex ~r/\x00([a-zA-Z_][a-zA-Z0-9_]*)\x00/

  defp split_gaps(xml) do
    @gap_regex
    |> Regex.split(xml, include_captures: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&segment/1)
  end

  defp segment(<<0, rest::binary>>),
    do: {:gap, rest |> String.trim_trailing(<<0>>) |> String.to_existing_atom()}

  defp segment(fixed), do: fixed

  # --- extração (parse) ---

  defp extract_type(_node, :opaque), do: nil
  defp extract_type(node, %SimpleType{} = type), do: node |> direct_text() |> validate!(type)

  defp extract_type(node, %ComplexType{text: %SimpleType{} = text_type} = type) do
    %{
      value: node |> direct_text() |> validate!(text_type),
      attributes: extract_attributes(node, type.attributes)
    }
  end

  defp extract_type(node, %ComplexType{content: items}) do
    grouped = group_by_tag(node)
    Enum.reduce(items, %{}, fn item, acc -> Map.merge(acc, extract_item(item, grouped)) end)
  end

  defp extract_opaque_content(node),
    do: node |> xmlElement(:content) |> Enum.map_join("", &serialize_node/1)

  defp extract_item(%Element{type: :opaque, tag: tag, min: min}, grouped) do
    case Map.get(grouped, tag, []) do
      [single] -> %{tag => extract_opaque_content(single)}
      [] when min == 0 -> %{}
      [] -> raise "elemento obrigatório ausente: #{tag}"
    end
  end

  defp extract_item(%Element{tag: tag, type: type, min: min, max: 1}, grouped) do
    case Map.get(grouped, tag, []) do
      [single] -> %{tag => extract_type(single, type)}
      [] when min == 0 -> %{}
      [] -> raise "elemento obrigatório ausente: #{tag}"
      _ -> raise "elemento #{tag} apareceu mais de uma vez, mas a cardinalidade máxima é 1"
    end
  end

  defp extract_item(%Element{tag: tag, type: type, min: min}, grouped) do
    children = Map.get(grouped, tag, [])

    if length(children) < min do
      raise "elemento #{tag}: esperado ao menos #{min}, vieram #{length(children)}"
    end

    %{tag => Enum.map(children, &extract_type(&1, type))}
  end

  defp extract_item(%Choice{options: options, min: min}, grouped) do
    case best_option(options, &Map.has_key?(grouped, &1)) do
      nil when min == 0 ->
        %{}

      nil ->
        raise "nenhuma opção da escolha está presente: #{inspect(Enum.map(options, &option_tags/1))}"

      option ->
        extract_option(option, grouped)
    end
  end

  # Uma opção de `Choice` é ou 1 elemento, ou (quando vem de `xs:group ref=`
  # dentro de um `xs:choice` com mais de 1 elemento no grupo) a lista de
  # elementos do grupo inteiro. Duas opções de grupo podem compartilhar tag
  # (ex. reda.022: `ReqdModContato` e `ReqdModDiretor` têm PhneNb/EmailAdr/
  # Rspnsblty em comum, só `Nm` distingue) — "presente" não basta, escolhe a
  # opção com MAIS tags batendo, não a primeira com alguma batendo, senão um
  # exemplar do ramo com o campo distintivo ausente escolhe o ramo errado e
  # perde esse campo.
  defp best_option(options, key_present?) do
    options
    |> Enum.map(&{&1, present_count(&1, key_present?)})
    |> Enum.filter(fn {_option, count} -> count > 0 end)
    |> Enum.max_by(fn {_option, count} -> count end, fn -> {nil, 0} end)
    |> elem(0)
  end

  defp present_count(%Element{tag: tag}, key_present?),
    do: if(key_present?.(tag), do: 1, else: 0)

  defp present_count(members, key_present?) when is_list(members),
    do: Enum.count(members, &key_present?.(&1.tag))

  defp option_tags(%Element{tag: tag}), do: tag
  defp option_tags(members) when is_list(members), do: Enum.map(members, & &1.tag)

  defp extract_option(%Element{} = element, grouped), do: extract_item(element, grouped)

  defp extract_option(members, grouped) when is_list(members) do
    Enum.reduce(members, %{}, fn item, acc -> Map.merge(acc, extract_item(item, grouped)) end)
  end

  defp group_by_tag(node) do
    node
    |> xmlElement(:content)
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlElement))
    |> Enum.group_by(&(&1 |> xmlElement(:name) |> Atom.to_string()))
  end

  defp extract_attributes(node, schema_attributes) do
    raw = xmlElement(node, :attributes)

    Enum.reduce(schema_attributes, %{}, fn %Attribute{tag: tag, type: type}, acc ->
      case attribute_value(raw, tag) do
        nil -> acc
        value -> Map.put(acc, tag, validate!(value, type))
      end
    end)
  end

  defp attribute_value(raw, tag) do
    Enum.find_value(raw, fn a ->
      if Atom.to_string(xmlAttribute(a, :name)) == tag,
        do: a |> xmlAttribute(:value) |> List.to_string()
    end)
  end

  defp direct_text(node) do
    node
    |> xmlElement(:content)
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlText))
    |> Enum.map_join("", fn t -> t |> xmlText(:value) |> List.to_string() end)
    |> String.trim()
  end

  defp validate!(value, %SimpleType{} = type) do
    if type.pattern && not Regex.match?(anchored_regex(type.pattern), value) do
      raise "valor #{inspect(value)} não bate com o padrão #{type.pattern}"
    end

    if type.enum && value not in type.enum do
      raise "valor #{inspect(value)} não está entre #{inspect(type.enum)}"
    end

    if type.max_length && String.length(value) > type.max_length do
      raise "valor #{inspect(value)} excede o tamanho máximo #{type.max_length}"
    end

    if type.min_length && String.length(value) < type.min_length do
      raise "valor #{inspect(value)} é menor que o tamanho mínimo #{type.min_length}"
    end

    value
  end

  # xs:pattern casa contra o valor inteiro, não uma substring — Regex.match?
  # do Elixir não ancora sozinho.
  defp anchored_regex(pattern), do: Regex.compile!("^(?:" <> pattern <> ")$")

  defp serialize_node(node) do
    case elem(node, 0) do
      :xmlText ->
        node |> xmlText(:value) |> List.to_string()

      :xmlElement ->
        tag = node |> xmlElement(:name) |> Atom.to_string()
        attributes = node |> xmlElement(:attributes) |> Enum.map_join("", &serialize_attribute/1)
        children = node |> xmlElement(:content) |> Enum.map_join("", &serialize_node/1)
        "<#{tag}#{attributes}>#{children}</#{tag}>"
    end
  end

  defp serialize_attribute(a) do
    name = xmlAttribute(a, :name)
    value = a |> xmlAttribute(:value) |> List.to_string() |> escape_attribute()
    ~s( #{name}="#{value}")
  end

  # --- construção (build) ---

  defp build_element(%Element{tag: tag, type: type}, term) do
    "<#{tag}#{build_attributes(type, term)}>#{build_content(type, term)}</#{tag}>"
  end

  defp build_attributes(%ComplexType{attributes: attributes}, term) when attributes != [] do
    map = Map.get(term, :attributes, %{})

    Enum.map_join(attributes, "", fn %Attribute{tag: tag} ->
      ~s( #{tag}="#{map |> Map.fetch!(tag) |> to_string() |> escape_attribute()}")
    end)
  end

  defp build_attributes(_type, _term), do: ""

  defp build_content(:opaque, term), do: term || ""
  defp build_content(%SimpleType{}, term), do: escape_text(to_string(term))

  defp build_content(%ComplexType{text: %SimpleType{}}, term) do
    escape_text(to_string(Map.fetch!(term, :value)))
  end

  defp build_content(%ComplexType{content: items}, term) do
    Enum.map_join(items, "", &build_item(&1, term))
  end

  defp build_item(%Element{tag: tag, max: 1} = element, term) do
    case Map.get(term, tag) do
      nil -> ""
      value -> build_element(element, value)
    end
  end

  defp build_item(%Element{tag: tag} = element, term) do
    term |> Map.get(tag, []) |> Enum.map_join("", &build_element(element, &1))
  end

  defp build_item(%Choice{options: options}, term) do
    case best_option(options, &Map.has_key?(term, &1)) do
      nil -> ""
      option -> build_option(option, term)
    end
  end

  defp build_option(%Element{} = element, term), do: build_item(element, term)

  defp build_option(members, term) when is_list(members),
    do: Enum.map_join(members, "", &build_item(&1, term))

  defp escape_text(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end

  defp escape_attribute(text), do: text |> escape_text() |> String.replace(~s("), "&quot;")
end
