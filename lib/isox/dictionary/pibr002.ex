defmodule Isox.Dictionary.Pibr002 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "EchoRpt/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta, não o da pibr.001 que a provocou."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "EchoRpt/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada."
      ),
      entry(:orgnl_data, "dadosOriginais", "EchoRpt/EchoTxInf/OrgnlData",
        type: :text,
        length: "até 35 caracteres",
        what: "O mesmo texto que veio no data da pibr.001, devolvido sem alteração."
      )
    ]
  end
end
