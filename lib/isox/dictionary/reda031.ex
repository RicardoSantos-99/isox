defmodule Isox.Dictionary.Reda031 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PtyDeltnReq/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PtyDeltnReq/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando o pedido foi criado."
      ),
      entry(:ispb, "participanteIndireto", "PtyDeltnReq/SysPtyId/Id/Id/PrtryId/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante indireto para quem o serviço de liquidação vai acabar.",
        rule:
          "Ao contrário da reda.014, aqui o ISPB é o do indireto, não o de quem pede. " <>
            "Encerrar relação que não existe traz reda.016 com IND3."
      )
    ]
  end
end
