defmodule Isox.Dictionary.Pain011 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @orgnl "MndtCxlReq/UndrlygCxlDtls/OrgnlMndt/OrgnlMndt"

  @frequencies %{
    "WEEK" => "Semanal.",
    "MNTH" => "Mensal.",
    "QURT" => "Trimestral.",
    "MIAN" => "Semestral.",
    "YEAR" => "Anual."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    cabecalho() ++ cancelamento() ++ original() ++ processamento()
  end

  defp cabecalho do
    [
      entry(:msg_id, "idMensagem", "MndtCxlReq/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "MndtCxlReq/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando o pedido de cancelamento foi criado."
      ),
      entry(
        :instg_agt_ispb,
        "participanteEmissor",
        "MndtCxlReq/GrpHdr/InstgAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem está pedindo o cancelamento.",
        rule: "Pode ser o participante do pagador ou o do recebedor, conforme o motivo."
      )
    ]
  end

  defp cancelamento do
    [
      entry(
        :cxl_orgtr_cpf_cnpj,
        "cpfCnpjSolicitanteCancelamento",
        "MndtCxlReq/UndrlygCxlDtls/CxlRsn/Orgtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem pediu o cancelamento.",
        rule: "Divergir do pagador ou do recebedor da recorrência traz pain.012 com AP10."
      ),
      entry(:cxl_rsn_prtry, "motivoCancelamento", "MndtCxlReq/UndrlygCxlDtls/CxlRsn/Rsn/Prtry",
        type: :code,
        what: "Por que a recorrência está sendo cancelada.",
        codes: %{
          "SLDB" => "O usuário pagador pediu.",
          "SLCR" => "O usuário recebedor pediu.",
          "ACCL" => "A conta do pagador ou do recebedor foi encerrada.",
          "CPCL" => "A empresa recebedora encerrou as atividades.",
          "DCSD" => "Falecimento do usuário pagador.",
          "FRUD" => "Suspeita de fraude.",
          "SJUD" => "Ordem judicial.",
          "ERSL" => "Erro na solicitação de confirmação, que ainda estava pendente.",
          "NRES" =>
            "O participante do pagador não respondeu à pain.009 dentro do prazo " <>
              "regulamentar.",
          "PCFD" => "A mesma recorrência já foi confirmada por outra jornada, como QR Code.",
          "OTHS" => "Outros motivos. Só quando nenhum dos demais serve."
        }
      )
    ]
  end

  defp original do
    [
      entry(:orgnl_mndt_id, "idRecorrencia", "#{@orgnl}/MndtId",
        type: :text,
        length: "29 caracteres",
        what: "Identificador da recorrência que se quer cancelar.",
        rule: "Apontar para recorrência que não existe traz pain.012 com MD01."
      ),
      entry(:orgnl_mndt_req_id, "idSolicitacaoRecorrencia", "#{@orgnl}/MndtReqId",
        type: :text,
        length: "29 caracteres",
        what: "Identificador da solicitação que criou a recorrência."
      ),
      entry(:orgnl_frqcy_tp, "tipoFrequencia", "#{@orgnl}/Ocrncs/Frqcy/Tp",
        type: :code,
        what: "A frequência da recorrência original, repetida da pain.009.",
        codes: @frequencies
      ),
      entry(:orgnl_frst_colltn_dt, "dataInicialRecorrencia", "#{@orgnl}/Ocrncs/FrstColltnDt",
        type: :date,
        what: "Data da primeira cobrança, repetida da pain.009."
      ),
      entry(:orgnl_fnl_colltn_dt, "dataFinalRecorrencia", "#{@orgnl}/Ocrncs/FnlColltnDt",
        type: :date,
        requirement: :optional,
        what: "Data da última cobrança, repetida da pain.009."
      ),
      entry(:orgnl_trckg_ind, "indicadorObrigatorio", "#{@orgnl}/TrckgInd",
        type: :indicator,
        what: "Se a retentativa era obrigatória, repetido da pain.009."
      ),
      entry(:orgnl_colltn_amt, "valor", "#{@orgnl}/ColltnAmt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        requirement: :optional,
        what: "Valor de cada cobrança, repetido da pain.009."
      ),
      entry(:orgnl_cdtr_name, "nomeUsuarioRecebedor", "#{@orgnl}/Cdtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        what: "Nome de quem cobrava."
      ),
      entry(:orgnl_cdtr_cpf_cnpj, "cpfCnpjUsuarioRecebedor", "#{@orgnl}/Cdtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "14 caracteres",
        what: "CNPJ de quem cobrava.",
        rule: "Divergir da pain.009 traz pain.012 com AP06."
      ),
      entry(
        :orgnl_cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@orgnl}/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem cobrava.",
        rule: "Divergir da recorrência traz pain.012 com AP12."
      ),
      entry(:orgnl_dbtr_cpf_cnpj, "cpfCnpjUsuarioPagador", "#{@orgnl}/Dbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem pagava.",
        rule: "Divergir da pain.009 traz pain.012 com AP02."
      ),
      entry(:orgnl_dbtr_acct_id, "contaUsuarioPagador", "#{@orgnl}/DbtrAcct/Id/Othr/Id",
        type: :numeric,
        length: "até 20 dígitos",
        what: "Conta de onde as cobranças saíam."
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
        what: "ISPB do participante de quem pagava.",
        rule: "Divergir da recorrência traz pain.012 com AP11."
      ),
      entry(:orgnl_ultmt_dbtr_name, "nomeDevedor", "#{@orgnl}/UltmtDbtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "Nome do devedor final, quando havia um."
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
      entry(:mndt_prcg_dtls, nil, "#{@orgnl}/SplmtryData/Envlp/MndtPrcgDtls",
        type: :text,
        length: "exatamente 2 itens",
        what: "As duas datas do ciclo, sempre juntas e nesta ordem.",
        rule: "CRTN na primeira, CLTN na segunda. O schema diz [2..2], não é lista livre."
      ),
      entry(
        :tp,
        "tipoSituacaoDaRecorrencia",
        "#{@orgnl}/SplmtryData/Envlp/MndtPrcgDtls/MndtPrcgTp",
        within: :mndt_prcg_dtls,
        type: :code,
        what: "Que marco esta data registra.",
        codes: %{
          "CRTN" => "Criação da recorrência.",
          "CLTN" => "Cancelamento da recorrência."
        }
      ),
      entry(
        :dt_tm,
        "dataHoraTipoSituacaoDaRecorrencia",
        "#{@orgnl}/SplmtryData/Envlp/MndtPrcgDtls/PrcgDtTm",
        within: :mndt_prcg_dtls,
        type: :datetime,
        what: "Quando aquele marco aconteceu."
      )
    ]
  end
end
