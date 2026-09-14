defmodule Isox.Dictionary.Pacs004 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @tx "PmtRtr/TxInf"

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PmtRtr/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PmtRtr/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a devolução foi criada. Em lote, vale para o XML inteiro."
      ),
      entry(:rtr_id, "idOperacao", "#{@tx}/RtrId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta devolução, o equivalente ao idFimAFim de um pagamento.",
        rule:
          "Mesmo formato do idFimAFim, mas começa com D em vez de E. É por ele que a " <>
            "pacs.002 de resposta se refere à devolução."
      ),
      entry(:orgnl_end_to_end_id, "idFimAFim", "#{@tx}/OrgnlEndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim do pagamento que está sendo devolvido.",
        rule:
          "Aponta sempre para o pagamento original, nunca para uma devolução anterior: " <>
            "devolver uma devolução é recusado com AG13."
      ),
      entry(:value, "valor", "#{@tx}/RtrdIntrBkSttlmAmt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        what: "Quanto está sendo devolvido.",
        rule:
          "Pode ser menor que o original, porque devolução parcial é permitida, mas nunca " <>
            "maior. A soma das devoluções também não pode passar do valor original, senão a " <>
            "resposta vem com AM09."
      ),
      entry(:sttlm_prty, "prioridadePagamento", "#{@tx}/SttlmPrty",
        type: :code,
        what: "Se a devolução é prioritária.",
        codes: %{
          "HIGH" => "O usuário recebedor do pagamento original pediu envio imediato.",
          "NORM" => "Envio não prioritário."
        }
      ),
      entry(:rtr_rsn_cd, "codigoDevolucao", "#{@tx}/RtrRsnInf/Rsn/Cd",
        type: :code,
        what: "Por que o pagamento está sendo devolvido. Decide as regras que o SPI aplica.",
        codes: %{
          "MD06" => "Devolução pedida pelo usuário recebedor.",
          "BE08" =>
            "Devolução no âmbito do MED, iniciada pelo participante do recebedor. Usado " <>
              "sempre que houver falha operacional.",
          "FR01" => "Devolução no âmbito do MED, por fundada suspeita de fraude.",
          "SL02" =>
            "Devolução por erro na transação ou desacordo entre as partes em Pix Saque ou " <>
              "Pix Troco. Exige que o pagamento original tenha sido um dos dois, senão a " <>
              "resposta vem com SL02 de volta."
        }
      ),
      entry(:rtr_rsn_addtl_inf, "motivoDevolucao", "#{@tx}/RtrRsnInf/AddtlInf",
        type: :text,
        length: "até 105 caracteres",
        requirement: :optional,
        what: "Explicação da devolução em texto livre."
      ),
      entry(:rmt_inf_ustrd, "informacoesEntreUsuarios", "#{@tx}/OrgnlTxRef/RmtInf/Ustrd",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "Mensagem para o usuário que recebe a devolução."
      ),
      entry(
        :dbtr_agt_ispb,
        "participanteDoUsuarioPagador",
        "#{@tx}/OrgnlTxRef/DbtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante do pagador do pagamento original.",
        rule:
          "Os dois agentes mantêm os papéis do pagamento original, não se invertem: quem " <>
            "pagou continua sendo o dbtr, mesmo que agora o dinheiro volte para ele."
      ),
      entry(
        :cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@tx}/OrgnlTxRef/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante do recebedor do pagamento original, que agora devolve."
      )
    ]
  end
end
