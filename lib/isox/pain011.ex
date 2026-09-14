defmodule Isox.Pain011 do
  @moduledoc """
  Cancelamento de recorrência do Pix Automático.

  Versão 1.3. Carrega uma cópia inteira da recorrência original, nos
  campos prefixados `orgnl_`, mais o motivo do cancelamento. A resposta é
  uma `Isox.Pain012` com `mndt_sts` igual a `"CCLD"`.

  A cópia tem o mesmo formato da `Isox.Pain009` sem o bloco `Adjstmnt`,
  que não existe neste schema.

  `SplmtryData` é opcional aqui, ao contrário da pain.009, onde é
  obrigatório: `mndt_prcg_dtls` vazio omite o contêiner inteiro. Quando
  aparece, são exatamente dois itens, `CRTN` e depois `CLTN`.

  ## Lote

  `UndrlygCxlDtls` é ilimitado no schema. `encode/3` aceita uma mensagem
  ou uma lista, e `decode/1` devolve uma struct ou uma lista.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pain011.V1_3

  @type version :: :v1_3

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :created_at,
    :instg_agt_ispb,
    :cxl_orgtr_cpf_cnpj,
    :cxl_rsn_prtry,
    :orgnl_mndt_id,
    :orgnl_mndt_req_id,
    :orgnl_frqcy_tp,
    :orgnl_frst_colltn_dt,
    :orgnl_fnl_colltn_dt,
    :orgnl_trckg_ind,
    :orgnl_colltn_amt,
    :orgnl_cdtr_name,
    :orgnl_cdtr_cpf_cnpj,
    :orgnl_cdtr_agt_ispb,
    :orgnl_dbtr_cpf_cnpj,
    :orgnl_dbtr_acct_id,
    :orgnl_dbtr_acct_issr,
    :orgnl_dbtr_agt_ispb,
    :orgnl_ultmt_dbtr_name,
    :orgnl_ultmt_dbtr_cpf_cnpj,
    :orgnl_rfrd_doc_nb,
    :orgnl_rfrd_doc_cdtr_ref,
    mndt_prcg_dtls: []
  ]

  @type t :: %__MODULE__{}

  @required_fields [
    :msg_id,
    :created_at,
    :instg_agt_ispb,
    :cxl_orgtr_cpf_cnpj,
    :cxl_rsn_prtry,
    :orgnl_mndt_id,
    :orgnl_mndt_req_id,
    :orgnl_frqcy_tp,
    :orgnl_frst_colltn_dt,
    :orgnl_trckg_ind,
    :orgnl_cdtr_name,
    :orgnl_cdtr_cpf_cnpj,
    :orgnl_cdtr_agt_ispb,
    :orgnl_dbtr_cpf_cnpj,
    :orgnl_dbtr_acct_id,
    :orgnl_dbtr_agt_ispb,
    :orgnl_rfrd_doc_nb
  ]

  @module_by_version %{v1_3: V1_3}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_3] do
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

  @doc "Decodifica um XML de pain.011 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_pain011, module.msg_def_idr()}}
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
      "MndtCxlReq" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => format_datetime(m.created_at),
          "InstgAgt" => agent_term(m.instg_agt_ispb)
        },
        "UndrlygCxlDtls" =>
          %{
            "CxlRsn" => %{
              "Orgtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cxl_orgtr_cpf_cnpj}}}},
              "Rsn" => %{"Prtry" => m.cxl_rsn_prtry}
            },
            "OrgnlMndt" => %{"OrgnlMndt" => original_mandate_term(m)}
          }
          |> maybe_put("SplmtryData", splmtry_term(m))
      }
    }
  end

  defp original_mandate_term(m) do
    %{
      "MndtId" => m.orgnl_mndt_id,
      "MndtReqId" => m.orgnl_mndt_req_id,
      "Ocrncs" =>
        %{
          "SeqTp" => "RCUR",
          "Frqcy" => %{"Tp" => m.orgnl_frqcy_tp},
          "FrstColltnDt" => Date.to_iso8601(m.orgnl_frst_colltn_dt)
        }
        |> maybe_put(
          "FnlColltnDt",
          if(m.orgnl_fnl_colltn_dt, do: Date.to_iso8601(m.orgnl_fnl_colltn_dt))
        ),
      "TrckgInd" => to_string(m.orgnl_trckg_ind),
      "Cdtr" => %{
        "Nm" => m.orgnl_cdtr_name,
        "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_cdtr_cpf_cnpj}}}
      },
      "CdtrAgt" => agent_term(m.orgnl_cdtr_agt_ispb),
      "Dbtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_dbtr_cpf_cnpj}}}},
      "DbtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.orgnl_dbtr_acct_id, "Issr" => m.orgnl_dbtr_acct_issr}}
      },
      "DbtrAgt" => agent_term(m.orgnl_dbtr_agt_ispb),
      "RfrdDoc" => %{"Nb" => m.orgnl_rfrd_doc_nb, "CdtrRef" => m.orgnl_rfrd_doc_cdtr_ref}
    }
    |> maybe_put(
      "ColltnAmt",
      if(m.orgnl_colltn_amt,
        do: %{value: to_string(m.orgnl_colltn_amt), attributes: %{"Ccy" => "BRL"}}
      )
    )
    |> maybe_put("UltmtDbtr", ultmt_dbtr_term(m))
  end

  defp ultmt_dbtr_term(%{orgnl_ultmt_dbtr_name: nil}), do: nil

  defp ultmt_dbtr_term(m) do
    %{
      "Nm" => m.orgnl_ultmt_dbtr_name,
      "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_ultmt_dbtr_cpf_cnpj}}}
    }
  end

  defp splmtry_term(%{mndt_prcg_dtls: []}), do: nil

  defp splmtry_term(m) do
    %{"Envlp" => %{"MndtPrcgDtls" => Enum.map(m.mndt_prcg_dtls, &prcg_term/1)}}
  end

  defp prcg_term(p), do: %{"MndtPrcgTp" => p.tp, "PrcgDtTm" => format_datetime(p.dt_tm)}

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "MndtCxlReq"])
    grp = doc["GrpHdr"]
    cxl = doc["UndrlygCxlDtls"]
    mndt = get_in(cxl, ["OrgnlMndt", "OrgnlMndt"])
    ocrncs = mndt["Ocrncs"]
    ultmt_dbtr = mndt["UltmtDbtr"] || %{}
    dbtr_acct = mndt["DbtrAcct"]
    mndt_prcg_dtls = get_in(cxl, ["SplmtryData", "Envlp", "MndtPrcgDtls"]) || []

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      instg_agt_ispb: get_in(grp, ["InstgAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cxl_orgtr_cpf_cnpj: get_in(cxl, ["CxlRsn", "Orgtr", "Id", "PrvtId", "Othr", "Id"]),
      cxl_rsn_prtry: get_in(cxl, ["CxlRsn", "Rsn", "Prtry"]),
      orgnl_mndt_id: mndt["MndtId"],
      orgnl_mndt_req_id: mndt["MndtReqId"],
      orgnl_frqcy_tp: get_in(ocrncs, ["Frqcy", "Tp"]),
      orgnl_frst_colltn_dt: ocrncs["FrstColltnDt"] |> parse_date(),
      orgnl_fnl_colltn_dt: ocrncs["FnlColltnDt"] |> parse_date(),
      orgnl_trckg_ind: mndt["TrckgInd"],
      orgnl_colltn_amt: get_in(mndt, ["ColltnAmt", :value]),
      orgnl_cdtr_name: get_in(mndt, ["Cdtr", "Nm"]),
      orgnl_cdtr_cpf_cnpj: get_in(mndt, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      orgnl_cdtr_agt_ispb: get_in(mndt, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_dbtr_cpf_cnpj: get_in(mndt, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      orgnl_dbtr_acct_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      orgnl_dbtr_acct_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      orgnl_dbtr_agt_ispb: get_in(mndt, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_ultmt_dbtr_name: ultmt_dbtr["Nm"],
      orgnl_ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      orgnl_rfrd_doc_nb: get_in(mndt, ["RfrdDoc", "Nb"]),
      orgnl_rfrd_doc_cdtr_ref: get_in(mndt, ["RfrdDoc", "CdtrRef"]),
      mndt_prcg_dtls: Enum.map(mndt_prcg_dtls, &prcg_from_term/1)
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
