defmodule Isox.Dictionary.Camt054 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @ntry "BkToCstmrDbtCdtNtfctn/Ntfctn/Ntry"
  @tx "#{@ntry}/NtryDtls/TxDtls"

  @account_types %{
    "CACC" => "Conta corrente.",
    "SVGS" => "Conta de poupança.",
    "TRAN" => "Conta de pagamento.",
    "SLRY" => "Conta-salário. Uso exclusivo da STN e só como conta recebedora.",
    "OTHR" => "Conta PI, a conta do participante direto dentro do SPI."
  }

  @initiation %{
    "MANU" => "Digitação dos dados da conta.",
    "DICT" => "Digitação de chave Pix.",
    "QRES" => "Leitura de QR Code estático.",
    "QRDN" => "Leitura de QR Code dinâmico.",
    "APES" => "Aproximação, com dados de QR Code estático.",
    "APDN" => "Aproximação, com dados de QR Code dinâmico.",
    "INIC" => "Serviço de iniciação de transação de pagamento.",
    "AUTO" => "Pix Automático."
  }

  @purposes %{
    "IPAY" => "Compra ou transferência.",
    "GSCB" => "Pix Troco.",
    "OTHR" => "Pix Saque.",
    "REFU" => "Reembolso ao participante do pagador no âmbito do MED, no Pix Automático.",
    "IPRT" => "Devolução ao pagador no âmbito do MED 2.0."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    cabecalho() ++ lancamento() ++ referencias() ++ partes() ++ transacao() ++ erro()
  end

  defp cabecalho do
    [
      entry(:msg_id, "idMensagem", "BkToCstmrDbtCdtNtfctn/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "BkToCstmrDbtCdtNtfctn/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a mensagem foi criada. Em lote, vale para o XML inteiro."
      ),
      entry(:ntfctn_id, "idMensagemOriginal", "BkToCstmrDbtCdtNtfctn/Ntfctn/Id",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta notificação.",
        rule:
          "Quando o detalhamento foi pedido por camt.060, traz o msg_id da consulta. Quando " <>
            "o SPI notifica por conta própria, é um identificador novo."
      ),
      entry(:acct_ispb, "participanteDireto", "BkToCstmrDbtCdtNtfctn/Ntfctn/Acct/Id/Othr/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do dono da Conta PI onde o lançamento caiu."
      )
    ]
  end

  defp lancamento do
    [
      entry(:value, "valor", "#{@ntry}/Amt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        what: "Valor do lançamento.",
        rule: "Moeda sempre BRL."
      ),
      entry(:cdt_dbt_ind, "creditoOuDebito", "#{@ntry}/CdtDbtInd",
        type: :code,
        what: "De que lado da Conta PI o valor entrou.",
        rule:
          "É relativo ao dono da conta: o mesmo Pix gera DBIT na Conta PI do pagador e CRDT " <>
            "na do recebedor.",
        codes: %{"CRDT" => "Crédito.", "DBIT" => "Débito."}
      ),
      entry(:sts_cd, "situacaoDaTransacao", "#{@ntry}/Sts/Cd",
        type: :code,
        what: "Se o lançamento moveu dinheiro de verdade.",
        codes: %{
          "BOOK" => "Liquidado e contabilizado.",
          "INFO" => "Não liquidado. O registro existe só para informar."
        }
      ),
      entry(:bookg_dt, "dataContabil", "#{@ntry}/BookgDt/Dt",
        type: :date,
        requirement: :optional,
        what: "Data contábil do lançamento."
      ),
      entry(:val_dt, "dataHoraSituacao", "#{@ntry}/ValDt/DtTm",
        type: :datetime,
        requirement: :optional,
        what: "Quando o lançamento entrou na situação em que está."
      ),
      entry(:bktxcd_domn_cd, "dominio", "#{@ntry}/BkTxCd/Domn/Cd",
        type: :code,
        what: "A classificação mais ampla do lançamento.",
        rule: "Os três campos de BkTxCd descem em detalhe: domínio, família e subfamília.",
        codes: %{
          "PMNT" => "Pagamentos.",
          "CAMT" => "Aporte, retirada e linha de redesconto no SPI."
        }
      ),
      entry(:bktxcd_fmly_cd, "familia", "#{@ntry}/BkTxCd/Domn/Fmly/Cd",
        type: :code,
        what: "A família dentro do domínio.",
        codes: %{
          "IRCT" => "Transferência em tempo real a pagar, o débito na Conta PI.",
          "RRCT" => "Transferência em tempo real a receber, o crédito na Conta PI.",
          "MCOP" =>
            "Aporte na Conta PI vindo de conta reserva bancária, de liquidação ou de moeda " <>
              "eletrônica.",
          "MDOP" => "Retirada da Conta PI para uma dessas contas."
        }
      ),
      entry(:bktxcd_sub_fmly_cd, "subfamilia", "#{@ntry}/BkTxCd/Domn/Fmly/SubFmlyCd",
        type: :code,
        what: "A subfamília, o nível mais fino da classificação.",
        codes: %{
          "DMCT" => "Transferência de crédito doméstica.",
          "RRTN" => "Devolução de um pagamento.",
          "NTAV" => "Não se aplica. Só com domínio CAMT e família MCOP ou MDOP."
        }
      ),
      entry(:msg_nm_id, "nomeMensagemOrigem", "#{@ntry}/AddtlInfInd/MsgNmId",
        type: :text,
        length: "até 35 caracteres",
        what: "Que mensagem deu origem ao lançamento, por exemplo pacs.008.",
        rule:
          "É o que diz se o lançamento veio de um pagamento, de uma devolução ou de um aporte."
      )
    ]
  end

  defp referencias do
    [
      entry(:end_to_end_id, "IdFimAFim", "#{@tx}/Refs/EndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim do pagamento que gerou o lançamento.",
        rule: "É por ele que se liga o lançamento contábil ao Pix que o produziu."
      ),
      entry(:instr_id, "idInstrucao", "#{@tx}/Refs/InstrId",
        type: :text,
        length: "32 caracteres",
        requirement: :optional,
        what: "Identificador da instrução, quando a mensagem de origem trouxe um."
      ),
      entry(:tx_id, "idConciliacaoRecebedor", "#{@tx}/Refs/TxId",
        type: :text,
        length: "até 35 caracteres",
        requirement: :optional,
        what: "O identificador de conciliação do recebedor, repetido da mensagem de origem."
      ),
      entry(:clr_sys_ref, "numeroControleSTR", "#{@tx}/Refs/ClrSysRef",
        type: :text,
        length: "20 caracteres",
        requirement: :optional,
        what: "Número de controle no STR, quando o lançamento passou por lá."
      ),
      entry(:prtry_ref, "tipoPrioridadePagamento", "#{@tx}/Refs/Prtry/Ref",
        type: :code,
        requirement: :optional,
        what: "A prioridade do pagamento original.",
        rule: "O rótulo que acompanha (Prtry/Tp) é fixo em ServiceLevel e não aparece na struct.",
        codes: %{
          "PAGPRI" => "Pagamento prioritário.",
          "PAGFRD" => "Pagamento sob análise antifraude.",
          "PAGAGD" => "Pagamento agendado."
        }
      )
    ]
  end

  defp partes do
    [
      entry(
        :initg_pty_id,
        "cnpjIniciadorPagamento",
        "#{@tx}/RltdPties/InitgPty/Pty/Id/OrgId/Othr/Id",
        type: :text,
        length: "14 caracteres",
        requirement: :optional,
        what: "CNPJ do iniciador, quando houve um."
      ),
      entry(:dbtr_name, "nomeUsuarioPagador", "#{@tx}/RltdPties/Dbtr/Pty/Nm",
        type: :text,
        length: "até 140 caracteres",
        what: "Nome de quem pagou."
      ),
      entry(
        :dbtr_cpf_cnpj,
        "cpfCnpjUsuarioPagador",
        "#{@tx}/RltdPties/Dbtr/Pty/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem pagou."
      ),
      entry(:dbtr_acct_id, "contaUsuarioPagador", "#{@tx}/RltdPties/DbtrAcct/Id/Othr/Id",
        type: :text,
        length: "até 20 caracteres",
        what: "Conta de onde o dinheiro saiu."
      ),
      entry(:dbtr_acct_issr, "agenciaUsuarioPagador", "#{@tx}/RltdPties/DbtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta pagadora."
      ),
      entry(:dbtr_acct_type, "tipoContaUsuarioPagador", "#{@tx}/RltdPties/DbtrAcct/Tp/Cd",
        type: :code,
        what: "Tipo da conta pagadora.",
        codes: @account_types
      ),
      entry(
        :cdtr_cpf_cnpj,
        "cpfCnpjUsuarioRecebedor",
        "#{@tx}/RltdPties/Cdtr/Pty/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem recebeu."
      ),
      entry(:cdtr_acct_id, "contaUsuarioRecebedor", "#{@tx}/RltdPties/CdtrAcct/Id/Othr/Id",
        type: :text,
        length: "até 20 caracteres",
        what: "Conta que recebeu o dinheiro."
      ),
      entry(:cdtr_acct_issr, "agenciaUsuarioRecebedor", "#{@tx}/RltdPties/CdtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta recebedora."
      ),
      entry(:cdtr_acct_type, "tipoContaUsuarioRecebedor", "#{@tx}/RltdPties/CdtrAcct/Tp/Cd",
        type: :code,
        what: "Tipo da conta recebedora.",
        codes: @account_types
      ),
      entry(:cdtr_acct_proxy, "idContaTransacional", "#{@tx}/RltdPties/CdtrAcct/Prxy/Id",
        type: :text,
        length: "até 77 caracteres",
        requirement: :optional,
        what: "A chave Pix da conta recebedora, quando o pagamento nasceu de uma."
      ),
      entry(
        :dbtr_agt_ispb,
        "participanteDoUsuarioPagador",
        "#{@tx}/RltdAgts/DbtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        requirement: :optional,
        what: "ISPB do participante do pagador.",
        rule:
          "Diferente da pacs.008, aqui os dois agentes são opcionais cada um por si. O bloco " <>
            "que os contém é obrigatório, o conteúdo não."
      ),
      entry(
        :cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@tx}/RltdAgts/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        requirement: :optional,
        what: "ISPB do participante do recebedor."
      )
    ]
  end

  defp transacao do
    [
      entry(:lcl_instrm, "formaDeIniciacao", "#{@tx}/LclInstrm/Prtry",
        type: :code,
        requirement: :optional,
        what: "Como o pagamento original foi iniciado.",
        codes: @initiation
      ),
      entry(:purp_cd, "finalidadeDaTransacao", "#{@tx}/Purp/Cd",
        type: :code,
        requirement: :optional,
        what: "Para que servia o pagamento original.",
        codes: @purposes
      ),
      entry(:rmt_inf, "informacoesEntreUsuarios", "#{@tx}/RmtInf/Ustrd",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "A mensagem que o pagador escreveu."
      ),
      entry(
        :accptnc_dt_tm,
        "dataHoraRecebimentoPeloParticipanteDoUsuarioPagador",
        "#{@tx}/RltdDts/AccptncDtTm",
        type: :datetime,
        requirement: :optional,
        what: "Quando o participante do pagador recebeu o pedido do usuário."
      ),
      entry(:rtr_rsn_cd, "codigoDevolucao", "#{@tx}/RtrInf/Rsn/Cd",
        type: :code,
        requirement: :conditional,
        what: "Por que o pagamento foi devolvido.",
        rule: "Só existe quando o lançamento é de devolução.",
        codes: %{
          "MD06" => "Devolução pedida pelo usuário recebedor.",
          "BE08" => "Devolução no âmbito do MED, iniciada pelo participante do recebedor.",
          "FR01" => "Devolução no âmbito do MED, por fundada suspeita de fraude.",
          "SL02" => "Devolução por erro ou desacordo entre as partes em Pix Saque ou Pix Troco."
        }
      ),
      entry(:rtr_rsn_addtl_inf, "motivoDevolucao", "#{@tx}/RtrInf/AddtlInf",
        type: :text,
        length: "até 105 caracteres",
        requirement: :optional,
        what: "Detalhe da devolução em texto livre."
      ),
      entry(:addtl_tx_inf, "prioridadePagamento", "#{@tx}/AddtlTxInf",
        type: :code,
        requirement: :optional,
        what: "A prioridade da transação original.",
        rule:
          "O nome da tag (AdditionalTransactionInformation) sugere texto livre, mas não é: o " <>
            "tipo XSD é Priority2Code e só aceita estes dois valores. O catálogo reaproveitou " <>
            "o mesmo tipo ISO usado no InstrPrty da pacs.008.",
        codes: %{
          "HIGH" => "Liquidação prioritária.",
          "NORM" => "Liquidação não prioritária."
        }
      )
    ]
  end

  defp erro do
    [
      entry(:addtl_ntry_inf, "codigoDeErro", "#{@ntry}/AddtlNtryInf",
        type: :text,
        length: "4 caracteres",
        requirement: :optional,
        what: "Código do erro, quando a consulta que gerou esta resposta deu errado."
      ),
      entry(
        :addtl_ntfctn_inf,
        "detalhamentoDoErro",
        "BkToCstmrDbtCdtNtfctn/Ntfctn/AddtlNtfctnInf",
        type: :text,
        length: "até 105 caracteres",
        requirement: :optional,
        what: "Detalhe do erro em texto livre."
      )
    ]
  end
end
