defmodule PixSpiCatalog.Xsd.Leitor do
  @moduledoc """
  Lê um arquivo `.xsd` do catálogo com `:xmerl` e devolve os tipos nomeados
  (`complexType`, `simpleType`, `group`, `element` no nível raiz do schema)
  num mapa, prontos para o `Xsd.Compilador` resolver recursivamente.

  Não interpreta namespace de verdade — os XSDs do catálogo não usam
  `xs:import`, então basta o nome local de cada tag (`element`, não
  `xs:element`) e comparar por nome de tipo dentro do próprio arquivo.
  """

  import PixSpiCatalog.Xml.Registros

  @type definicao :: {:complexo | :simples | :grupo | :elemento, tuple()}
  @type t :: %{
          namespace: String.t(),
          raiz_nome: String.t(),
          raiz_tipo: String.t(),
          definicoes: %{String.t() => definicao()}
        }

  @spec ler(String.t()) :: t()
  def ler(caminho), do: caminho |> File.read!() |> ler_conteudo()

  @spec ler_conteudo(String.t()) :: t()
  def ler_conteudo(conteudo) do
    {raiz, _resto} = :xmerl_scan.string(:binary.bin_to_list(conteudo))
    filhos = elementos_filhos(raiz)

    definicoes =
      Enum.reduce(filhos, %{}, fn no, acc ->
        case {tag_local(no), atributo(no, "name")} do
          {"complexType", nome} when is_binary(nome) -> Map.put(acc, nome, {:complexo, no})
          {"simpleType", nome} when is_binary(nome) -> Map.put(acc, nome, {:simples, no})
          {"group", nome} when is_binary(nome) -> Map.put(acc, nome, {:grupo, no})
          {"element", nome} when is_binary(nome) -> Map.put(acc, nome, {:elemento, no})
          _ -> acc
        end
      end)

    elemento_raiz = Enum.find(filhos, &(tag_local(&1) == "element"))

    %{
      namespace: atributo(raiz, "targetNamespace"),
      raiz_nome: atributo(elemento_raiz, "name"),
      raiz_tipo: atributo(elemento_raiz, "type"),
      definicoes: definicoes
    }
  end

  @doc "Nome local da tag (sem o prefixo `xs:`)."
  @spec tag_local(tuple()) :: String.t()
  def tag_local(no) do
    no |> xmlElement(:name) |> Atom.to_string() |> String.split(":") |> List.last()
  end

  @doc "Filhos imediatos que são elementos (ignora texto e comentários)."
  @spec elementos_filhos(tuple()) :: [tuple()]
  def elementos_filhos(no) do
    no |> xmlElement(:content) |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlElement))
  end

  @doc "Valor de um atributo XML do nó, ou `nil` se ausente."
  @spec atributo(tuple(), String.t()) :: String.t() | nil
  def atributo(no, nome) do
    no
    |> xmlElement(:attributes)
    |> Enum.find_value(fn a ->
      if Atom.to_string(xmlAttribute(a, :name)) == nome do
        a |> xmlAttribute(:value) |> List.to_string()
      end
    end)
  end

  @doc "Texto direto do nó (concatenação dos filhos xmlText, sem espaço nas pontas)."
  @spec texto(tuple()) :: String.t()
  def texto(no) do
    no
    |> xmlElement(:content)
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlText))
    |> Enum.map_join("", fn t -> t |> xmlText(:value) |> List.to_string() end)
    |> String.trim()
  end
end
