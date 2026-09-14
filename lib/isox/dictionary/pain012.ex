defmodule Isox.Dictionary.Pain012 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @orgnl "MndtAccptncRpt/UndrlygAccptncDtls/OrgnlMndt/OrgnlMndt"

  @frequencies %{
    "WEEK" => "Semanal.",
    "MNTH" => "Mensal.",
    "QURT" => "Trimestral.",
    "MIAN" => "Semestral.",
    "YEAR" => "Anual."
  }

  @rejection_codes %{
    "AC01" => "Conta não localizada, ou não é do usuário pagador.",
    "AC04" => "Conta do pagador encerrada.",
    "AC06" => "Conta do pagador bloqueada.",
    "AM05" => "Recorrência já confirmada antes.",
    "AP01" => "Divergência entre a data de atualização e o status da recorrência.",
    "AP02" => "CPF ou CNPJ do pagador não localizado, ou diferente do da pain.009.",
    "AP03" => "Agência do pagador não localizada.",
    "AP04" => "Identificador da recorrência inválido, ou não corresponde ao original.",
    "AP05" => "Status da recorrência inconsistente.",
    "AP06" => "CPF ou CNPJ do recebedor diferente do da pain.009 ou do payload.",
    "AP07" => "Confirmação feita depois de a solicitação expirar ou ser cancelada.",
    "AP08" => "O primeiro pagamento imediato associado à recorrência não foi identificado.",
    "AP09" => "A solicitação de confirmação não foi identificada.",
    "AP10" => "CPF ou CNPJ de quem pediu o cancelamento não bate com pagador nem recebedor.",
    "AP11" => "ISPB do participante do pagador diverge do que está na recorrência.",
    "AP12" => "ISPB do participante do recebedor diverge do que está na recorrência.",
    "AP13" => "O usuário pagador não reconheceu a solicitação.",
    "AP14" => "O usuário pagador rejeitou a solicitação.",
    "AP15" => "O participante do pagador não oferece Pix Automático.",
    "CH16" => "Conteúdo da mensagem incorreto ou incompatível com as regras de negócio.",
    "MD01" => "A recorrência que se quer cancelar não existe.",
    "MD20" => "A recorrência que se quer cancelar já expirou.",
    "SA01" => "Conta-salário não pode ser usada para cobrança recorrente no Pix Automático."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    cabecalho() ++ resposta() ++ original() ++ processamento()
  end

  defp cabecalho do
    [
      entry(:msg_id, "idMensagem", "MndtAccptncRpt/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "MndtAccptncRpt/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada. Em lote, vale para o XML inteiro."
      ),
      entry(
        :instg_agt_ispb,
        "participanteEmissor",
        "MndtAccptncRpt/GrpHdr/InstgAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem está respondendo."
      )
    ]
  end

  defp resposta do
    [
      entry(:accptd, "status", "MndtAccptncRpt/UndrlygAccptncDtls/Accptd",
        type: :indicator,
        what: "Se a solicitação foi aceita. É o campo que se lê primeiro.",
        rule: "Quando é falso, rjct_rsn_prtry diz por quê."
      ),
      entry(:rjct_rsn_prtry, "codigoDeErro", "MndtAccptncRpt/UndrlygAccptncDtls/RjctRsn",
        type: :code,
        requirement: :conditional,
        what: "Por que a solicitação foi recusada.",
        rule: "Só com accptd falso.",
        codes: @rejection_codes
      ),
      entry(:mndt_sts, "statusRecorrencia", "MndtAccptncRpt/SplmtryData/Envlp/MndtSts",
        type: :code,
        requirement: :optional,
        what: "Em que estado a recorrência ficou.",
        rule: "Diz também a que mensagem esta pain.012 responde.",
        codes: %{
          "PDNG" => "Pendente de confirmação. É a resposta a uma pain.009.",
          "CFDB" => "Confirmada pelo usuário pagador.",
          "CCLD" => "Cancelada. É a resposta a uma pain.011."
        }
      )
    ]
  end

  defp original do
    [
      entry(:orgnl_mndt_id, "idRecorrencia", "#{@orgnl}/MndtId",
        type: :text,
        length: "29 caracteres",
        what: "Identificador da recorrência de que esta resposta trata."
      ),
      entry(:orgnl_mndt_req_id, "idSolicitacaoRecorrencia", "#{@orgnl}/MndtReqId",
        type: :text,
        length: "29 caracteres",
        what: "Identificador da solicitação que está sendo respondida."
      ),
      entry(:orgnl_mndt_ref, "idSolicitacaoOriginal", "#{@orgnl}/MndtRef",
        type: :text,
        length: "29 caracteres",
        requirement: :optional,
        what: "A solicitação anterior, quando esta substitui outra."
      ),
      entry(:orgnl_frqcy_tp, "tipoFrequencia", "#{@orgnl}/Ocrncs/Frqcy/Tp",
        type: :code,
        what: "A frequência da recorrência, repetida da pain.009.",
        codes: @frequencies
      ),
      entry(:orgnl_frst_colltn_dt, "dataInicialRecorrencia", "#{@orgnl}/Ocrncs/FrstColltnDt",
        type: :date,
        what: "Data da primeira cobrança."
      ),
      entry(:orgnl_fnl_colltn_dt, "dataFinalRecorrencia", "#{@orgnl}/Ocrncs/FnlColltnDt",
        type: :date,
        requirement: :optional,
        what: "Data da última cobrança."
      ),
      entry(:orgnl_trckg_ind, "indicadorObrigatorio", "#{@orgnl}/TrckgInd",
        type: :indicator,
        what: "Se a retentativa é obrigatória."
      ),
      entry(:orgnl_colltn_amt, "valor", "#{@orgnl}/ColltnAmt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        requirement: :optional,
        what: "Valor de cada cobrança."
      ),
      entry(:orgnl_cdtr_name, "nomeUsuarioRecebedor", "#{@orgnl}/Cdtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        what: "Nome de quem cobra."
      ),
      entry(:orgnl_cdtr_cpf_cnpj, "cpfCnpjUsuarioRecebedor", "#{@orgnl}/Cdtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "14 caracteres",
        what: "CNPJ de quem cobra."
      ),
      entry(
        :orgnl_cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@orgnl}/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem cobra."
      ),
      entry(:orgnl_dbtr_twn_nm, "codMunIBGE", "#{@orgnl}/Dbtr/PstlAdr/TwnNm",
        type: :text,
        length: "7 dígitos",
        what: "Código IBGE do município do pagador.",
        rule:
          "É código de município, não nome de cidade, apesar de a tag ser TwnNm. O catálogo " <>
            "reaproveitou o campo de endereço do ISO."
      ),
      entry(:orgnl_dbtr_cpf_cnpj, "cpfCnpjUsuarioPagador", "#{@orgnl}/Dbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem paga."
      ),
      entry(:orgnl_dbtr_acct_id, "contaUsuarioPagador", "#{@orgnl}/DbtrAcct/Id/Othr/Id",
        type: :numeric,
        length: "até 20 dígitos",
        what: "Conta de onde as cobranças saem."
      ),
      entry(:orgnl_dbtr_acct_issr, "agenciaUsuarioPagador", "#{@orgnl}/DbtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta pagadora."
      ),
      entry(
        :orgnl_dbtr_agt_ispb,
        "participanteDoUsuarioPagador",
        "#{@orgnl}/DbtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem paga."
      ),
      entry(:orgnl_ultmt_dbtr_name, "nomeDevedor", "#{@orgnl}/UltmtDbtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "Nome do devedor final, quando há um."
      ),
      entry(:orgnl_ultmt_dbtr_cpf_cnpj, "cpfCnpjDevedor", "#{@orgnl}/UltmtDbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        requirement: :optional,
        what: "CPF ou CNPJ do devedor final."
      ),
      entry(:orgnl_rfrd_doc_nb, "numeroContrato", "#{@orgnl}/RfrdDoc/Nb",
        type: :text,
        length: "até 35 caracteres",
        what: "Número do contrato da recorrência."
      ),
      entry(:orgnl_rfrd_doc_cdtr_ref, "descricao", "#{@orgnl}/RfrdDoc/CdtrRef",
        type: :text,
        length: "até 35 caracteres",
        requirement: :optional,
        what: "Descrição do contrato."
      )
    ]
  end

  defp processamento do
    [
      entry(:mndt_prcg_dtls, nil, "MndtAccptncRpt/SplmtryData/Envlp/MndtPrcgDtls",
        type: :text,
        length: "até 3 itens",
        what: "As datas do ciclo da recorrência.",
        rule:
          "Aqui o bloco é opcional e vai de 0 a 3 itens, ao contrário da pain.009, que exige " <>
            "exatamente 3."
      ),
      entry(
        :tp,
        "tipoSituacaoDaRecorrencia",
        "MndtAccptncRpt/SplmtryData/Envlp/MndtPrcgDtls/MndtPrcgTp",
        within: :mndt_prcg_dtls,
        type: :code,
        what: "Que marco esta data registra.",
        rule:
          "As quatro jornadas são as do Manual de Fluxos do Processo de Efetivação do Pix e " <>
            "dizem por qual caminho o pagador autorizou.",
        codes: %{
          "CRTN" => "Criação da recorrência.",
          "UPDT" => "Última atualização do status da recorrência.",
          "AUT1" => "Autorização efetivada pela jornada 1.",
          "AUT2" => "Autorização efetivada pela jornada 2.",
          "AUT3" => "Autorização efetivada pela jornada 3.",
          "AUT4" => "Autorização efetivada pela jornada 4."
        }
      ),
      entry(
        :dt_tm,
        "dataHoraTipoSituacaoDaRecorrencia",
        "MndtAccptncRpt/SplmtryData/Envlp/MndtPrcgDtls/PrcgDtTm",
        within: :mndt_prcg_dtls,
        type: :datetime,
        what: "Quando aquele marco aconteceu."
      )
    ]
  end
end
