defmodule Isox.Pain009 do
  @moduledoc """
  Modelo ISO 20022 do pain.009 (solicitação de autorização de
  recorrência / mandato), versão 1.1 — cria o estado de mandato pendente:
  `MndtId`, frequência, datas de vigência, valor.

  Modela `Mndt` como exatamente 1 por mensagem (mesma simplificação do
  `Pacs008`). `MndtPrcgDtls` é `max: ilimitado` de verdade (histórico de
  processamento), modelado como lista — schema exige ao menos 1.
  `Ocrncs.SeqTp` (enum de valor único `"RCUR"`) fica fixo.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pain009.V1_1

  @type version :: :v1_1

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :created_at,
    :mndt_id,
    :mndt_req_id,
    :frqcy_tp,
    :frst_colltn_dt,
    :fnl_colltn_dt,
    :trckg_ind,
    :colltn_amt,
    :adjstmnt_dt_ind,
    :adjstmnt_amt,
    :cdtr_name,
    :cdtr_cpf_cnpj,
    :cdtr_agt_ispb,
    :dbtr_cpf_cnpj,
    :dbtr_acct_id,
    :dbtr_acct_issr,
    :dbtr_agt_ispb,
    :ultmt_dbtr_name,
    :ultmt_dbtr_cpf_cnpj,
    :rfrd_doc_nb,
    :rfrd_doc_cdtr_ref,
    mndt_prcg_dtls: []
  ]

  @type prcg_dtls :: %{tp: String.t(), dt_tm: DateTime.t()}
  @type t :: %__MODULE__{}

  @required_fields [
    :msg_id,
    :created_at,
    :mndt_id,
    :mndt_req_id,
    :frqcy_tp,
    :frst_colltn_dt,
    :trckg_ind,
    :cdtr_name,
    :cdtr_cpf_cnpj,
    :cdtr_agt_ispb,
    :dbtr_cpf_cnpj,
    :dbtr_acct_id,
    :dbtr_agt_ispb,
    :rfrd_doc_nb
  ]

  @module_by_version %{v1_1: V1_1}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_1] do
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

  @doc "Decodifica um XML de pain.009 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_pain009, module.msg_def_idr()}}
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
      "MndtInitnReq" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "Mndt" => [mandate_term(m)]
      }
    }
  end

  defp mandate_term(m) do
    %{
      "MndtId" => m.mndt_id,
      "MndtReqId" => m.mndt_req_id,
      "Ocrncs" =>
        %{
          "SeqTp" => "RCUR",
          "Frqcy" => %{"Tp" => m.frqcy_tp},
          "FrstColltnDt" => Date.to_iso8601(m.frst_colltn_dt)
        }
        |> maybe_put("FnlColltnDt", if(m.fnl_colltn_dt, do: Date.to_iso8601(m.fnl_colltn_dt))),
      "TrckgInd" => to_string(m.trckg_ind),
      "Cdtr" => %{
        "Nm" => m.cdtr_name,
        "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}
      },
      "CdtrAgt" => agent_term(m.cdtr_agt_ispb),
      "Dbtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}},
      "DbtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.dbtr_acct_id, "Issr" => m.dbtr_acct_issr}}
      },
      "DbtrAgt" => agent_term(m.dbtr_agt_ispb),
      "RfrdDoc" => %{"Nb" => m.rfrd_doc_nb, "CdtrRef" => m.rfrd_doc_cdtr_ref},
      "SplmtryData" => %{
        "Envlp" => %{"MndtPrcgDtls" => Enum.map(m.mndt_prcg_dtls, &prcg_term/1)}
      }
    }
    |> maybe_put(
      "ColltnAmt",
      if(m.colltn_amt, do: %{value: to_string(m.colltn_amt), attributes: %{"Ccy" => "BRL"}})
    )
    |> maybe_put("Adjstmnt", adjustment_term(m))
    |> maybe_put("UltmtDbtr", ultmt_dbtr_term(m))
  end

  defp prcg_term(p), do: %{"MndtPrcgTp" => p.tp, "PrcgDtTm" => format_datetime(p.dt_tm)}

  defp adjustment_term(%{adjstmnt_amt: nil}), do: nil

  defp adjustment_term(m) do
    %{
      "DtAdjstmntRuleInd" => to_string(m.adjstmnt_dt_ind),
      "Amt" => %{value: to_string(m.adjstmnt_amt), attributes: %{"Ccy" => "BRL"}}
    }
  end

  defp ultmt_dbtr_term(%{ultmt_dbtr_name: nil}), do: nil

  defp ultmt_dbtr_term(m) do
    %{
      "Nm" => m.ultmt_dbtr_name,
      "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.ultmt_dbtr_cpf_cnpj}}}
    }
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "MndtInitnReq"])
    grp = doc["GrpHdr"]
    [mndt] = doc["Mndt"]
    ocrncs = mndt["Ocrncs"]
    adjstmnt = mndt["Adjstmnt"] || %{}
    ultmt_dbtr = mndt["UltmtDbtr"] || %{}
    dbtr_acct = mndt["DbtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      mndt_id: mndt["MndtId"],
      mndt_req_id: mndt["MndtReqId"],
      frqcy_tp: get_in(ocrncs, ["Frqcy", "Tp"]),
      frst_colltn_dt: ocrncs["FrstColltnDt"] |> parse_date(),
      fnl_colltn_dt: ocrncs["FnlColltnDt"] |> parse_date(),
      trckg_ind: mndt["TrckgInd"],
      colltn_amt: get_in(mndt, ["ColltnAmt", :value]),
      adjstmnt_dt_ind: adjstmnt["DtAdjstmntRuleInd"],
      adjstmnt_amt: get_in(adjstmnt, ["Amt", :value]),
      cdtr_name: get_in(mndt, ["Cdtr", "Nm"]),
      cdtr_cpf_cnpj: get_in(mndt, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_agt_ispb: get_in(mndt, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      dbtr_cpf_cnpj: get_in(mndt, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_acct_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_acct_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_agt_ispb: get_in(mndt, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      ultmt_dbtr_name: ultmt_dbtr["Nm"],
      ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      rfrd_doc_nb: get_in(mndt, ["RfrdDoc", "Nb"]),
      rfrd_doc_cdtr_ref: get_in(mndt, ["RfrdDoc", "CdtrRef"]),
      mndt_prcg_dtls:
        mndt |> get_in(["SplmtryData", "Envlp", "MndtPrcgDtls"]) |> Enum.map(&prcg_from_term/1)
    }
  end

  defp prcg_from_term(t), do: %{tp: t["MndtPrcgTp"], dt_tm: parse_datetime(t["PrcgDtTm"])}

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
