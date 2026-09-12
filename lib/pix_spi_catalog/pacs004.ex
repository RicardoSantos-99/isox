defmodule PixSpiCatalog.Pacs004 do
  @moduledoc """
  Representação de domínio do pacs.004 (devolução), versão 1.5 — a ordem
  de devolução de uma pacs.008 já liquidada, referenciando a original por
  `OrgnlEndToEndId`.

  Modela `TxInf` como exatamente 1 por mensagem (mesma simplificação do
  `Pacs008`/`Pacs002` para os elementos de transação em lista).

  Mesma validação em duas camadas dos outros: `build/3` confere
  obrigatoriedade do domínio e reaproveita o `parse` do próprio módulo
  gerado pra pattern/enum/cardinalidade, sem duplicar regra.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Generated.Pacs004.V1_5

  @type version :: :v1_5

  defstruct [
    :msg_id,
    :created_at,
    :rtr_id,
    :orgnl_end_to_end_id,
    :value,
    :rtr_rsn_cd,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    sttlm_prty: "NORM",
    rtr_rsn_addtl_inf: nil,
    rmt_inf_ustrd: nil
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          rtr_id: String.t(),
          orgnl_end_to_end_id: String.t(),
          value: String.t() | number(),
          sttlm_prty: String.t(),
          rtr_rsn_cd: String.t(),
          rtr_rsn_addtl_inf: String.t() | nil,
          dbtr_agt_ispb: String.t(),
          cdtr_agt_ispb: String.t(),
          rmt_inf_ustrd: String.t() | nil
        }

  @required_fields [
    :msg_id,
    :created_at,
    :rtr_id,
    :orgnl_end_to_end_id,
    :value,
    :sttlm_prty,
    :rtr_rsn_cd,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb
  ]

  @module_by_version %{v1_5: V1_5}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_5] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(message)
      }

      with {:ok, xml} <- module.build(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Parseia um XML de pacs.004 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), version()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registry.parse(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_pacs004, module.msg_def_idr()}}
        end

      error ->
        error
    end
  end

  defp confirm(module, xml) do
    case module.parse(xml) do
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
      "PmtRtr" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => format_datetime(m.created_at),
          "NbOfTxs" => "1",
          "SttlmInf" => %{"SttlmMtd" => "CLRG"}
        },
        "TxInf" => [transaction_term(m)]
      }
    }
  end

  defp transaction_term(m) do
    %{
      "RtrId" => m.rtr_id,
      "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
      "RtrdIntrBkSttlmAmt" => %{value: to_string(m.value), attributes: %{"Ccy" => "BRL"}},
      "SttlmPrty" => m.sttlm_prty,
      "ChrgBr" => "SLEV",
      "RtrRsnInf" => %{"Rsn" => %{"Cd" => m.rtr_rsn_cd}, "AddtlInf" => m.rtr_rsn_addtl_inf},
      "OrgnlTxRef" =>
        %{
          "DbtrAgt" => agent_term(m.dbtr_agt_ispb),
          "CdtrAgt" => agent_term(m.cdtr_agt_ispb)
        }
        |> maybe_put("RmtInf", rmt_inf_term(m.rmt_inf_ustrd))
    }
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp rmt_inf_term(nil), do: nil
  defp rmt_inf_term(text), do: %{"Ustrd" => text}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "PmtRtr"])
    grp = doc["GrpHdr"]
    [tx] = doc["TxInf"]
    rsn_inf = tx["RtrRsnInf"]
    orgnl_ref = tx["OrgnlTxRef"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      rtr_id: tx["RtrId"],
      orgnl_end_to_end_id: tx["OrgnlEndToEndId"],
      value: get_in(tx, ["RtrdIntrBkSttlmAmt", :value]),
      sttlm_prty: tx["SttlmPrty"],
      rtr_rsn_cd: get_in(rsn_inf, ["Rsn", "Cd"]),
      rtr_rsn_addtl_inf: rsn_inf["AddtlInf"],
      dbtr_agt_ispb: get_in(orgnl_ref, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(orgnl_ref, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      rmt_inf_ustrd: get_in(orgnl_ref, ["RmtInf", "Ustrd"])
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
end
