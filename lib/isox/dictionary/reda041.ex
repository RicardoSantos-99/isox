defmodule Isox.Dictionary.Reda041 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PtyActvtyAdvc/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PtyActvtyAdvc/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando o aviso foi criado."
      ),
      entry(:ispb, "participante", "PtyActvtyAdvc/PtyActvty/Chng/PtyId/Id/Id/PrtryId/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante que mudou."
      ),
      entry(:changes, nil, "PtyActvtyAdvc/PtyActvty/Rcrd/Othr",
        type: :text,
        length: "1 a 3 itens",
        what: "O que mudou no cadastro, um item por campo alterado.",
        rule:
          "No máximo 3, porque só existem 3 campos que podem mudar. Aqui a lista é o " <>
            "conteúdo da mensagem, não uma simplificação: um aviso pode trazer as três " <>
            "mudanças de uma vez."
      ),
      entry(:fld_nm, "valorAlterado", "PtyActvtyAdvc/PtyActvty/Rcrd/Othr/FldNm",
        within: :changes,
        type: :code,
        what: "Qual campo mudou.",
        codes: %{
          "MODP" => "Modalidade de participação no Pix.",
          "NOME" => "Nome do participante.",
          "NOMR" => "Nome reduzido do participante."
        }
      ),
      entry(:od_fld_val, "valorAntigo", "PtyActvtyAdvc/PtyActvty/Rcrd/Othr/OdFldVal",
        within: :changes,
        type: :text,
        length: "até 350 caracteres",
        what: "Como era antes."
      ),
      entry(:new_fld_val, "valorNovo", "PtyActvtyAdvc/PtyActvty/Rcrd/Othr/NewFldVal",
        within: :changes,
        type: :text,
        length: "até 350 caracteres",
        what: "Como ficou."
      )
    ]
  end
end
