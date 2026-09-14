defmodule Isox.Dictionary.Camt029 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:assgnmt_id, "idMensagemDoCancelamento", "RsltnOfInvstgtn/Assgnmt/Id",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "RsltnOfInvstgtn/Assgnmt/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada."
      ),
      entry(
        :assgnr_ispb,
        "participanteAtualizaSolicitacaoDoCancelamento",
        "RsltnOfInvstgtn/Assgnmt/Assgnr/Agt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem está respondendo ao pedido de cancelamento."
      ),
      entry(
        :assgne_ispb,
        "participanteRecebeAtualizacaoDoCancelamento",
        "RsltnOfInvstgtn/Assgnmt/Assgne/Agt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem pediu o cancelamento e agora recebe a resposta."
      ),
      entry(
        :orgnl_pmt_inf_cxl_id,
        "idCancelamentoAgendamentoOriginal",
        "RsltnOfInvstgtn/CxlDtls/OrgnlPmtInfAndSts/OrgnlPmtInfCxlId",
        type: :text,
        length: "29 caracteres",
        what: "O pmt_cxl_id da camt.055 que está sendo respondida."
      ),
      entry(
        :orgnl_pmt_inf_id,
        "idConciliacaoRecebedorOriginal",
        "RsltnOfInvstgtn/CxlDtls/OrgnlPmtInfAndSts/OrgnlPmtInfId",
        type: :text,
        length: "até 35 caracteres",
        what: "O idConciliacaoRecebedor do agendamento, repetido da camt.055."
      ),
      entry(
        :pmt_inf_cxl_sts,
        "statusDoCancelamento",
        "RsltnOfInvstgtn/CxlDtls/OrgnlPmtInfAndSts/PmtInfCxlSts",
        type: :code,
        what: "Se o cancelamento foi aceito.",
        codes: %{
          "ACCR" => "Cancelamento aceito.",
          "RJCR" => "Cancelamento rejeitado."
        }
      ),
      entry(
        :rsn_prtry,
        "codigoDeRejeicaoDoCancelamento",
        "RsltnOfInvstgtn/CxlDtls/OrgnlPmtInfAndSts/CxlStsRsnInf/Rsn/Prtry",
        type: :code,
        requirement: :conditional,
        what: "Por que o cancelamento foi recusado.",
        rule: "Só faz sentido com pmt_inf_cxl_sts igual a RJCR.",
        codes: %{
          "AB09" => "Transação interrompida por erro no participante do recebedor.",
          "AB10" => "Transação interrompida por erro no participante do pagador.",
          "CH16" => "O idConciliacaoRecebedor não corresponde ao informado originalmente.",
          "CRNC" => "CPF ou CNPJ do recebedor não bate com o da autorização de recorrência.",
          "DENC" => "CPF ou CNPJ do pagador não bate com o da autorização de recorrência.",
          "FBRD" => "A camt.055 não chegou ao participante do pagador dentro do prazo.",
          "FF08" => "O idFimAFim não corresponde ao informado originalmente.",
          "PRJL" => "Cancelamento inválido: o pagamento recorrente já foi concluído."
        }
      ),
      entry(
        :orgnl_end_to_end_id,
        "idFimAFimOriginal",
        "RsltnOfInvstgtn/CxlDtls/OrgnlPmtInfAndSts/TxInfAndSts/OrgnlEndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim do pagamento agendado, repetido da camt.055."
      ),
      entry(
        :cxl_prcg_tp,
        "tipoAceitacaoOuRejeicao",
        "RsltnOfInvstgtn/SplmtryData/Envlp/CxlPrcgDtls/CxlPrcgTp",
        type: :code,
        what: "Se o que está sendo datado é a aceitação ou a rejeição.",
        rule:
          "Anda junto com pmt_inf_cxl_sts: ACCR vai com DHAC, RJCR vai com DHRC. O campo " <>
            "Conf da mensagem é fixo em INFO e não aparece na struct.",
        codes: %{
          "DHAC" => "Data e hora de aceitação do cancelamento.",
          "DHRC" => "Data e hora de rejeição do cancelamento."
        }
      ),
      entry(
        :prcg_dt_tm,
        "dataHoraAceitacaoOuRejeicaoDoCancelamento",
        "RsltnOfInvstgtn/SplmtryData/Envlp/CxlPrcgDtls/PrcgDtTm",
        type: :datetime,
        what: "Quando o cancelamento foi aceito ou rejeitado."
      )
    ]
  end
end
