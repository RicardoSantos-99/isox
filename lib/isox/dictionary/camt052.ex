defmodule Isox.Dictionary.Camt052 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "BkToCstmrAcctRpt/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "BkToCstmrAcctRpt/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada. Em lote, vale para o XML inteiro."
      ),
      entry(:rpt_id, "idMensagemOriginal", "BkToCstmrAcctRpt/Rpt/Id",
        type: :text,
        length: "32 caracteres",
        what: "O msg_id da camt.060 que pediu este relatório.",
        rule: "É por ele que quem pediu casa a resposta com a pergunta."
      ),
      entry(:acct_ispb, "participanteDireto", "BkToCstmrAcctRpt/Rpt/Acct/Id/Othr/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do dono da Conta PI de que o relatório trata."
      ),
      entry(
        :nb_of_ntries,
        "quantidadeLancamentos",
        "BkToCstmrAcctRpt/Rpt/TxsSummry/TtlNtries/NbOfNtries",
        type: :numeric,
        length: "até 15 dígitos",
        what: "Quantos lançamentos o arquivo gerado tem."
      ),
      entry(:addtl_rpt_inf, "hashArquivoGerado", "BkToCstmrAcctRpt/Rpt/AddtlRptInf",
        type: :text,
        length: "até 500 caracteres",
        what: "Hash do arquivo gerado, para conferir a integridade depois de baixá-lo.",
        rule:
          "A camt.052 avisa que o arquivo existe e prova qual é; o arquivo em si vem pela " <>
            "interface de arquivos, fora do fluxo de mensagens."
      )
    ]
  end
end
