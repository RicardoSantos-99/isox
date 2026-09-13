defmodule Isox.Xsd.Reader do
  # Lê um arquivo .xsd do catálogo com :xmerl e devolve os tipos nomeados
  # (complexType, simpleType, group, element no nível raiz do schema)
  # num mapa, prontos para o Xsd.Compiler resolver recursivamente.
  #
  # Não interpreta namespace de verdade — os XSDs do catálogo não usam
  # xs:import, então basta o nome local de cada tag (element, não
  # xs:element) e comparar por nome de tipo dentro do próprio arquivo.
  #
  # Suporte de mix catalog.gen — não é API pública da lib.
  @moduledoc false

  import Isox.Xml.Records

  @type definition :: {:complex_type | :simple_type | :group | :element, tuple()}
  @type t :: %{
          namespace: String.t(),
          root_name: String.t(),
          root_type: String.t(),
          definitions: %{String.t() => definition()}
        }

  @doc "Lê e interpreta o `.xsd` no caminho dado. Ver `read_content/1`."
  @spec read(String.t()) :: t()
  def read(path), do: path |> File.read!() |> read_content()

  @doc """
  Interpreta o conteúdo de um `.xsd` já em memória: namespace alvo, tipo e
  nome do elemento raiz do schema, e um mapa de todas as definições
  nomeadas de nível superior (`complexType`/`simpleType`/`group`/`element`),
  prontas para `Isox.Xsd.Compiler` resolver recursivamente.
  """
  @spec read_content(String.t()) :: t()
  def read_content(content) do
    {root, _rest} = :xmerl_scan.string(:binary.bin_to_list(content))
    children = child_elements(root)

    definitions =
      Enum.reduce(children, %{}, fn node, acc ->
        case {local_tag(node), attribute(node, "name")} do
          {"complexType", name} when is_binary(name) -> Map.put(acc, name, {:complex_type, node})
          {"simpleType", name} when is_binary(name) -> Map.put(acc, name, {:simple_type, node})
          {"group", name} when is_binary(name) -> Map.put(acc, name, {:group, node})
          {"element", name} when is_binary(name) -> Map.put(acc, name, {:element, node})
          _ -> acc
        end
      end)

    root_element = Enum.find(children, &(local_tag(&1) == "element"))

    %{
      namespace: attribute(root, "targetNamespace"),
      root_name: attribute(root_element, "name"),
      root_type: attribute(root_element, "type"),
      definitions: definitions
    }
  end

  @doc "Nome local da tag (sem o prefixo `xs:`)."
  @spec local_tag(tuple()) :: String.t()
  def local_tag(node) do
    node |> xmlElement(:name) |> Atom.to_string() |> String.split(":") |> List.last()
  end

  @doc "Filhos imediatos que são elementos (ignora texto e comentários)."
  @spec child_elements(tuple()) :: [tuple()]
  def child_elements(node) do
    node |> xmlElement(:content) |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlElement))
  end

  @doc "Valor de um atributo XML do nó, ou `nil` se ausente."
  @spec attribute(tuple(), String.t()) :: String.t() | nil
  def attribute(node, name) do
    node
    |> xmlElement(:attributes)
    |> Enum.find_value(fn a ->
      if Atom.to_string(xmlAttribute(a, :name)) == name do
        a |> xmlAttribute(:value) |> List.to_string()
      end
    end)
  end

  @doc "Texto direto do nó (concatenação dos filhos xmlText, sem espaço nas pontas)."
  @spec text(tuple()) :: String.t()
  def text(node) do
    node
    |> xmlElement(:content)
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlText))
    |> Enum.map_join("", fn t -> t |> xmlText(:value) |> List.to_string() end)
    |> String.trim()
  end
end
