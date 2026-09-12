defmodule PixSpiCatalog.Xml.Codec do
  @moduledoc """
  Motor genérico de `parse`/`build` orientado a `PixSpiCatalog.Schema` — não
  conhece nenhuma mensagem específica, só percorre a árvore do schema contra
  o XML (na entrada) ou contra o termo genérico (na saída).

  O termo genérico é: valor simples vira string; elemento complexo normal
  vira mapa `%{tag => valor}` (lista quando `max` permite repetição);
  `simpleContent` (valor + atributo, ex. `IntrBkSttlmAmt`) vira
  `%{valor: ..., atributos: %{tag => valor}}`; `:opaco` (`<Sgntr>`) vira a
  string do XML interno, sem interpretar.

  Validação (pattern/enum/tamanho) acontece no `parse`; o `build` confia no
  termo que recebe.

  `compilar_template/3` + `renderizar/2` são a terceira API do ADR 0003:
  compila um termo com lacunas (`lacuna/1`) uma vez, e cada renderização
  só preenche as lacunas — sem percorrer o schema de novo.
  """

  import PixSpiCatalog.Xml.Registros

  alias PixSpiCatalog.Schema.{Atributo, Elemento, Escolha, TipoComplexo, TipoSimples}

  @doc "Parseia um XML contra o schema (a raiz, um `Schema.Elemento`)."
  @spec parse(Elemento.t(), binary()) :: {:ok, term()} | {:error, String.t()}
  def parse(%Elemento{} = schema, xml) when is_binary(xml) do
    # bytes crus, não codepoints já decodificados: o prólogo declara
    # encoding="UTF-8" e é o próprio xmerl quem decodifica a partir disso.
    {no, _resto} = :xmerl_scan.string(:binary.bin_to_list(xml))
    {:ok, extrair_tipo(no, schema.tipo)}
  rescue
    e -> {:error, Exception.message(e)}
  catch
    # XML malformado faz o xmerl sair com exit, não raise — e isso não pode
    # derrubar o processo chamador; é entrada não confiável (PSP), não bug.
    :exit, motivo -> {:error, inspect(motivo)}
  end

  @doc """
  Monta o XML (com prólogo) a partir do termo genérico, contra o schema.

  `namespace`, quando dado, vira o `xmlns` da tag raiz — namespace é
  declaração XML, não um `xs:attribute` do schema, então não é modelado
  como atributo comum; sem ele, o XML montado não teria como ser
  redespachado por `Registro.parse/1`.
  """
  @spec build(Elemento.t(), term(), String.t() | nil) :: {:ok, binary()} | {:error, String.t()}
  def build(%Elemento{} = schema, termo, namespace \\ nil) do
    corpo =
      schema
      |> construir_elemento(termo)
      |> injetar_xmlns(schema.tag, namespace)

    {:ok, ~s(<?xml version="1.0" encoding="UTF-8"?>) <> corpo}
  rescue
    e -> {:error, Exception.message(e)}
  end

  defp injetar_xmlns(corpo, _tag, nil), do: corpo

  defp injetar_xmlns(corpo, tag, namespace) do
    String.replace(corpo, "<#{tag}>", ~s(<#{tag} xmlns="#{escapar_atributo(namespace)}">),
      global: false
    )
  end

  # --- template canônico (ADR 0003) ---

  @typedoc "Template compilado: trechos fixos intercalados com lacunas a preencher depois."
  @type template :: [binary() | {:lacuna, atom()}]

  @doc """
  Marcador de lacuna: usa no lugar de um valor real, num termo passado para
  `compilar_template/3`, pra dizer "isso varia, preenche depois".
  """
  @spec lacuna(atom()) :: binary()
  def lacuna(chave) when is_atom(chave), do: <<0>> <> Atom.to_string(chave) <> <<0>>

  @doc """
  Compila `{schema, termo com lacunas}` num template canônico: monta o XML
  normalmente (reaproveita `build/3`, mesma árvore, mesma validação de
  atributo obrigatório) e depois separa os trechos fixos das lacunas — sem
  percorrer o schema de novo. Pensado pro caminho quente do simulador: o
  custo de percorrer a árvore é pago uma vez aqui, não a cada mensagem.
  """
  @spec compilar_template(Elemento.t(), term(), String.t() | nil) ::
          {:ok, template()} | {:error, String.t()}
  def compilar_template(%Elemento{} = schema, termo_com_lacunas, namespace \\ nil) do
    with {:ok, xml} <- build(schema, termo_com_lacunas, namespace) do
      {:ok, fatiar_lacunas(xml)}
    end
  end

  @doc "Preenche as lacunas de um template já compilado, produzindo o XML final."
  @spec renderizar(template(), %{atom() => term()}) :: binary()
  def renderizar(template, campos_variaveis) do
    Enum.map_join(template, "", fn
      {:lacuna, chave} -> campos_variaveis |> Map.fetch!(chave) |> to_string() |> escapar_texto()
      fixo -> fixo
    end)
  end

  @lacuna_regex ~r/\x00([a-zA-Z_][a-zA-Z0-9_]*)\x00/

  defp fatiar_lacunas(xml) do
    @lacuna_regex
    |> Regex.split(xml, include_captures: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&segmento/1)
  end

  defp segmento(<<0, resto::binary>>),
    do: {:lacuna, resto |> String.trim_trailing(<<0>>) |> String.to_existing_atom()}

  defp segmento(fixo), do: fixo

  # --- extração (parse) ---

  defp extrair_tipo(_no, :opaco), do: nil
  defp extrair_tipo(no, %TipoSimples{} = tipo), do: no |> texto_direto() |> validar!(tipo)

  defp extrair_tipo(no, %TipoComplexo{texto: %TipoSimples{} = tipo_texto} = tipo) do
    %{
      valor: no |> texto_direto() |> validar!(tipo_texto),
      atributos: extrair_atributos(no, tipo.atributos)
    }
  end

  defp extrair_tipo(no, %TipoComplexo{conteudo: itens}) do
    agrupados = agrupar_por_tag(no)
    Enum.reduce(itens, %{}, fn item, acc -> Map.merge(acc, extrair_item(item, agrupados)) end)
  end

  defp extrair_conteudo_opaco(no),
    do: no |> xmlElement(:content) |> Enum.map_join("", &serializar_no/1)

  defp extrair_item(%Elemento{tipo: :opaco, tag: tag, min: min}, agrupados) do
    case Map.get(agrupados, tag, []) do
      [unico] -> %{tag => extrair_conteudo_opaco(unico)}
      [] when min == 0 -> %{}
      [] -> raise "elemento obrigatório ausente: #{tag}"
    end
  end

  defp extrair_item(%Elemento{tag: tag, tipo: tipo, min: min, max: 1}, agrupados) do
    case Map.get(agrupados, tag, []) do
      [unico] -> %{tag => extrair_tipo(unico, tipo)}
      [] when min == 0 -> %{}
      [] -> raise "elemento obrigatório ausente: #{tag}"
      _ -> raise "elemento #{tag} apareceu mais de uma vez, mas a cardinalidade máxima é 1"
    end
  end

  defp extrair_item(%Elemento{tag: tag, tipo: tipo, min: min}, agrupados) do
    filhos = Map.get(agrupados, tag, [])

    if length(filhos) < min do
      raise "elemento #{tag}: esperado ao menos #{min}, vieram #{length(filhos)}"
    end

    %{tag => Enum.map(filhos, &extrair_tipo(&1, tipo))}
  end

  defp extrair_item(%Escolha{opcoes: opcoes, min: min}, agrupados) do
    case Enum.find(opcoes, &Map.has_key?(agrupados, &1.tag)) do
      nil when min == 0 ->
        %{}

      nil ->
        raise "nenhuma opção da escolha está presente: #{inspect(Enum.map(opcoes, & &1.tag))}"

      elemento ->
        extrair_item(elemento, agrupados)
    end
  end

  defp agrupar_por_tag(no) do
    no
    |> xmlElement(:content)
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlElement))
    |> Enum.group_by(&(&1 |> xmlElement(:name) |> Atom.to_string()))
  end

  defp extrair_atributos(no, atributos_schema) do
    brutos = xmlElement(no, :attributes)

    Enum.reduce(atributos_schema, %{}, fn %Atributo{tag: tag, tipo: tipo}, acc ->
      case valor_atributo(brutos, tag) do
        nil -> acc
        valor -> Map.put(acc, tag, validar!(valor, tipo))
      end
    end)
  end

  defp valor_atributo(brutos, tag) do
    Enum.find_value(brutos, fn a ->
      if Atom.to_string(xmlAttribute(a, :name)) == tag,
        do: a |> xmlAttribute(:value) |> List.to_string()
    end)
  end

  defp texto_direto(no) do
    no
    |> xmlElement(:content)
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :xmlText))
    |> Enum.map_join("", fn t -> t |> xmlText(:value) |> List.to_string() end)
    |> String.trim()
  end

  defp validar!(valor, %TipoSimples{} = tipo) do
    if tipo.pattern && not Regex.match?(regex_ancorado(tipo.pattern), valor) do
      raise "valor #{inspect(valor)} não bate com o padrão #{tipo.pattern}"
    end

    if tipo.enum && valor not in tipo.enum do
      raise "valor #{inspect(valor)} não está entre #{inspect(tipo.enum)}"
    end

    if tipo.max_length && String.length(valor) > tipo.max_length do
      raise "valor #{inspect(valor)} excede o tamanho máximo #{tipo.max_length}"
    end

    if tipo.min_length && String.length(valor) < tipo.min_length do
      raise "valor #{inspect(valor)} é menor que o tamanho mínimo #{tipo.min_length}"
    end

    valor
  end

  # xs:pattern casa contra o valor inteiro, não uma substring — Regex.match?
  # do Elixir não ancora sozinho.
  defp regex_ancorado(pattern), do: Regex.compile!("^(?:" <> pattern <> ")$")

  defp serializar_no(no) do
    case elem(no, 0) do
      :xmlText ->
        no |> xmlText(:value) |> List.to_string()

      :xmlElement ->
        tag = no |> xmlElement(:name) |> Atom.to_string()
        atributos = no |> xmlElement(:attributes) |> Enum.map_join("", &serializar_atributo/1)
        filhos = no |> xmlElement(:content) |> Enum.map_join("", &serializar_no/1)
        "<#{tag}#{atributos}>#{filhos}</#{tag}>"
    end
  end

  defp serializar_atributo(a) do
    nome = xmlAttribute(a, :name)
    valor = a |> xmlAttribute(:value) |> List.to_string() |> escapar_atributo()
    ~s( #{nome}="#{valor}")
  end

  # --- construção (build) ---

  defp construir_elemento(%Elemento{tag: tag, tipo: tipo}, termo) do
    "<#{tag}#{construir_atributos(tipo, termo)}>#{construir_conteudo(tipo, termo)}</#{tag}>"
  end

  defp construir_atributos(%TipoComplexo{atributos: atributos}, termo) when atributos != [] do
    mapa = Map.get(termo, :atributos, %{})

    Enum.map_join(atributos, "", fn %Atributo{tag: tag} ->
      ~s( #{tag}="#{mapa |> Map.fetch!(tag) |> to_string() |> escapar_atributo()}")
    end)
  end

  defp construir_atributos(_tipo, _termo), do: ""

  defp construir_conteudo(:opaco, termo), do: termo || ""
  defp construir_conteudo(%TipoSimples{}, termo), do: escapar_texto(to_string(termo))

  defp construir_conteudo(%TipoComplexo{texto: %TipoSimples{}}, termo) do
    escapar_texto(to_string(Map.fetch!(termo, :valor)))
  end

  defp construir_conteudo(%TipoComplexo{conteudo: itens}, termo) do
    Enum.map_join(itens, "", &construir_item(&1, termo))
  end

  defp construir_item(%Elemento{tag: tag, max: 1} = elemento, termo) do
    case Map.get(termo, tag) do
      nil -> ""
      valor -> construir_elemento(elemento, valor)
    end
  end

  defp construir_item(%Elemento{tag: tag} = elemento, termo) do
    termo |> Map.get(tag, []) |> Enum.map_join("", &construir_elemento(elemento, &1))
  end

  defp construir_item(%Escolha{opcoes: opcoes}, termo) do
    case Enum.find(opcoes, &Map.has_key?(termo, &1.tag)) do
      nil -> ""
      elemento -> construir_item(elemento, termo)
    end
  end

  defp escapar_texto(texto) do
    texto
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end

  defp escapar_atributo(texto), do: texto |> escapar_texto() |> String.replace(~s("), "&quot;")
end
