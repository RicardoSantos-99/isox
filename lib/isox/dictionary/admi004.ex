defmodule Isox.Dictionary.Admi004 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:description, "aviso", "SysEvtNtfctn/EvtInf/EvtDesc",
        type: :text,
        length: "até 1000 caracteres",
        what: "O texto do aviso que o SPI está mandando a todos os participantes.",
        rule:
          "O código do evento (EvtCd) é sempre SPI e não aparece na struct, porque não há " <>
            "outro valor possível. Toda a informação está neste texto."
      )
    ]
  end
end
