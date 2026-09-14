defmodule Isox.Dictionary.AppHdr do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:from_ispb, "ispbRemetente", "AppHdr/Fr/FIId/FinInstnId/Othr/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem está mandando a mensagem.",
        rule: "O SPI se identifica pelo ISPB 00038166."
      ),
      entry(:to_ispb, "ispbDestinatario", "AppHdr/To/FIId/FinInstnId/Othr/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB de quem deve receber a mensagem."
      ),
      entry(:biz_msg_idr, nil, "AppHdr/BizMsgIdr",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem no cabeçalho, no mesmo formato do msg_id.",
        rule:
          "A planilha HEAD001 do catálogo troca os nomes deste campo e do MsgDefIdr: chama " <>
            "este de tipoMensagem e o outro de idMensagem. O XSD e os exemplos oficiais não " <>
            "deixam dúvida: aqui vai o identificador (M0003816612345678901234567890123) e no " <>
            "MsgDefIdr vai o tipo (pacs.008.spi.1.16)."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "AppHdr/CreDt",
        type: :datetime,
        what: "Quando o cabeçalho foi criado.",
        rule: "UTC com milissegundos. Trunque para milissegundo antes de montar."
      )
    ]
  end
end
