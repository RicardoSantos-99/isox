defmodule PixSpiCatalog.Trck002 do
  @moduledoc """
  Representação de domínio do trck.002 (autorrelato de transferência
  entre contas do mesmo participante — book transfer), versão 1.1.
  Independente de pacs.008/002; responde-se com camt.025.

  Modela `Tx` como exatamente 1 por mensagem (mesma simplificação do
  `Pacs008` pra `CdtTrfTxInf`). `TxSts.Sts` (enum de valor único
  `"ACCC"`) fica fixo — book transfer é sempre reportado como já
  efetivado.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Generated.Trck002.V1_1

  @type version :: :v1_1

  defstruct [
    :msg_id,
    :created_at,
    :end_to_end_id,
    :instr_id,
    :lcl_instrm,
    :pmt_scnro_prtry,
    :value,
    :reqd_exctn_dt,
    :dbtr_cpf_cnpj,
    :dbtr_acct_id,
    :dbtr_acct_issr,
    :dbtr_acct_type,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_issr,
    :cdtr_acct_type,
    :cdtr_acct_proxy
  ]

  @type t :: %__MODULE__{}

  @required_fields [
    :msg_id,
    :created_at,
    :end_to_end_id,
    :lcl_instrm,
    :pmt_scnro_prtry,
    :value,
    :reqd_exctn_dt,
    :dbtr_cpf_cnpj,
    :dbtr_acct_id,
    :dbtr_acct_type,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_type
  ]

  @module_by_version %{v1_1: V1_1}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_1] do
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

  @doc "Parseia um XML de trck.002 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), version()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registry.parse(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_trck002, module.msg_def_idr()}}
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
      "PmtStsTrckrRpt" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "TrckrStsAndTx" => %{"TxSts" => %{"Sts" => "ACCC"}, "Tx" => [tx_term(m)]}
      }
    }
  end

  defp tx_term(m) do
    %{
      "PmtId" => %{"InstrId" => m.instr_id, "EndToEndId" => m.end_to_end_id},
      "PmtTpInf" => %{"LclInstrm" => %{"Prtry" => m.lcl_instrm}},
      "PmtScnro" => %{"Prtry" => m.pmt_scnro_prtry},
      "IntrBkSttlmAmt" => %{value: to_string(m.value), attributes: %{"Ccy" => "BRL"}},
      "ReqdExctnDt" => %{"DtTm" => format_datetime(m.reqd_exctn_dt)},
      "Dbtr" => %{"Pty" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}}},
      "DbtrAcct" => account_term(m.dbtr_acct_id, m.dbtr_acct_issr, m.dbtr_acct_type),
      "DbtrAgt" => agent_term(m.dbtr_agt_ispb),
      "CdtrAgt" => agent_term(m.cdtr_agt_ispb),
      "Cdtr" => %{"Pty" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}}},
      "CdtrAcct" =>
        account_term(m.cdtr_acct_id, m.cdtr_acct_issr, m.cdtr_acct_type, m.cdtr_acct_proxy)
    }
  end

  defp account_term(id, issr, type, proxy \\ nil) do
    base = %{"Id" => %{"Othr" => %{"Id" => id, "Issr" => issr}}, "Tp" => %{"Cd" => type}}
    if proxy, do: Map.put(base, "Prxy", %{"Id" => proxy}), else: base
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "PmtStsTrckrRpt"])
    grp = doc["GrpHdr"]
    [tx] = get_in(doc, ["TrckrStsAndTx", "Tx"])
    dbtr_acct = tx["DbtrAcct"]
    cdtr_acct = tx["CdtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      end_to_end_id: get_in(tx, ["PmtId", "EndToEndId"]),
      instr_id: get_in(tx, ["PmtId", "InstrId"]),
      lcl_instrm: get_in(tx, ["PmtTpInf", "LclInstrm", "Prtry"]),
      pmt_scnro_prtry: get_in(tx, ["PmtScnro", "Prtry"]),
      value: get_in(tx, ["IntrBkSttlmAmt", :value]),
      reqd_exctn_dt: get_in(tx, ["ReqdExctnDt", "DtTm"]) |> parse_datetime(),
      dbtr_cpf_cnpj: get_in(tx, ["Dbtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_acct_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_acct_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_acct_type: get_in(dbtr_acct, ["Tp", "Cd"]),
      dbtr_agt_ispb: get_in(tx, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(tx, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["Cdtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_acct_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_acct_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_acct_type: get_in(cdtr_acct, ["Tp", "Cd"]),
      cdtr_acct_proxy: get_in(cdtr_acct, ["Prxy", "Id"])
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
