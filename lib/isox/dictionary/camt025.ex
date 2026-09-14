defmodule Isox.Dictionary.Camt025 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "Rct/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador deste recibo."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "Rct/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando o recibo foi criado."
      ),
      entry(:confirmations, nil, "Rct/RctDtls",
        type: :text,
        length: "1 a 500 itens",
        what: "As confirmações, uma por trck.002 que está sendo respondida.",
        rule:
          "Um recibo responde várias mensagens de uma vez, até 500. Cada item aceita ou " <>
            "rejeita uma delas de forma independente: um recibo pode ter aceite e rejeição " <>
            "misturados."
      ),
      entry(:orgnl_msg_id, "idMensagemOriginal", "Rct/RctDtls/OrgnlMsgId/MsgId",
        within: :confirmations,
        type: :text,
        length: "32 caracteres",
        what: "O msg_id da trck.002 que está sendo confirmada."
      ),
      entry(:orgnl_pmt_id, "idInstrucaoOriginal", "Rct/RctDtls/OrgnlPmtId/PrtryId",
        within: :confirmations,
        type: :text,
        length: "32 caracteres",
        what: "O identificador da transação dentro daquela trck.002."
      ),
      entry(:sts, "situacaoDaTransacao", "Rct/RctDtls/ReqHdlg/Sts/Cd",
        within: :confirmations,
        type: :code,
        what: "Se aquele reporte foi aceito.",
        codes: %{"ACPT" => "Aceito.", "RJCT" => "Rejeitado."}
      ),
      entry(:rsn_prtry, "codigoDeErro", "Rct/RctDtls/ReqHdlg/StsRsn/Rsn/Prtry",
        within: :confirmations,
        type: :code,
        requirement: :conditional,
        what: "Por que o reporte foi rejeitado.",
        rule:
          "É o campo que faz o bloco de motivo existir: sem ele não há StsRsn, e por isso " <>
            "addtl_inf sozinho não é aceito.",
        codes: %{
          "AG01" =>
            "Transferência entre contas transacionais de participantes vinculados não pode " <>
              "ser reportada.",
          "AM01" => "Valor zero.",
          "AM18" => "Quantidade de transações inválida.",
          "DT02" => "Data e hora de envio da mensagem inválida.",
          "ED05" => "Erro genérico no processamento do pagamento instantâneo.",
          "FF08" => "idFimAFim mal formatado, ou o limite de tempo para envio foi ultrapassado.",
          "RC09" => "ISPB do participante do pagador inválido ou inexistente.",
          "RC10" => "ISPB do participante do recebedor inválido ou inexistente."
        }
      ),
      entry(:addtl_inf, "detalhamentoDoErro", "Rct/RctDtls/ReqHdlg/StsRsn/AddtlInf",
        within: :confirmations,
        type: :text,
        length: "até 105 caracteres",
        requirement: :optional,
        what: "Detalhe do erro em texto livre.",
        rule:
          "105 caracteres é um limite real: texto maior faz o encode falhar, e o " <>
            "participante fica sem o recibo inteiro. Não existe sem rsn_prtry."
      )
    ]
  end
end
