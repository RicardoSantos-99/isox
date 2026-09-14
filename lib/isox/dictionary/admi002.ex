defmodule Isox.Dictionary.Admi002 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:ref, "Referencia", "admi.002.001.01/RltdRef/Ref",
        type: :text,
        length: "33 caracteres",
        what: "A mensagem que foi recusada, identificada pelo msg_id dela.",
        rule:
          "É o único vínculo com o que deu errado. A admi.002 é usada quando a mensagem nem " <>
            "chegou a ser entendida, então não há como responder no formato dela."
      ),
      entry(:rjctg_pty_rsn, "MotivoDoErro", "admi.002.001.01/Rsn/RjctgPtyRsn",
        type: :text,
        length: "até 35 caracteres",
        what: "O motivo da recusa, em texto livre e curto.",
        rule:
          "35 caracteres é pouco e o limite é real: texto maior faz o encode falhar, e quem " <>
            "mandou a mensagem fica sem resposta nenhuma. Detalhe vai em rsn_desc."
      ),
      entry(:rjctn_dt_tm, "DataHoraDoErro", "admi.002.001.01/Rsn/RjctnDtTm",
        type: :datetime,
        requirement: :optional,
        what: "Quando a recusa aconteceu."
      ),
      entry(:err_lctn, "LocalizacaoDoErro", "admi.002.001.01/Rsn/ErrLctn",
        type: :text,
        length: "até 350 caracteres",
        requirement: :optional,
        what: "Onde na mensagem estava o problema, por exemplo o caminho do elemento."
      ),
      entry(:rsn_desc, "DescricaoDoErro", "admi.002.001.01/Rsn/RsnDesc",
        type: :text,
        length: "até 350 caracteres",
        requirement: :optional,
        what: "A explicação longa, que não coube no rjctg_pty_rsn."
      ),
      entry(:addtl_data, "DadosAdicionaisDoErro", "admi.002.001.01/Rsn/AddtlData",
        type: :text,
        length: "até 1000 caracteres",
        requirement: :optional,
        what: "Qualquer dado extra que ajude a entender a recusa."
      )
    ]
  end
end
