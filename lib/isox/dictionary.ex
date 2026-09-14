defmodule Isox.Dictionary do
  @moduledoc """
  O que cada campo de cada mensagem quer dizer.

  Quem integra com o SPI passa boa parte do tempo com a planilha do catálogo
  aberta do lado do editor, só para descobrir que `dbtr_acct_id` é a conta do
  pagador e que `purp_cd` só aceita cinco valores. Este módulo traz essa
  informação para dentro do código.

      iex> {:ok, entrada} = Isox.Dictionary.field(Isox.Pacs008, :dbtr_acct_id)
      iex> entrada.name_br
      "contaUsuarioPagador"

  A mesma informação aparece de três formas, todas vindas da mesma fonte:

  - como dado, em `fields/1` e `field/2`, para quem quer montar tela, validar
    ou gerar formulário;
  - como texto para ler no IEx, em `explain/2`;
  - como tabela na documentação de cada mensagem, montada em tempo de
    compilação por `doc/1`. A tabela que você vê em `Isox.Pacs008` é esta
    aqui, renderizada.

  Isso é de propósito: descrição que mora em dois lugares diverge, e a que
  diverge é sempre a que alguém vai ler.

  ## De onde vêm as descrições

  Dos documentos que o Banco Central publica para o SPI: o XSD de cada
  mensagem, a planilha do catálogo (que traz o nome brasileiro, a
  obrigatoriedade, o tamanho e a tabela de domínios de cada campo) e os
  manuais do Pix.

  O texto das descrições é escrito aqui, não copiado de lá. O catálogo é a
  fonte normativa e continua sendo: em caso de divergência, quem manda é o
  documento oficial, e é para lá que `name_br` serve de chave de busca.

  ## O que não está aqui

  Só os campos que as structs do isox expõem. As structs cobrem o caminho
  comum de cada mensagem, não a árvore inteira do XSD, então ramos raros que
  a lib não modela também não aparecem no dicionário. `Isox.Pacs008`, por
  exemplo, não modela `Tax` nem `RmtInf.Strd`.
  """

  alias Isox.Dictionary.Entry

  @messages [
    Isox.AppHdr,
    Isox.Admi002,
    Isox.Admi004,
    Isox.Camt014,
    Isox.Camt025,
    Isox.Camt029,
    Isox.Camt052,
    Isox.Camt053,
    Isox.Camt054,
    Isox.Camt055,
    Isox.Camt060,
    Isox.Pacs002,
    Isox.Pacs004,
    Isox.Pacs008,
    Isox.Pain009,
    Isox.Pain011,
    Isox.Pain012,
    Isox.Pain013,
    Isox.Pain014,
    Isox.Pibr001,
    Isox.Pibr002,
    Isox.Reda014,
    Isox.Reda016,
    Isox.Reda017,
    Isox.Reda022,
    Isox.Reda031,
    Isox.Reda041,
    Isox.Trck002
  ]

  @doc """
  Mensagens que o dicionário cobre.
  """
  @spec messages() :: [module()]
  def messages, do: @messages

  @doc """
  Todos os campos de uma mensagem, na ordem em que aparecem no XML.

      iex> Isox.Dictionary.fields(Isox.Pibr001) |> Enum.map(& &1.field)
      [:msg_id, :created_at, :data]
  """
  @spec fields(module()) :: [Entry.t()]
  def fields(message) do
    case data_module(message) do
      {:ok, module} -> module.entries()
      :error -> []
    end
  end

  @doc """
  Um campo específico.

      iex> {:ok, entrada} = Isox.Dictionary.field(Isox.Pacs008, :purp_cd)
      iex> entrada.name_br
      "finalidadeDaTransacao"

      iex> Isox.Dictionary.field(Isox.Pacs008, :nao_existe)
      :error
  """
  @spec field(module(), atom()) :: {:ok, Entry.t()} | :error
  def field(message, field) do
    candidatos = Enum.filter(fields(message), &(&1.field == field))

    case Enum.find(candidatos, &is_nil(&1.within)) || List.first(candidatos) do
      nil -> :error
      entry -> {:ok, entry}
    end
  end

  @doc """
  Os valores aceitos por um campo de domínio, com o significado de cada um.

      iex> {:ok, codigos} = Isox.Dictionary.codes(Isox.Pacs008, :purp_cd)
      iex> codigos["GSCB"]
      "Pix Troco: compra com saque de dinheiro em espécie no mesmo pagamento."

  Devolve `:error` para campo que não é de domínio (texto livre, valor, data)
  e para campo que não existe.

  As tabelas de rejeição estão aqui, incluindo a do `pacs.002`, que é a mais
  consultada de quem integra com o SPI. São também as que mais mudam de uma
  versão do catálogo para outra: confira contra a versão que você está
  usando antes de tratar qualquer código como definitivo.
  """
  @spec codes(module(), atom()) :: {:ok, %{optional(String.t()) => String.t()}} | :error
  def codes(message, field) do
    case field(message, field) do
      {:ok, %Entry{codes: codes}} when is_map(codes) -> {:ok, codes}
      _ -> :error
    end
  end

  @doc """
  Procura um termo em todos os campos de todas as mensagens.

  Busca no nome do campo na struct, no nome brasileiro, no caminho XML e na
  descrição. Ignora acento e caixa, porque ninguém lembra se o catálogo
  escreveu "transacao" ou "transação".

      iex> Isox.Dictionary.search("idFimAFim") |> Enum.any?(fn {m, e} ->
      ...>   m == Isox.Pacs008 and e.field == :end_to_end_id
      ...> end)
      true
  """
  @spec search(String.t()) :: [{module(), Entry.t()}]
  def search(term) do
    needles = term |> normalize() |> String.split(" ", trim: true)

    for message <- @messages,
        entry <- fields(message),
        matches?(entry, needles),
        do: {message, entry}
  end

  @doc """
  O campo explicado em texto corrido, para ler no IEx.

      Isox.Pacs008 |> Isox.Dictionary.explain(:dbtr_acct_id) |> IO.puts()
  """
  @spec explain(module(), atom()) :: String.t()
  def explain(message, field) do
    case field(message, field) do
      {:ok, entry} -> render_entry(message, entry) <> children_text(message, entry)
      :error -> "#{inspect(message)} não tem campo #{inspect(field)}."
    end
  end

  @doc """
  O bloco de documentação de uma mensagem, em Markdown.

  Chamado em tempo de compilação pelo `@moduledoc` de cada mensagem, para a
  tabela de campos ser a mesma coisa que a API devolve.
  """
  @spec doc(module()) :: String.t()
  def doc(message) do
    entries = fields(message)

    [fields_table(entries), domains_section(entries)]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  defp field_label(%Entry{within: nil, field: field}), do: to_string(field)
  defp field_label(%Entry{within: parent, field: field}), do: "#{parent}[].#{field}"

  defp fields_table([]), do: ""

  defp fields_table(entries) do
    linhas =
      Enum.map_join(entries, "\n", fn e ->
        "| `#{field_label(e)}` | #{catalog_name(e)} | #{type_label(e)} | #{requirement_label(e.requirement)} | #{e.what} |"
      end)

    """
    ## Campos

    | Campo | Nome no catálogo | Tipo | Obrig. | O que é |
    | --- | --- | --- | --- | --- |
    #{linhas}

    Caminho no XML e regra de preenchimento de cada campo:
    `Isox.Dictionary.explain/2`.
    """
    |> String.trim_trailing()
  end

  defp domains_section(entries) do
    case Enum.filter(entries, &is_map(&1.codes)) do
      [] -> ""
      com_codigos -> "## Domínios\n\n" <> Enum.map_join(com_codigos, "\n\n", &domain_block/1)
    end
  end

  defp domain_block(entry) do
    valores =
      entry.codes
      |> Enum.sort()
      |> Enum.map_join("\n", fn {codigo, texto} -> "- `#{codigo}`: #{texto}" end)

    "**`#{field_label(entry)}`**\n\n#{valores}"
  end

  defp children_text(message, %Entry{within: nil, field: field}) do
    case Enum.filter(fields(message), &(&1.within == field)) do
      [] ->
        ""

      filhos ->
        linhas =
          Enum.map_join(filhos, "\n", fn f ->
            "                 #{f.field}: #{f.what}"
          end)

        "\nCada item traz\n" <> linhas
    end
  end

  defp children_text(_message, _entry), do: ""

  defp render_entry(message, entry) do
    [
      {"Campo", "#{inspect(message)}.#{field_label(entry)}"},
      {"Nome no catálogo", entry.name_br},
      {"Caminho XML", entry.xml},
      {"Tipo", type_label(entry)},
      {"Obrigatório", requirement_label(entry.requirement)},
      {"O que é", entry.what},
      {"Regra", entry.rule},
      {"Valores", codes_text(entry.codes)}
    ]
    |> Enum.reject(fn {_rotulo, valor} -> valor in [nil, ""] end)
    |> Enum.map_join("\n", fn {rotulo, valor} -> "#{String.pad_trailing(rotulo, 17)}#{valor}" end)
  end

  defp codes_text(nil), do: nil

  defp codes_text(codes) do
    codes
    |> Enum.sort()
    |> Enum.map_join("\n" <> String.duplicate(" ", 17), fn {codigo, texto} ->
      "#{codigo}: #{texto}"
    end)
  end

  defp catalog_name(%Entry{name_br: nil}), do: ""
  defp catalog_name(%Entry{name_br: nome}), do: "`#{nome}`"

  defp type_label(%Entry{type: type, length: nil}), do: type_name(type)
  defp type_label(%Entry{type: type, length: tamanho}), do: "#{type_name(type)}, #{tamanho}"

  defp type_name(:text), do: "texto"
  defp type_name(:numeric), do: "numérico"
  defp type_name(:amount), do: "valor"
  defp type_name(:date), do: "data"
  defp type_name(:datetime), do: "data e hora"
  defp type_name(:code), do: "domínio"
  defp type_name(:indicator), do: "booleano"

  defp requirement_label(:required), do: "sim"
  defp requirement_label(:optional), do: "não"
  defp requirement_label(:conditional), do: "depende"

  defp matches?(entry, needles) do
    alvo =
      [entry.field, entry.name_br, entry.xml, entry.what, entry.rule]
      |> Enum.reject(&is_nil/1)
      |> Enum.map_join(" ", &to_string/1)
      |> normalize()

    Enum.all?(needles, &String.contains?(alvo, &1))
  end

  defp normalize(text) do
    text
    |> String.downcase()
    |> :unicode.characters_to_nfd_binary()
    |> String.replace(~r/[\x{0300}-\x{036f}]/u, "")
  end

  defp data_module(message) do
    with true <- message in @messages,
         module = Module.concat(Isox.Dictionary, message |> Module.split() |> List.last()),
         true <- Code.ensure_loaded?(module) do
      {:ok, module}
    else
      false -> :error
    end
  end
end
