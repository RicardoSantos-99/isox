defmodule Isox.Dictionary.Trck002 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @tx "PmtStsTrckrRpt/TrckrStsAndTx/Tx"

  @account_types %{
    "CACC" => "Conta corrente.",
    "SVGS" => "Conta de poupança.",
    "TRAN" => "Conta de pagamento.",
    "SLRY" => "Conta-salário. Uso exclusivo da STN.",
    "OTHR" => "Conta PI, a conta do participante direto dentro do SPI."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PmtStsTrckrRpt/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador deste reporte. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PmtStsTrckrRpt/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando o reporte foi criado. Em lote, vale para o XML inteiro."
      ),
      entry(:end_to_end_id, "idFimAFim", "#{@tx}/PmtId/EndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim da transação que está sendo reportada.",
        rule:
          "A trck.002 reporta ao BC um pagamento que o participante liquidou internamente, " <>
            "sem passar pelo SPI. O situacaoDaTransacao é sempre ACCC e por isso nem aparece " <>
            "na struct: só se reporta o que já foi liquidado."
      ),
      entry(:instr_id, "idInstrucaoDevolucao", "#{@tx}/PmtId/InstrId",
        type: :text,
        length: "32 caracteres",
        requirement: :conditional,
        what: "O idOperacao da devolução, quando o que se reporta é uma devolução.",
        rule: "Só existe quando a transação reportada é devolução. Mesmo padrão do rtr_id."
      ),
      entry(:lcl_instrm, "formaDeIniciacao", "#{@tx}/PmtTpInf/LclInstrm/Prtry",
        type: :code,
        what: "Como o pagamento foi iniciado. Decide se a chave Pix é obrigatória ou proibida.",
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
      entry(:pmt_scnro_prtry, "tipoDaTransacaoReportada", "#{@tx}/PmtScnro/Prtry",
        type: :code,
        what: "Se pagador e recebedor estão no mesmo participante.",
        codes: %{
          "BOK1" => "Pagador e recebedor no mesmo participante.",
          "BOK2" => "Pagador e recebedor em participantes diferentes."
        }
      ),
      entry(:value, "valor", "#{@tx}/IntrBkSttlmAmt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        what: "Valor da transação reportada.",
        rule: "Moeda sempre BRL."
      ),
      entry(:reqd_exctn_dt, "DataHoraDaTransacao", "#{@tx}/ReqdExctnDt/DtTm",
        type: :datetime,
        what: "Quando o participante liquidou a transação internamente.",
        rule:
          "É a partir daqui que se mede o atraso do reporte. O Manual de Tempos pede 99% dos " <>
            "reportes em até 300 segundos, mas isso é indicador de nível de serviço medido " <>
            "por percentil, não limite por mensagem: reporte atrasado é aceito do mesmo " <>
            "jeito. O prazo que é regra são os 30 dias."
      ),
      entry(:dbtr_cpf_cnpj, "cpfCnpjUsuarioPagador", "#{@tx}/Dbtr/Pty/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem pagou."
      ),
      entry(:dbtr_acct_id, "contaUsuarioPagador", "#{@tx}/DbtrAcct/Id/Othr/Id",
        type: :text,
        length: "até 20 caracteres",
        what: "Conta de onde o dinheiro saiu."
      ),
      entry(:dbtr_acct_issr, "agenciaUsuarioPagador", "#{@tx}/DbtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta pagadora."
      ),
      entry(:dbtr_acct_type, "tipoContaUsuarioPagador", "#{@tx}/DbtrAcct/Tp/Cd",
        type: :code,
        what: "Tipo da conta pagadora.",
        codes: @account_types
      ),
      entry(
        :dbtr_agt_ispb,
        "participanteDoUsuarioPagador",
        "#{@tx}/DbtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante do pagador.",
        rule: "Igual ao do recebedor em BOK1, diferente em BOK2."
      ),
      entry(
        :cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@tx}/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante do recebedor."
      ),
      entry(:cdtr_cpf_cnpj, "cpfCnpjUsuarioRecebedor", "#{@tx}/Cdtr/Pty/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem recebeu."
      ),
      entry(:cdtr_acct_id, "contaUsuarioRecebedor", "#{@tx}/CdtrAcct/Id/Othr/Id",
        type: :text,
        length: "até 20 caracteres",
        what: "Conta que recebeu o dinheiro."
      ),
      entry(:cdtr_acct_issr, "agenciaUsuarioRecebedor", "#{@tx}/CdtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta recebedora."
      ),
      entry(:cdtr_acct_type, "tipoContaUsuarioRecebedor", "#{@tx}/CdtrAcct/Tp/Cd",
        type: :code,
        what: "Tipo da conta recebedora.",
        rule:
          "SLRY não vale aqui: conta-salário não recebe pagamento. O XSD aceita, porque " <>
            "reusa o mesmo enum da conta pagadora, mas a planilha proíbe e o encode/3 " <>
            "rejeita.",
        codes: @account_types
      ),
      entry(:cdtr_acct_proxy, "idContaTransacional", "#{@tx}/CdtrAcct/Prxy/Id",
        type: :text,
        length: "até 77 caracteres",
        requirement: :conditional,
        what: "A chave Pix da conta recebedora.",
        rule:
          "Obrigatória com DICT, QRES, QRDN, APES, APDN e INIC. Proibida com MANU e AUTO. O " <>
            "XSD só diz que é opcional, então quem faz valer essa regra é o encode/3."
      )
    ]
  end
end
