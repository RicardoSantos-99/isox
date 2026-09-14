defmodule Isox.Dictionary.Pibr001 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "EchoReq/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem.",
        rule: "Formato M + ISPB do emissor + 23 alfanuméricos, único dentro do emissor."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "EchoReq/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a mensagem foi criada.",
        rule: "UTC com milissegundos."
      ),
      entry(:data, "dados", "EchoReq/EchoTxInf/Data",
        type: :text,
        length: "até 35 caracteres",
        what: "O texto que vai e volta. Serve só para provar que o canal está de pé.",
        rule: "Volta idêntico no orgnl_data da pibr.002. É assim que se sabe que o eco fechou."
      )
    ]
  end
end
