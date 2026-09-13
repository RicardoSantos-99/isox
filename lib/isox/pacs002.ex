defmodule Isox.Pacs002 do
  @moduledoc """
  Modelo ISO 20022 do pacs.002 (relatório de status de pagamento),
  versões 1.16 e 1.17 (ADR 0002) — a resposta a um pacs.008, referenciando
  a mensagem original por `OrgnlInstrId`/`OrgnlEndToEndId` e informando o
  status (`TxSts`) e, quando rejeitada, o motivo.

  Modela `TxInfAndSts` como exatamente 1 por mensagem (mesma simplificação
  do `Pacs008` para `CdtTrfTxInf`: o XSD permite lote, o Pix não usa) e
  `StsRsnInf` como no máximo 1 motivo, com sua lista de `AddtlInf`.

  Mesma validação em duas camadas do `Pacs008`: `encode/3` confere os
  campos obrigatórios do modelo e depois reaproveita o `decode` do próprio
  módulo gerado pra validar pattern/enum/cardinalidade sem duplicar regra
  — inclusive o enum de `Rsn.Cd`, que diverge entre 1.16 e 1.17.
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

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version)
      when version in [:v1_16, :v1_17] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(message)
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Decodifica um XML de pacs.002 (qualquer versão) de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_pacs002, module.msg_def_idr()}}
        end

      error ->
        error
    end
  end

  defp confirm(module, xml) do
    case module.decode(xml) do
      {:ok, _term} -> {:ok, xml}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_required(message) do
    missing = Enum.filter(@required_fields, &(Map.get(message, &1) in [nil, ""]))

    if missing == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(missing)}"}
  end

  defp document_term(m) do
    %{
      "FIToFIPmtStsRpt" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "TxInfAndSts" => [transaction_term(m)]
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
    [tx] = doc["TxInfAndSts"]
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
