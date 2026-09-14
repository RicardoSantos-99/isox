defmodule Isox.Dictionary.Camt060 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "AcctRptgReq/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta consulta. A resposta devolve este valor para casar as duas."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "AcctRptgReq/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a consulta foi criada."
      ),
      entry(:reqd_msg_nm_id, "tipoConsulta", "AcctRptgReq/RptgReq/ReqdMsgNmId",
        type: :code,
        what: "Em que mensagem a resposta deve vir. É o campo que decide o que se está pedindo.",
        codes: %{
          "camt.052" =>
            "Relação de lançamentos da Conta PI, ou um dos arquivos de transações de saque " <>
              "e troco.",
          "camt.053" => "Saldo da Conta PI, ou o demonstrativo de remuneração dela.",
          "camt.054" => "Detalhe de um lançamento específico."
        }
      ),
      entry(
        :acct_ownr_ispb,
        "participanteDireto",
        "AcctRptgReq/RptgReq/AcctOwnr/Agt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do dono da Conta PI que se quer consultar."
      ),
      entry(:id, "idOriginal", "AcctRptgReq/RptgReq/Id",
        type: :text,
        length: "até 32 caracteres",
        requirement: :conditional,
        what: "O lançamento específico que se quer detalhar.",
        rule: "Só faz sentido quando reqd_msg_nm_id é camt.054."
      ),
      entry(:rptg_prd_fr_dt, "dataInicialResultado", "AcctRptgReq/RptgReq/RptgPrd/FrToDt/FrDt",
        type: :date,
        requirement: :conditional,
        what: "Primeiro dia do período consultado.",
        rule:
          "O bloco de período é opcional inteiro, mas se aparecer, a data inicial é " <>
            "obrigatória dentro dele. O tipo de resultado (ALLL) é fixo e não aparece na " <>
            "struct."
      ),
      entry(:rptg_prd_to_dt, "dataFinalResultado", "AcctRptgReq/RptgReq/RptgPrd/FrToDt/ToDt",
        type: :date,
        requirement: :optional,
        what: "Último dia do período consultado."
      ),
      entry(:rptg_prd_fr_tm, "horarioInicialResultado", "AcctRptgReq/RptgReq/RptgPrd/FrToTm/FrTm",
        type: :text,
        requirement: :conditional,
        what: "Hora inicial, para afinar o período dentro do dia.",
        rule: "Hora inicial e final andam juntas: se uma aparece, a outra também."
      ),
      entry(:rptg_prd_to_tm, "horarioFinalResultado", "AcctRptgReq/RptgReq/RptgPrd/FrToTm/ToTm",
        type: :text,
        requirement: :conditional,
        what: "Hora final do período."
      ),
      entry(
        :reqd_bal_tp_prtry,
        "tipoArquivoOuSolicitacao",
        "AcctRptgReq/RptgReq/ReqdBalTp/CdOrPrtry/Prtry",
        type: :code,
        requirement: :conditional,
        what: "Qual variante da consulta, dentro do tipo escolhido em reqd_msg_nm_id.",
        rule:
          "CSA e CRE vão com camt.053; REL, TRD e TRT vão com camt.052. É a combinação dos " <>
            "dois campos que define a pergunta.",
        codes: %{
          "CSA" => "Saldos da Conta PI.",
          "CRE" => "Demonstrativo da remuneração da Conta PI.",
          "REL" => "Arquivo com a relação de lançamentos da Conta PI.",
          "TRD" =>
            "Arquivo Demonstrativo RCO: transações Pix de saque e troco liquidadas no SPI, " <>
              "agrupadas por modalidade de agente.",
          "TRT" =>
            "Arquivo Total RCO: posição líquida de ressarcimento de custos operacionais do " <>
              "participante."
        }
      )
    ]
  end
end
