defmodule Isox.Dictionary.Pacs002 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @tx "FIToFIPmtStsRpt/TxInfAndSts"

  @rejection_codes %{
    "AB03" => "Liquidação interrompida por timeout no SPI.",
    "AB09" => "Interrompida por erro no participante do recebedor.",
    "AB11" => "Timeout do participante que emitiu a ordem.",
    "AC03" => "Agência ou conta do recebedor inexistente ou inválida.",
    "AC06" => "Conta do recebedor bloqueada.",
    "AC07" => "Conta do recebedor encerrada.",
    "AC14" => "Tipo incorreto para a conta do recebedor.",
    "AG03" =>
      "Tipo de transação não autorizado nessa conta, por exemplo transferência para " <>
        "conta-salário.",
    "AG12" => "Pagamento entre duas contas da mesma instituição não passa pelo SPI.",
    "AG13" => "Não se devolve a devolução de um pagamento instantâneo.",
    "AGNT" => "O participante direto não é liquidante do participante do pagador.",
    "AM01" => "Valor zero.",
    "AM02" => "Valor supera o limite do tipo de conta creditada.",
    "AM04" => "Saldo insuficiente na Conta PI do participante do pagador.",
    "AM09" => "Devolução em valor maior que o pagamento original.",
    "AM12" => "A soma do bloco valorDoDinheiroOuCompra não bate com o campo valor.",
    "AM18" => "Quantidade de transações inválida.",
    "AM23" => "A soma dos tributos informados supera o valor da transação.",
    "BE01" => "CPF ou CNPJ do recebedor não corresponde ao titular da conta.",
    "BE05" => "CNPJ do iniciador de pagamento não está cadastrado no arranjo Pix.",
    "BE15" => "idConciliacaoRecebedor ausente ou preenchido de forma incorreta.",
    "BE17" => "QR Code recusado pelo participante do recebedor.",
    "CH11" => "CPF ou CNPJ do recebedor incorreto.",
    "CH16" => "Conteúdo da mensagem incorreto ou incompatível com as regras de negócio.",
    "CN01" => "O agendamento recorrente foi cancelado e o cancelamento já está confirmado.",
    "DS02" =>
      "Recusada por configuração da própria instituição no SPI-Web, como bloqueio manual.",
    "DS04" => "Recusada pelo participante do recebedor.",
    "DS0G" => "Quem assinou não tem permissão para assinar esse tipo de operação.",
    "DS27" => "O participante não está cadastrado ou ainda não começou a operar no SPI.",
    "DT02" => "Data e hora de envio da mensagem inválida.",
    "DT05" => "Passou do prazo máximo de devolução previsto no arranjo Pix.",
    "DU03" => "Recusada para evitar duplicidade: a cobrança já foi paga por outro arranjo.",
    "DUPL" =>
      "Pagamento em duplicidade, com o mesmo idConciliacaoRecebedor para o mesmo recebedor.",
    "ED05" => "Erro genérico no processamento do pagamento instantâneo.",
    "FF07" => "A finalidade da transação não combina com o preenchimento do bloco Strd.",
    "FF08" => "idFimAFim mal formatado.",
    "FRAD" => "Recusada por fundada suspeita de fraude.",
    "INDT" =>
      "Conteúdo incompatível com os parâmetros do QR Code ou da pain.013 que originou o " <>
        "pagamento.",
    "MD01" => "ISPB do facilitador de Pix Saque ou Pix Troco inexistente.",
    "RC09" => "ISPB do participante do pagador inválido ou inexistente.",
    "RC10" => "ISPB do participante do recebedor inválido ou inexistente.",
    "RR04" => "O pagador é sancionado por resolução do Conselho de Segurança da ONU.",
    "RR06" => "O bloco de tributo só vale quando pagador e recebedor são ambos pessoa jurídica.",
    "SL02" => "A pacs.004 referenciada não tem relação com Pix Saque ou Pix Troco.",
    "UPAY" => "Pagamento indevido: não há recorrência válida e ativa."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "FIToFIPmtStsRpt/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "FIToFIPmtStsRpt/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada. Em lote, vale para o XML inteiro."
      ),
      entry(:orgnl_instr_id, "idInstrucaoOriginal", "#{@tx}/OrgnlInstrId",
        type: :text,
        length: "32 caracteres",
        what: "O identificador da mensagem original que está sendo respondida.",
        rule:
          "Aceita identificador de pagamento (começa com E) e de devolução (começa com D), " <>
            "porque a pacs.002 responde tanto pacs.008 quanto pacs.004. O " <>
            "orgnl_end_to_end_id, ao lado, só aceita E."
      ),
      entry(:orgnl_end_to_end_id, "idFimAFimOriginal", "#{@tx}/OrgnlEndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim do pagamento de que esta resposta trata.",
        rule: "Sempre o do pagamento original, mesmo quando a resposta é sobre uma devolução."
      ),
      entry(:tx_sts, "situacaoDaTransacao", "#{@tx}/TxSts",
        type: :code,
        what: "O desfecho da transação. É o campo que se lê primeiro.",
        codes: %{
          "ACSC" => "Liquidado. Vai para o participante do pagador.",
          "ACCC" => "Liquidado. Vai para o participante do recebedor.",
          "ACSP" => "Aceito pelo participante do recebedor, ainda não liquidado.",
          "RJCT" => "Rejeitado pelo SPI ou pelo participante do recebedor."
        }
      ),
      entry(:sts_rsn_cd, "codigoDeErro", "#{@tx}/StsRsnInf/Rsn/Cd",
        type: :code,
        requirement: :conditional,
        what: "Por que a transação foi rejeitada.",
        rule:
          "Só aparece com tx_sts igual a RJCT. É a tabela mais consultada de quem integra " <>
            "com o SPI, e a que mais muda: confira sempre contra a versão do catálogo que " <>
            "você está usando.",
        codes: @rejection_codes
      ),
      entry(:sts_rsn_addtl_inf, "detalhamentoDoErro", "#{@tx}/StsRsnInf/AddtlInf",
        type: :text,
        length: "até 105 caracteres por item",
        requirement: :optional,
        what: "Detalhes do erro em texto livre, um por item da lista.",
        rule:
          "105 caracteres por item é limite real: texto maior faz o encode falhar, e quem " <>
            "mandou o pagamento fica sem resposta nenhuma em vez de receber a rejeição."
      ),
      entry(:fctv_intr_bk_sttlm_dt, "dataHoraLiquidacao", "#{@tx}/FctvIntrBkSttlmDt/DtTm",
        type: :datetime,
        requirement: :conditional,
        what: "O instante exato em que o SPI liquidou.",
        rule: "Só faz sentido quando houve liquidação."
      ),
      entry(:orgnl_intr_bk_sttlm_dt, "dataContabil", "#{@tx}/OrgnlTxRef/IntrBkSttlmDt",
        type: :date,
        requirement: :optional,
        what: "Data contábil da liquidação.",
        rule:
          "É a data contábil, que não é necessariamente o dia do relógio: perto da virada, " <>
            "a liquidação pode cair na data contábil seguinte."
      )
    ]
  end
end
