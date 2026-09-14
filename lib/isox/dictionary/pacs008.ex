defmodule Isox.Dictionary.Pacs008 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @tx "FIToFICstmrCdtTrf/CdtTrfTxInf"
  @grp "FIToFICstmrCdtTrf/GrpHdr"

  @account_types %{
    "CACC" => "Conta corrente.",
    "SVGS" => "Conta de poupança.",
    "TRAN" => "Conta de pagamento.",
    "SLRY" => "Conta-salário. Uso exclusivo da STN e só como conta recebedora.",
    "OTHR" => "Conta PI, a conta do participante direto dentro do SPI."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "#{@grp}/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador da mensagem XML, único para sempre dentro do emissor.",
        rule:
          "Formato Mxxxxxxxxkkk...: M fixo, os 8 caracteres do ISPB de quem emite e 23 " <>
            "alfanuméricos livres. Diferencia maiúscula de minúscula e não pode se repetir " <>
            "em nenhuma outra mensagem enviada ao SPI. Em lote, é um só para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "#{@grp}/CreDtTm",
        type: :datetime,
        what: "Quando a mensagem foi criada por quem a envia.",
        rule:
          "UTC com milissegundos. Trunque para milissegundo antes de montar, senão o valor " <>
            "que volta do decode não é igual ao que entrou. Em lote, é um só para o XML inteiro."
      ),
      entry(:instr_prty, "prioridadePagamento", "#{@grp}/PmtTpInf/InstrPrty",
        type: :code,
        what: "Se o pagamento é prioritário.",
        rule: "Quando purp_cd é REFU ou IPRT, tem que ser HIGH.",
        codes: %{
          "HIGH" =>
            "Liquidação prioritária. O usuário pediu envio imediato, e o SPI leva em conta o " <>
              "tempo de validação informado pelo emissor para efeito de timeout.",
          "NORM" =>
            "Liquidação não prioritária. É o caso do Pix Agendado e do pagamento sob análise " <>
              "antifraude, em que o SPI desconsidera o tempo de validação do emissor."
        }
      ),
      entry(:svc_lvl_prtry, "tipoPrioridadePagamento", "#{@grp}/PmtTpInf/SvcLvl/Prtry",
        type: :code,
        what: "Por que o pagamento tem a prioridade que tem.",
        rule: "Casa com instr_prty: HIGH exige PAGPRI, NORM exige PAGFRD ou PAGAGD.",
        codes: %{
          "PAGPRI" => "Pagamento prioritário.",
          "PAGFRD" => "Pagamento sob análise antifraude.",
          "PAGAGD" => "Pagamento agendado."
        }
      ),
      entry(:end_to_end_id, "idFimAFim", "#{@tx}/PmtId/EndToEndId",
        type: :text,
        length: "32 caracteres",
        what:
          "Identificador do Pix, o mesmo do começo ao fim da cadeia. É por ele que se " <>
            "correlaciona a pacs.008 com a pacs.002 que responde a ela.",
        rule:
          "Formato ExxxxxxxxyyyyMMddHHmmkkk...: E fixo, 8 caracteres de quem gerou (ISPB do " <>
            "participante ou os 8 primeiros dígitos do CNPJ do iniciador), data e hora UTC " <>
            "até o minuto, e 11 alfanuméricos únicos dentro daquele minuto. Aceita 12 horas " <>
            "de tolerância, para frente e para trás, em relação ao processamento. Numa " <>
            "pacs.008 que nasce de uma pain.013, repete o idFimAFim da pain.013."
      ),
      entry(:tx_id, "idConciliacaoRecebedor", "#{@tx}/PmtId/TxId",
        type: :text,
        length: "até 35 caracteres",
        requirement: :conditional,
        what: "Identificador que o recebedor usa para conciliar o pagamento com a cobrança.",
        rule:
          "Depende de lcl_instrm: obrigatório em QRDN e APDN (26 a 35 caracteres), em INIC " <>
            "(até 25) e em AUTO quando não houver iniciador; em QRES e APES, só se o QR Code " <>
            "estático trouxer um; proibido em MANU e DICT."
      ),
      entry(:instr_id, "idTransacaoRaizContestacao", "#{@tx}/PmtId/InstrId",
        type: :text,
        length: "32 caracteres",
        requirement: :conditional,
        what: "A transação original que deu origem a uma contestação no MED.",
        rule:
          "Só existe na versão 1.16. Obrigatório quando purp_cd é IPRT. Em IPAY, só quando " <>
            "houver ID de recuperação de valores associado. Proibido em GSCB, REFU e OTHR."
      ),
      entry(:value, "valor", "#{@tx}/IntrBkSttlmAmt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        what: "Quanto sai da conta do pagador e entra na do recebedor.",
        rule:
          "Moeda sempre BRL, decimal separado por ponto. Em GSCB é a soma da compra com o " <>
            "saque; em OTHR, só o valor sacado."
      ),
      entry(
        :accptnc_dt_tm,
        "dataHoraRecebimentoPeloParticipanteDoUsuarioPagador",
        "#{@tx}/AccptncDtTm",
        type: :datetime,
        what: "Quando o PSP do pagador recebeu o pedido do usuário.",
        rule:
          "É o marco que o SPI usa para medir o timeout de pagamento prioritário: quanto " <>
            "tempo o PSP levou entre receber o pedido e mandar a ordem."
      ),
      entry(:lcl_instrm, "formaDeIniciacao", "#{@tx}/MndtRltdInf/Tp/LclInstrm/Prtry",
        type: :code,
        what: "Como o pagador iniciou o Pix. Decide quais outros campos são obrigatórios.",
        rule: "Quando purp_cd é REFU ou IPRT, tem que ser MANU.",
        codes: %{
          "MANU" => "Digitação dos dados da conta.",
          "DICT" => "Digitação de chave Pix.",
          "QRES" => "Leitura de QR Code estático.",
          "QRDN" => "Leitura de QR Code dinâmico.",
          "APES" => "Aproximação, com dados de QR Code estático.",
          "APDN" => "Aproximação, com dados de QR Code dinâmico.",
          "INIC" => "Serviço de iniciação de transação de pagamento.",
          "AUTO" => "Pix Automático."
        }
      ),
      entry(:initg_pty_id, "cnpjIniciadorPagamento", "#{@tx}/InitgPty/Id/OrgId/Othr/Id",
        type: :text,
        length: "14 caracteres",
        requirement: :optional,
        what: "CNPJ do iniciador, quando o Pix nasceu de um serviço de iniciação."
      ),
      entry(:dbtr_name, "nomeUsuarioPagador", "#{@tx}/Dbtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        what: "Nome de quem paga."
      ),
      entry(:dbtr_cpf_cnpj, "cpfCnpjUsuarioPagador", "#{@tx}/Dbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem paga, só os dígitos.",
        rule: "11 dígitos para CPF, 14 para CNPJ. Sem ponto, barra ou traço."
      ),
      entry(:dbtr_acct_id, "contaUsuarioPagador", "#{@tx}/DbtrAcct/Id/Othr/Id",
        type: :text,
        length: "até 20 caracteres",
        what: "Número da conta de onde o dinheiro sai, como o PSP do pagador a identifica."
      ),
      entry(:dbtr_acct_issr, "agenciaUsuarioPagador", "#{@tx}/DbtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta pagadora, para o PSP que trabalha com agência."
      ),
      entry(:dbtr_acct_type, "tipoContaUsuarioPagador", "#{@tx}/DbtrAcct/Tp/Cd",
        type: :code,
        what: "Que tipo de conta é a do pagador.",
        rule: "SLRY não vale aqui: conta-salário só aparece como conta recebedora.",
        codes: @account_types
      ),
      entry(
        :dbtr_agt_ispb,
        "participanteDoUsuarioPagador",
        "#{@tx}/DbtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante direto que atende o pagador, ou seja, quem vai ser debitado."
      ),
      entry(:cdtr_cpf_cnpj, "cpfCnpjUsuarioRecebedor", "#{@tx}/Cdtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem recebe, só os dígitos."
      ),
      entry(:cdtr_acct_id, "contaUsuarioRecebedor", "#{@tx}/CdtrAcct/Id/Othr/Id",
        type: :text,
        length: "até 20 caracteres",
        what: "Número da conta que recebe o dinheiro."
      ),
      entry(:cdtr_acct_issr, "agenciaUsuarioRecebedor", "#{@tx}/CdtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta recebedora."
      ),
      entry(:cdtr_acct_type, "tipoContaUsuarioRecebedor", "#{@tx}/CdtrAcct/Tp/Cd",
        type: :code,
        what: "Que tipo de conta é a do recebedor.",
        codes: @account_types
      ),
      entry(:cdtr_acct_proxy, "idContaTransacional", "#{@tx}/CdtrAcct/Prxy/Id",
        type: :text,
        length: "até 77 caracteres",
        requirement: :conditional,
        what: "A chave Pix da conta recebedora.",
        rule:
          "Obrigatória quando o pagamento nasceu de chave ou QR Code (DICT, QRES, QRDN, " <>
            "APES, APDN, INIC). Proibida quando os dados da conta foram digitados (MANU) e " <>
            "no Pix Automático (AUTO), porque nesses casos não houve chave nenhuma no meio."
      ),
      entry(
        :cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@tx}/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what:
          "ISPB do participante direto que atende o recebedor, ou seja, quem vai ser creditado."
      ),
      entry(:purp_cd, "finalidadeDaTransacao", "#{@tx}/Purp/Cd",
        type: :code,
        what: "Para que serve este pagamento. Muda a regra de vários outros campos.",
        codes: %{
          "IPAY" => "Compra ou transferência, o Pix do dia a dia.",
          "GSCB" => "Pix Troco: compra com saque de dinheiro em espécie no mesmo pagamento.",
          "OTHR" => "Pix Saque.",
          "REFU" =>
            "Reembolso ao participante do pagador no âmbito do MED, quando ele usou recurso " <>
              "próprio para ressarcir o usuário no Pix Automático.",
          "IPRT" =>
            "Devolução ao pagador no âmbito do MED 2.0, saindo da conta transacional do PSP " <>
              "que participou da cadeia de distribuição dos recursos da transação original."
        }
      ),
      entry(:rmt_inf, "informacoesEntreUsuarios", "#{@tx}/RmtInf/Ustrd",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "A mensagem que o pagador escreve para o recebedor."
      )
    ]
  end
end
