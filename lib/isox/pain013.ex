defmodule Isox.Pain013 do
  @moduledoc """
  Modelo ISO 20022 do pain.013 (agendamento da instrução de
  pagamento vinculada a um mandato ativo), versão 2.2 — na data agendada,
  essa instrução vira o gatilho de uma pacs.008 real.

  Modela `PmtInf`/`CdtTrfTx` como exatamente 1 por mensagem. `InitgPty`
  no `GrpHdr` é sempre `[0]{14}` (14 zeros) no schema real — não é campo
  variável, fica fixo, assim como `PmtMtd` ("TRF"), `InstrPrty` ("NORM"),
  `SvcLvl.Prtry` ("PAGAGD"), `LclInstrm.Prtry` ("AUTO") e `ChrgBr`
  ("SLEV"). Valor vai em `Amt/InstdAmt`, não `IntrBkSttlmAmt` — ainda não
  liquidado. `Purp` aqui é `Prtry` (enum próprio), não `Cd` como no
  `Pacs008`. `Tax` fica de fora, mesma razão dos outros (ramo raro).
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pain013.V2_2

  @type version :: :v2_2

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :created_at,
    :pmt_inf_id,
    :reqd_exctn_dt,
    :xpry_dt,
    :dbtr_cpf_cnpj,
    :dbtr_agt_ispb,
    :ultmt_dbtr_name,
    :ultmt_dbtr_cpf_cnpj,
    :end_to_end_id,
    :value,
    :mndt_id,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_issr,
    :cdtr_acct_type,
    :purp_prtry,
    :rmt_inf
  ]

  @type t :: %__MODULE__{}

  @required_fields [
    :msg_id,
    :created_at,
    :pmt_inf_id,
    :xpry_dt,
    :dbtr_cpf_cnpj,
    :dbtr_agt_ispb,
    :end_to_end_id,
    :value,
    :mndt_id,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_type,
    :purp_prtry
  ]

  @module_by_version %{v2_2: V2_2}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v2_2] do
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

  @doc "Decodifica um XML de pain.013 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_pain013, module.msg_def_idr()}}
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
      "CdtrPmtActvtnReq" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => format_datetime(m.created_at),
          "NbOfTxs" => "1",
          "InitgPty" => %{"Id" => %{"OrgId" => %{"Othr" => %{"Id" => String.duplicate("0", 14)}}}}
        },
        "PmtInf" => [pmt_inf_term(m)]
      }
    }
  end

  defp pmt_inf_term(m) do
    %{
      "PmtInfId" => m.pmt_inf_id,
      "PmtMtd" => "TRF",
      "XpryDt" => %{"Dt" => Date.to_iso8601(m.xpry_dt)},
      "Dbtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}},
      "DbtrAgt" => agent_term(m.dbtr_agt_ispb),
      "CdtTrfTx" => cdt_trf_tx_term(m)
    }
    |> maybe_put(
      "ReqdExctnDt",
      if(m.reqd_exctn_dt, do: %{"DtTm" => format_datetime(m.reqd_exctn_dt)})
    )
    |> maybe_put("UltmtDbtr", ultmt_dbtr_term(m))
  end

  defp cdt_trf_tx_term(m) do
    %{
      "PmtId" => %{"EndToEndId" => m.end_to_end_id},
      "PmtTpInf" => %{
        "InstrPrty" => "NORM",
        "SvcLvl" => %{"Prtry" => "PAGAGD"},
        "LclInstrm" => %{"Prtry" => "AUTO"}
      },
      "Amt" => %{"InstdAmt" => %{value: to_string(m.value), attributes: %{"Ccy" => "BRL"}}},
      "ChrgBr" => "SLEV",
      "MndtRltdInf" => %{"MndtId" => m.mndt_id},
      "CdtrAgt" => agent_term(m.cdtr_agt_ispb),
      "Cdtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}},
      "CdtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.cdtr_acct_id, "Issr" => m.cdtr_acct_issr}},
        "Tp" => %{"Cd" => m.cdtr_acct_type}
      },
      "Purp" => %{"Prtry" => m.purp_prtry}
    }
    |> maybe_put("RmtInf", if(m.rmt_inf, do: %{"Ustrd" => m.rmt_inf}))
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
    doc = get_in(term, ["Document", "CdtrPmtActvtnReq"])
    grp = doc["GrpHdr"]
    [pmt_inf] = doc["PmtInf"]
    ultmt_dbtr = pmt_inf["UltmtDbtr"] || %{}
    tx = pmt_inf["CdtTrfTx"]
    cdtr_acct = tx["CdtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      pmt_inf_id: pmt_inf["PmtInfId"],
      reqd_exctn_dt: get_in(pmt_inf, ["ReqdExctnDt", "DtTm"]) |> parse_datetime(),
      xpry_dt: get_in(pmt_inf, ["XpryDt", "Dt"]) |> parse_date(),
      dbtr_cpf_cnpj: get_in(pmt_inf, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_agt_ispb: get_in(pmt_inf, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      ultmt_dbtr_name: ultmt_dbtr["Nm"],
      ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      end_to_end_id: get_in(tx, ["PmtId", "EndToEndId"]),
      value: get_in(tx, ["Amt", "InstdAmt", :value]),
      mndt_id: get_in(tx, ["MndtRltdInf", "MndtId"]),
      cdtr_agt_ispb: get_in(tx, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_acct_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_acct_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_acct_type: get_in(cdtr_acct, ["Tp", "Cd"]),
      purp_prtry: get_in(tx, ["Purp", "Prtry"]),
      rmt_inf: get_in(tx, ["RmtInf", "Ustrd"])
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
