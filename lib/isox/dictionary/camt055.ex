defmodule Isox.Dictionary.Camt055 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:assgnmt_id, "idMensagemDoCancelamento", "CstmrPmtCxlReq/Assgnmt/Id",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem de pedido de cancelamento."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "CstmrPmtCxlReq/Assgnmt/CreDtTm",
        type: :datetime,
        what: "Quando o pedido foi criado."
      ),
      entry(
        :assgnr_ispb,
        "participanteSolicitanteDoCancelamento",
        "CstmrPmtCxlReq/Assgnmt/Assgnr/Agt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem está pedindo o cancelamento."
      ),
      entry(
        :assgne_ispb,
        "participanteDestinatarioDoCancelamento",
        "CstmrPmtCxlReq/Assgnmt/Assgne/Agt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem precisa responder ao pedido."
      ),
      entry(
        :pmt_cxl_id,
        "idCancelamentoAgendamento",
        "CstmrPmtCxlReq/Undrlyg/OrgnlPmtInfAndCxl/PmtCxlId",
        type: :text,
        length: "29 caracteres",
        what: "Identificador deste cancelamento, o que a camt.029 devolve para responder."
      ),
      entry(
        :orgnl_pmt_inf_id,
        "idConciliacaoRecebedorOriginal",
        "CstmrPmtCxlReq/Undrlyg/OrgnlPmtInfAndCxl/OrgnlPmtInfId",
        type: :text,
        length: "até 35 caracteres",
        what: "O idConciliacaoRecebedor do agendamento que se quer cancelar.",
        rule: "Divergir do original faz a camt.029 voltar com CH16."
      ),
      entry(
        :orgtr_cpf_cnpj,
        "cpfCnpjUsuarioSolicitanteDoCancelamento",
        "CstmrPmtCxlReq/Undrlyg/OrgnlPmtInfAndCxl/CxlRsnInf/Orgtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ do usuário que pediu o cancelamento."
      ),
      entry(
        :rsn_prtry,
        "motivoDoCancelamento",
        "CstmrPmtCxlReq/Undrlyg/OrgnlPmtInfAndCxl/CxlRsnInf/Rsn/Prtry",
        type: :code,
        what: "Por que o agendamento está sendo cancelado.",
        codes: %{
          "SLBD" => "O usuário pagador pediu.",
          "SLCR" => "O usuário recebedor pediu.",
          "ACCT" => "A conta transacional de um dos dois foi encerrada.",
          "BLCK" => "A conta transacional de um dos dois foi bloqueada.",
          "CCLD" =>
            "A autorização de pagamentos periódicos foi cancelada. Só o participante do " <>
              "pagador usa.",
          "FAIL" => "Falha ou erro na liquidação. Só o participante do pagador usa.",
          "OTHR" => "Outros motivos."
        }
      ),
      entry(
        :orgnl_end_to_end_id,
        "idFimAFimOriginal",
        "CstmrPmtCxlReq/Undrlyg/OrgnlPmtInfAndCxl/TxInf/OrgnlEndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim do pagamento agendado que se quer cancelar.",
        rule: "Divergir do original faz a camt.029 voltar com FF08."
      ),
      entry(
        :cxl_prcg_tp,
        "tipoSolicitacaoOuInformacao",
        "CstmrPmtCxlReq/Undrlyg/OrgnlPmtInfAndCxl/TxInf/SplmtryData/Envlp/CxlPrcgDtls/CxlPrcgTp",
        type: :code,
        what: "Se esta mensagem pede o cancelamento ou apenas informa que ele já aconteceu.",
        codes: %{
          "DHSR" => "Solicitação de cancelamento feita pelo participante do recebedor.",
          "DHIP" => "Cancelamento informado pelo participante do pagador, já consumado."
        }
      ),
      entry(
        :prcg_dt_tm,
        "dataHoraDaSolicitacaoOuInformacao",
        "CstmrPmtCxlReq/Undrlyg/OrgnlPmtInfAndCxl/TxInf/SplmtryData/Envlp/CxlPrcgDtls/PrcgDtTm",
        type: :datetime,
        what: "Quando o pedido, ou o cancelamento informado, aconteceu."
      )
    ]
  end
end
