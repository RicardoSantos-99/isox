defmodule Isox.Dictionary.Pain009 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @mndt "MndtInitnReq/Mndt"

  @frequencies %{
    "WEEK" => "Semanal.",
    "MNTH" => "Mensal.",
    "QURT" => "Trimestral.",
    "MIAN" => "Semestral.",
    "YEAR" => "Anual."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    cabecalho() ++ recorrencia() ++ partes() ++ processamento()
  end

  defp cabecalho do
    [
      entry(:msg_id, "idMensagem", "MndtInitnReq/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "MndtInitnReq/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a solicitação foi criada. Em lote, vale para o XML inteiro."
      )
    ]
  end

  defp recorrencia do
    [
      entry(:mndt_id, "idRecorrencia", "#{@mndt}/MndtId",
        type: :text,
        length: "29 caracteres",
        what: "Identificador da recorrência, o que amarra toda a vida do Pix Automático.",
        rule:
          "É este valor que a pain.012 devolve para dizer se foi aceita, e que a pain.013 " <>
            "carrega em cada cobrança."
      ),
      entry(:mndt_req_id, "idSolicitacaoRecorrencia", "#{@mndt}/MndtReqId",
        type: :text,
        length: "29 caracteres",
        what: "Identificador desta solicitação, distinto do identificador da recorrência.",
        rule:
          "São dois: a recorrência é o vínculo duradouro, a solicitação é este pedido de " <>
            "autorização. Uma recorrência pode ter mais de uma solicitação ao longo da vida."
      ),
      entry(:frqcy_tp, "tipoFrequencia", "#{@mndt}/Ocrncs/Frqcy/Tp",
        type: :code,
        what: "De quanto em quanto tempo a cobrança se repete.",
        rule: "O tipo de recorrência (SeqTp) é fixo em RCUR e não aparece na struct.",
        codes: @frequencies
      ),
      entry(:frst_colltn_dt, "dataInicialRecorrencia", "#{@mndt}/Ocrncs/FrstColltnDt",
        type: :date,
        what: "Data da primeira cobrança."
      ),
      entry(:fnl_colltn_dt, "dataFinalRecorrencia", "#{@mndt}/Ocrncs/FnlColltnDt",
        type: :date,
        requirement: :optional,
        what: "Data da última cobrança. Sem ela, a recorrência não tem fim previsto."
      ),
      entry(:trckg_ind, "indicadorObrigatorio", "#{@mndt}/TrckgInd",
        type: :indicator,
        what: "Se a retentativa de cobrança é obrigatória quando o pagamento falha."
      ),
      entry(:colltn_amt, "valor", "#{@mndt}/ColltnAmt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        requirement: :optional,
        what: "Valor fixo de cada cobrança.",
        rule:
          "Fica vazio na recorrência de valor variável, que é quando o par adjstmnt_dt_ind e " <>
            "adjstmnt_amt entra em jogo."
      ),
      entry(:adjstmnt_dt_ind, "IndicadorPisoValorMaximo", "#{@mndt}/Adjstmnt/DtAdjstmntRuleInd",
        type: :indicator,
        requirement: :conditional,
        what: "Se o valor ao lado é piso ou teto.",
        rule: "Anda junto com adjstmnt_amt: os dois aparecem ou nenhum aparece."
      ),
      entry(:adjstmnt_amt, "pisoValorMaximo", "#{@mndt}/Adjstmnt/Amt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        requirement: :conditional,
        what: "O limite de valor da cobrança variável, piso ou teto conforme o indicador."
      )
    ]
  end

  defp partes do
    [
      entry(:cdtr_name, "nomeUsuarioRecebedor", "#{@mndt}/Cdtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        what: "Nome de quem vai cobrar."
      ),
      entry(:cdtr_cpf_cnpj, "cpfCnpjUsuarioRecebedor", "#{@mndt}/Cdtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "14 caracteres",
        what: "CNPJ de quem vai cobrar.",
        rule: "Só CNPJ: quem cobra por Pix Automático é pessoa jurídica."
      ),
      entry(
        :cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@mndt}/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem cobra."
      ),
      entry(:dbtr_cpf_cnpj, "cpfCnpjUsuarioPagador", "#{@mndt}/Dbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem vai pagar."
      ),
      entry(:dbtr_acct_id, "contaUsuarioPagador", "#{@mndt}/DbtrAcct/Id/Othr/Id",
        type: :numeric,
        length: "até 20 dígitos",
        what: "Conta de onde as cobranças vão sair."
      ),
      entry(:dbtr_acct_issr, "agenciaUsuarioPagador", "#{@mndt}/DbtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta pagadora."
      ),
      entry(
        :dbtr_agt_ispb,
        "participanteDoUsuarioPagador",
        "#{@mndt}/DbtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem paga. É ele que precisa autorizar a recorrência."
      ),
      entry(:ultmt_dbtr_name, "nomeDevedor", "#{@mndt}/UltmtDbtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "Nome do devedor final, quando quem paga não é quem deve.",
        rule: "Os dois campos de devedor final aparecem juntos ou nenhum aparece."
      ),
      entry(:ultmt_dbtr_cpf_cnpj, "cpfCnpjDevedor", "#{@mndt}/UltmtDbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        requirement: :optional,
        what: "CPF ou CNPJ do devedor final."
      ),
      entry(:rfrd_doc_nb, "numeroContrato", "#{@mndt}/RfrdDoc/Nb",
        type: :text,
        length: "até 35 caracteres",
        what: "Número do contrato que originou a recorrência."
      ),
      entry(:rfrd_doc_cdtr_ref, "descricao", "#{@mndt}/RfrdDoc/CdtrRef",
        type: :text,
        length: "até 35 caracteres",
        requirement: :optional,
        what: "Descrição livre do contrato, para o pagador reconhecer o que está autorizando."
      )
    ]
  end

  defp processamento do
    [
      entry(:mndt_prcg_dtls, nil, "#{@mndt}/SplmtryData/Envlp/MndtPrcgDtls",
        type: :text,
        length: "exatamente 3 itens",
        what: "As três datas do ciclo de autorização, sempre juntas e nesta ordem.",
        rule:
          "O schema diz [3..3] e a planilha fixa a ordem: CRTN na primeira, CRAT na segunda " <>
            "e EXPR na terceira. Não é lista livre."
      ),
      entry(
        :tp,
        "tipoSituacaoDaRecorrencia",
        "#{@mndt}/SplmtryData/Envlp/MndtPrcgDtls/MndtPrcgTp",
        within: :mndt_prcg_dtls,
        type: :code,
        what: "Que marco do ciclo esta data registra.",
        codes: %{
          "CRTN" => "Criação da recorrência.",
          "CRAT" => "Criação da solicitação de confirmação.",
          "EXPR" => "Expiração da solicitação de confirmação."
        }
      ),
      entry(
        :dt_tm,
        "dataHoraTipoSituacaoDaRecorrencia",
        "#{@mndt}/SplmtryData/Envlp/MndtPrcgDtls/PrcgDtTm",
        within: :mndt_prcg_dtls,
        type: :datetime,
        what: "Quando aquele marco aconteceu."
      )
    ]
  end
end
