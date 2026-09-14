defmodule Isox.Pacs002 do
  @moduledoc """
  Relatório de status: a resposta a uma `Isox.Pacs008` ou a uma
  `Isox.Pacs004`.

  Versões 1.16 e 1.17 (ADR 0002). Aponta a mensagem original por
  `orgnl_instr_id` e `orgnl_end_to_end_id`, e diz em `tx_sts` o que
  aconteceu. Quando rejeitou, `sts_rsn_cd` diz por quê.

  Repare na diferença entre os dois identificadores: `orgnl_instr_id`
  aceita tanto pagamento quanto devolução, e `orgnl_end_to_end_id` só
  aceita pagamento. É o que permite responder a uma devolução ainda
  apontando para o pagamento que a originou.

  ## Lote

  `TxInfAndSts` é ilimitado no XSD, e o catálogo documenta lote de
  verdade (`pacs.002_SPI_10_msg.xml`, 10 transações numa mensagem só).
  `encode/3` aceita uma mensagem ou uma lista, e `decode/1` devolve uma
  struct ou uma lista, conforme o XML.

  `StsRsnInf` segue modelado como no máximo um motivo por transação, com
  sua lista de `AddtlInf`.

  ## Validação

  `encode/3` confere os campos obrigatórios e depois faz o caminho de
  volta pelo módulo gerado, reaproveitando a validação de pattern, enum e
  cardinalidade. Isso inclui o enum de `Rsn.Cd`, que diverge entre 1.16 e
  1.17.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pacs002.{V1_16, V1_17}

  @type version :: :v1_16 | :v1_17

  defstruct [
    :msg_id,
    :created_at,
    :orgnl_instr_id,
    :orgnl_end_to_end_id,
    :tx_sts,
    :sts_rsn_cd,
    :fctv_intr_bk_sttlm_dt,
    :orgnl_intr_bk_sttlm_dt,
    sts_rsn_addtl_inf: []
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          orgnl_instr_id: String.t(),
          orgnl_end_to_end_id: String.t(),
          tx_sts: String.t(),
          sts_rsn_cd: String.t() | nil,
          sts_rsn_addtl_inf: [String.t()],
          fctv_intr_bk_sttlm_dt: DateTime.t() | nil,
          orgnl_intr_bk_sttlm_dt: Date.t() | nil
        }

  @required_fields [
    :msg_id,
    :created_at,
    :orgnl_instr_id,
    :orgnl_end_to_end_id,
    :tx_sts
  ]

  @module_by_version %{v1_16: V1_16, v1_17: V1_17}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista de mensagens (lote: vira várias
  `TxInfAndSts` na mesma `Document`, com `NbOfTxs` implícito no XSD desta
  mensagem).

  `msg_id`/`created_at` são campos de `GrpHdr` (um por mensagem XML,
  não por transação). Em lote, precisam ser iguais em todos os itens da
  lista; se divergirem, `encode/3` erra em vez de escolher um deles em
  silêncio.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v1_16, :v1_17] do
    with :ok <- validate_all_required(messages),
         :ok <- validate_shared_header(messages) do
      module = Map.fetch!(@module_by_version, version)
      [first | _] = messages

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(first, messages)
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc """
  Decodifica um XML de pacs.002 (qualquer versão) de volta para a
  struct, ou para uma lista de structs quando a mensagem traz mais de uma `TxInfAndSts` (lote), para
  uma lista de structs, uma por transação.
  """
  @spec decode(binary()) :: {:ok, t() | [t(), ...], version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    with {:ok, module, term} <- Isox.Registry.decode(xml),
         {:ok, version} <- version_for(module),
         {:ok, message_or_messages} <- struct_from_term(term) do
      {:ok, message_or_messages, version}
    end
  end

  defp version_for(module) do
    case Map.fetch(@version_by_module, module) do
      {:ok, version} -> {:ok, version}
      :error -> {:error, {:not_pacs002, module.msg_def_idr()}}
    end
  end

  defp confirm(module, xml) do
    case module.decode(xml) do
      {:ok, _term} -> {:ok, xml}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_all_required(messages) do
    Enum.reduce_while(messages, :ok, fn message, :ok ->
      case validate_required(message) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_required(message) do
    missing = Enum.filter(@required_fields, &(Map.get(message, &1) in [nil, ""]))

    if missing == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(missing)}"}
  end

  defp validate_shared_header([_single]), do: :ok

  defp validate_shared_header([%{msg_id: msg_id, created_at: created_at} | rest]) do
    if Enum.all?(rest, &(&1.msg_id == msg_id and &1.created_at == created_at)) do
      :ok
    else
      {:error, "msg_id/created_at precisam ser iguais em todas as mensagens do lote"}
    end
  end

  defp document_term(first, messages) do
    %{
      "FIToFIPmtStsRpt" => %{
        "GrpHdr" => %{"MsgId" => first.msg_id, "CreDtTm" => format_datetime(first.created_at)},
        "TxInfAndSts" => Enum.map(messages, &transaction_term/1)
      }
    }
  end

  defp transaction_term(m) do
    %{
      "OrgnlInstrId" => m.orgnl_instr_id,
      "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
      "TxSts" => m.tx_sts
    }
    |> maybe_put("StsRsnInf", sts_rsn_inf_list(m))
    |> maybe_put("FctvIntrBkSttlmDt", fctv_intr_bk_sttlm_dt_term(m.fctv_intr_bk_sttlm_dt))
    |> maybe_put("OrgnlTxRef", orgnl_tx_ref_term(m.orgnl_intr_bk_sttlm_dt))
  end

  # `StsRsnInf` é `max: ilimitado` no schema (permite mais de um motivo); o
  # modelo cobre no máximo 1, então a lista tem sempre 0 ou 1 item.
  defp sts_rsn_inf_list(%{sts_rsn_cd: nil, sts_rsn_addtl_inf: []}), do: nil
  defp sts_rsn_inf_list(m), do: [sts_rsn_inf_term(m)]

  defp sts_rsn_inf_term(m) do
    %{}
    |> maybe_put("Rsn", if(m.sts_rsn_cd, do: %{"Cd" => m.sts_rsn_cd}))
    |> maybe_put("AddtlInf", if(m.sts_rsn_addtl_inf != [], do: m.sts_rsn_addtl_inf))
  end

  defp fctv_intr_bk_sttlm_dt_term(nil), do: nil
  defp fctv_intr_bk_sttlm_dt_term(%DateTime{} = dt), do: %{"DtTm" => format_datetime(dt)}

  defp orgnl_tx_ref_term(nil), do: nil
  defp orgnl_tx_ref_term(%Date{} = data), do: %{"IntrBkSttlmDt" => Date.to_iso8601(data)}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "FIToFIPmtStsRpt"])
    grp = doc["GrpHdr"]

    case doc["TxInfAndSts"] do
      [tx] -> {:ok, tx_from_term(grp, tx)}
      txs -> {:ok, Enum.map(txs, &tx_from_term(grp, &1))}
    end
  end

  defp tx_from_term(grp, tx) do
    rsn_inf = tx |> Map.get("StsRsnInf", []) |> List.first(%{})

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      orgnl_instr_id: tx["OrgnlInstrId"],
      orgnl_end_to_end_id: tx["OrgnlEndToEndId"],
      tx_sts: tx["TxSts"],
      sts_rsn_cd: get_in(rsn_inf, ["Rsn", "Cd"]),
      sts_rsn_addtl_inf: Map.get(rsn_inf, "AddtlInf", []),
      fctv_intr_bk_sttlm_dt: parse_datetime(get_in(tx, ["FctvIntrBkSttlmDt", "DtTm"])),
      orgnl_intr_bk_sttlm_dt: parse_date(get_in(tx, ["OrgnlTxRef", "IntrBkSttlmDt"]))
    }
  end

  defp format_datetime(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(text) do
    {:ok, dt, _offset} = DateTime.from_iso8601(text)
    dt
  end

  defp parse_date(nil), do: nil
  defp parse_date(text), do: Date.from_iso8601!(text)
end
