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
  alias PixSpiCatalog.Gerado.Trck002.V1_1

  @type versao :: :v1_1

  defstruct [
    :msg_id,
    :criado_em,
    :end_to_end_id,
    :instr_id,
    :lcl_instrm,
    :pmt_scnro_prtry,
    :valor,
    :reqd_exctn_dt,
    :dbtr_cpf_cnpj,
    :dbtr_conta_id,
    :dbtr_conta_issr,
    :dbtr_conta_tipo,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_conta_id,
    :cdtr_conta_issr,
    :cdtr_conta_tipo,
    :cdtr_conta_chave
  ]

  @type t :: %__MODULE__{}

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :end_to_end_id,
    :lcl_instrm,
    :pmt_scnro_prtry,
    :valor,
    :reqd_exctn_dt,
    :dbtr_cpf_cnpj,
    :dbtr_conta_id,
    :dbtr_conta_tipo,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_conta_id,
    :cdtr_conta_tipo
  ]

  @modulo_por_versao %{v1_1: V1_1}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_1] do
    with :ok <- validar_obrigatorios(mensagem) do
      modulo = Map.fetch!(@modulo_por_versao, versao)

      termo = %{
        "AppHdr" => AppHdr.termo(cabecalho, modulo.msg_def_idr()),
        "Document" => termo_document(mensagem)
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de trck.002 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_trck002, modulo.msg_def_idr()}}
        end

      erro ->
        erro
    end
  end

  defp confirmar(modulo, xml) do
    case modulo.parse(xml) do
      {:ok, _termo} -> {:ok, xml}
      {:error, motivo} -> {:error, motivo}
    end
  end

  defp validar_obrigatorios(mensagem) do
    faltando = Enum.filter(@campos_obrigatorios, &(Map.get(mensagem, &1) in [nil, ""]))

    if faltando == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(faltando)}"}
  end

  defp termo_document(m) do
    %{
      "PmtStsTrckrRpt" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "TrckrStsAndTx" => %{"TxSts" => %{"Sts" => "ACCC"}, "Tx" => [termo_tx(m)]}
      }
    }
  end

  defp termo_tx(m) do
    %{
      "PmtId" => %{"InstrId" => m.instr_id, "EndToEndId" => m.end_to_end_id},
      "PmtTpInf" => %{"LclInstrm" => %{"Prtry" => m.lcl_instrm}},
      "PmtScnro" => %{"Prtry" => m.pmt_scnro_prtry},
      "IntrBkSttlmAmt" => %{valor: to_string(m.valor), atributos: %{"Ccy" => "BRL"}},
      "ReqdExctnDt" => %{"DtTm" => formatar_data_hora(m.reqd_exctn_dt)},
      "Dbtr" => %{"Pty" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}}},
      "DbtrAcct" => conta_termo(m.dbtr_conta_id, m.dbtr_conta_issr, m.dbtr_conta_tipo),
      "DbtrAgt" => agente_termo(m.dbtr_agt_ispb),
      "CdtrAgt" => agente_termo(m.cdtr_agt_ispb),
      "Cdtr" => %{"Pty" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}}},
      "CdtrAcct" =>
        conta_termo(m.cdtr_conta_id, m.cdtr_conta_issr, m.cdtr_conta_tipo, m.cdtr_conta_chave)
    }
  end

  defp conta_termo(id, issr, tipo, chave \\ nil) do
    base = %{"Id" => %{"Othr" => %{"Id" => id, "Issr" => issr}}, "Tp" => %{"Cd" => tipo}}
    if chave, do: Map.put(base, "Prxy", %{"Id" => chave}), else: base
  end

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "PmtStsTrckrRpt"])
    grp = doc["GrpHdr"]
    [tx] = get_in(doc, ["TrckrStsAndTx", "Tx"])
    dbtr_acct = tx["DbtrAcct"]
    cdtr_acct = tx["CdtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      end_to_end_id: get_in(tx, ["PmtId", "EndToEndId"]),
      instr_id: get_in(tx, ["PmtId", "InstrId"]),
      lcl_instrm: get_in(tx, ["PmtTpInf", "LclInstrm", "Prtry"]),
      pmt_scnro_prtry: get_in(tx, ["PmtScnro", "Prtry"]),
      valor: get_in(tx, ["IntrBkSttlmAmt", :valor]),
      reqd_exctn_dt: get_in(tx, ["ReqdExctnDt", "DtTm"]) |> parse_data_hora(),
      dbtr_cpf_cnpj: get_in(tx, ["Dbtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_conta_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_conta_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_conta_tipo: get_in(dbtr_acct, ["Tp", "Cd"]),
      dbtr_agt_ispb: get_in(tx, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(tx, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["Cdtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_conta_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_conta_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_conta_tipo: get_in(cdtr_acct, ["Tp", "Cd"]),
      cdtr_conta_chave: get_in(cdtr_acct, ["Prxy", "Id"])
    }
  end

  defp formatar_data_hora(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_data_hora(nil), do: nil

  defp parse_data_hora(texto) do
    {:ok, dt, _offset} = DateTime.from_iso8601(texto)
    dt
  end
end
