defmodule Isox.Dictionary.Reda014 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PtyCreReq/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem. É por ele que a reda.016 de resposta se amarra."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PtyCreReq/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando o pedido foi criado."
      ),
      entry(:ispb, "participanteDireto", "PtyCreReq/Pty/PtyId/Id/Id/PrtryId/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante direto que está pedindo o registro, ou seja, o liquidante.",
        rule:
          "Não é o participante que está sendo registrado, é quem pede. O indireto entra no " <>
            "cnpj. Tem que bater com o ispbRemetente do cabeçalho: se divergir, o SPI " <>
            "responde reda.016 com DIR2."
      ),
      entry(:cnpj, "cnpjParticipanteIndireto", "PtyCreReq/Pty/MktSpcfcAttr/Val",
        type: :text,
        length: "14 caracteres",
        what: "CNPJ do participante indireto que está sendo registrado.",
        rule:
          "Os 8 primeiros dígitos (a raiz do CNPJ) não podem já estar registrados por outro " <>
            "participante indireto, senão o SPI responde IND5."
      )
    ]
  end
end
