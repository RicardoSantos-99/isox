defmodule PixSpiCatalog.Xsd.Compilador do
  @moduledoc """
  Resolve recursivamente as definições lidas pelo `Xsd.Leitor` numa árvore
  de `PixSpiCatalog.Schema` — sem indireção por nome: todo tipo referenciado
  já sai embutido no lugar.

  Cobre o subconjunto de XSD usado pelo catálogo (confirmado por varredura
  em todos os XSDs de v5.12.1/v5.13.1): `element`, `complexType`,
  `simpleType`/`restriction`, `choice`, `group` (só `ref`, nunca aninhado
  fora de uma sequência ou escolha), `simpleContent`/`extension`/`attribute`
  (o padrão valor+moeda, ex. `IntrBkSttlmAmt`), `element ref=` e `xs:any`
  (tratado como opaco — é só o `<Sgntr>`).

  Limitação conhecida: `xs:group ref=` dentro de um `xs:choice` (só ocorre
  em `reda.022`) é achatado como se cada elemento do grupo fosse uma opção
  independente da escolha, em vez de "o grupo inteiro é uma opção". Corrige
  quando `reda.022` ganhar lógica de negócio (Fase 6.4).
  """

  alias PixSpiCatalog.Schema.{Atributo, Elemento, Escolha, TipoComplexo, TipoSimples}
  alias PixSpiCatalog.Xsd.Leitor

  @doc "Resolve o elemento raiz de um XSD já lido em `Leitor.t()` para um `Schema.Elemento`."
  @spec resolver_raiz(Leitor.t()) :: Elemento.t()
  def resolver_raiz(%{raiz_nome: nome, raiz_tipo: tipo, definicoes: definicoes}) do
    %Elemento{tag: nome, tipo: resolver_tipo_por_nome(tipo, definicoes)}
  end

  @doc "Resolve um `<xs:element>` (com `type=`, `ref=` ou tipo anônimo aninhado) para um `Schema.Elemento`."
  @spec resolver_elemento(tuple(), map()) :: Elemento.t()
  def resolver_elemento(no, definicoes) do
    min = ocorrencia(no, "minOccurs", 1)
    max = ocorrencia(no, "maxOccurs", 1)

    cond do
      ref = Leitor.atributo(no, "ref") ->
        {:elemento, no_ref} = Map.fetch!(definicoes, ref)
        %{resolver_elemento(no_ref, definicoes) | min: min, max: max}

      tipo_nome = Leitor.atributo(no, "type") ->
        %Elemento{
          tag: Leitor.atributo(no, "name"),
          tipo: resolver_tipo_por_nome(tipo_nome, definicoes),
          min: min,
          max: max
        }

      true ->
        filho =
          no
          |> Leitor.elementos_filhos()
          |> Enum.find(&(Leitor.tag_local(&1) in ["complexType", "simpleType"]))

        %Elemento{
          tag: Leitor.atributo(no, "name"),
          tipo: resolver_tipo_inline(filho, definicoes),
          min: min,
          max: max
        }
    end
  end

  defp resolver_tipo_por_nome("xs:" <> base, _definicoes), do: %TipoSimples{base: base}

  defp resolver_tipo_por_nome(nome, definicoes) do
    case Map.fetch!(definicoes, nome) do
      {:complexo, no} -> resolver_complexo(no, definicoes)
      {:simples, no} -> resolver_simples(no)
    end
  end

  defp resolver_tipo_inline(no, definicoes) do
    case Leitor.tag_local(no) do
      "complexType" -> resolver_complexo(no, definicoes)
      "simpleType" -> resolver_simples(no)
    end
  end

  @spec resolver_complexo(tuple(), map()) :: TipoComplexo.t() | :opaco
  def resolver_complexo(no, definicoes) do
    filhos = Leitor.elementos_filhos(no)

    cond do
      simple_content = Enum.find(filhos, &(Leitor.tag_local(&1) == "simpleContent")) ->
        resolver_simple_content(simple_content, definicoes)

      container = Enum.find(filhos, &(Leitor.tag_local(&1) in ["sequence", "choice"])) ->
        cond do
          apenas_any?(container) ->
            :opaco

          Leitor.tag_local(container) == "choice" ->
            %TipoComplexo{
              conteudo: [resolver_escolha(container, definicoes)],
              atributos: resolver_atributos_diretos(filhos, definicoes)
            }

          true ->
            %TipoComplexo{
              conteudo: resolver_container(container, definicoes),
              atributos: resolver_atributos_diretos(filhos, definicoes)
            }
        end

      true ->
        %TipoComplexo{conteudo: []}
    end
  end

  defp apenas_any?(container) do
    case Leitor.elementos_filhos(container) do
      [unico] -> Leitor.tag_local(unico) == "any"
      _ -> false
    end
  end

  defp resolver_container(no, definicoes) do
    no
    |> Leitor.elementos_filhos()
    |> Enum.flat_map(fn filho ->
      case Leitor.tag_local(filho) do
        "element" -> [resolver_elemento(filho, definicoes)]
        "choice" -> [resolver_escolha(filho, definicoes)]
        "group" -> resolver_grupo_ref(filho, definicoes)
        _ -> []
      end
    end)
  end

  defp resolver_escolha(no, definicoes) do
    opcoes =
      no
      |> Leitor.elementos_filhos()
      |> Enum.flat_map(fn filho ->
        case Leitor.tag_local(filho) do
          "element" -> [resolver_elemento(filho, definicoes)]
          "group" -> resolver_grupo_ref(filho, definicoes)
          _ -> []
        end
      end)

    %Escolha{
      opcoes: opcoes,
      min: ocorrencia(no, "minOccurs", 1),
      max: ocorrencia(no, "maxOccurs", 1)
    }
  end

  defp resolver_grupo_ref(no, definicoes) do
    nome = Leitor.atributo(no, "ref")
    {:grupo, no_grupo} = Map.fetch!(definicoes, nome)

    no_grupo
    |> Leitor.elementos_filhos()
    |> Enum.find(&(Leitor.tag_local(&1) in ["sequence", "choice"]))
    |> resolver_container(definicoes)
  end

  defp resolver_atributos_diretos(filhos, definicoes) do
    filhos
    |> Enum.filter(&(Leitor.tag_local(&1) == "attribute"))
    |> Enum.map(&resolver_atributo(&1, definicoes))
  end

  defp resolver_atributo(no, definicoes) do
    tipo_nome = Leitor.atributo(no, "type")

    %Atributo{
      tag: Leitor.atributo(no, "name"),
      tipo: resolver_tipo_por_nome(tipo_nome, definicoes),
      obrigatorio: Leitor.atributo(no, "use") != "optional"
    }
  end

  defp resolver_simple_content(no, definicoes) do
    extensao =
      no |> Leitor.elementos_filhos() |> Enum.find(&(Leitor.tag_local(&1) == "extension"))

    base = Leitor.atributo(extensao, "base")

    atributos =
      extensao
      |> Leitor.elementos_filhos()
      |> resolver_atributos_diretos(definicoes)

    %TipoComplexo{texto: resolver_tipo_por_nome(base, definicoes), atributos: atributos}
  end

  @spec resolver_simples(tuple()) :: TipoSimples.t()
  def resolver_simples(no) do
    restricao =
      no |> Leitor.elementos_filhos() |> Enum.find(&(Leitor.tag_local(&1) == "restriction"))

    "xs:" <> base = Leitor.atributo(restricao, "base")
    filhos = Leitor.elementos_filhos(restricao)

    %TipoSimples{
      base: base,
      pattern: valor_unico(filhos, "pattern"),
      enum: valores(filhos, "enumeration"),
      max_length: valor_inteiro(filhos, "maxLength"),
      min_length: valor_inteiro(filhos, "minLength")
    }
  end

  defp valor_unico(filhos, tag) do
    case Enum.find(filhos, &(Leitor.tag_local(&1) == tag)) do
      nil -> nil
      no -> Leitor.atributo(no, "value")
    end
  end

  defp valores(filhos, tag) do
    case Enum.filter(filhos, &(Leitor.tag_local(&1) == tag)) do
      [] -> nil
      encontrados -> Enum.map(encontrados, &Leitor.atributo(&1, "value"))
    end
  end

  defp valor_inteiro(filhos, tag) do
    case valor_unico(filhos, tag) do
      nil -> nil
      valor -> String.to_integer(valor)
    end
  end

  defp ocorrencia(no, atributo, padrao) do
    case Leitor.atributo(no, atributo) do
      nil -> padrao
      "unbounded" -> :ilimitado
      valor -> String.to_integer(valor)
    end
  end
end
