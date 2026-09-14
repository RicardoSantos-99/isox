defmodule Isox.Dictionary.Reda017 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PtyRpt/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PtyRpt/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando o relatório foi criado."
      ),
      entry(:ispb, "participanteIndireto", "PtyRpt/RptOrErr/PtyRpt/PtyId/Id/Id/PrtryId/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante indireto de que este relatório trata."
      ),
      entry(
        :confirmation_deadline,
        "dataHoraLimiteConfirmacaoEncerramento",
        "PtyRpt/RptOrErr/PtyRpt/PtyOrErr/SysPty/MktSpcfcAttr/Val",
        type: :datetime,
        what: "Até quando o liquidante atual tem para confirmar o fim do relacionamento.",
        rule:
          "São 24 horas, contadas de quando outro participante pediu o registro do mesmo " <>
            "indireto. É esse pedido em suspenso que gera a reda.016 com QUED. O nome do " <>
            "atributo no XML é fixo (PRAZOCONFI) e por isso não aparece na struct."
      )
    ]
  end
end
