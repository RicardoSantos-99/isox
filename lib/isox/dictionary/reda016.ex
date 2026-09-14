defmodule Isox.Dictionary.Reda016 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @error_codes %{
    "ATC7" => "Tentou alterar dados de contato de uma instituição que não é a solicitante.",
    "CAI4" => "O participante indireto não tem cadastro.",
    "CP10" => "CPF do diretor responsável não informado.",
    "CTT9" => "Dados de contato dos responsáveis pela Conta PI não informados.",
    "DI11" => "Dados do diretor responsável não informados.",
    "DIR1" => "Tentou registrar ou descontinuar um participante direto.",
    "DIR2" => "O participante direto que pede o registro não é o remetente da mensagem.",
    "EXP5" => "O prazo de confirmação da instrução expirou.",
    "IND2" => "Tentou registrar participante indireto que já tem vínculo de liquidação.",
    "IND3" => "Tentou descontinuar participante indireto que não tem vínculo de liquidação.",
    "IND4" =>
      "Tentou registrar como indireta uma instituição que prescinde de autorização do BCB, " <>
        "sem ser responsável por ela no arranjo Pix.",
    "IND5" => "Já existe participante indireto com essa raiz de 8 dígitos do CNPJ.",
    "ITC6" => "Recusada porque há outra instrução em suspenso.",
    "PCH8" => "Palavra-chave não informada.",
    "RP13" => "Tipo do responsável pelo participante incorreto."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PtyStsAdvc/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PtyStsAdvc/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada."
      ),
      entry(:orgnl_msg_id, "idMensagemOriginal", "PtyStsAdvc/MsgHdr/OrgnlBizInstr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "O msg_id do pedido que está sendo respondido, seja reda.014, reda.022 ou reda.031."
      ),
      entry(:sts, "situacaoSolicitacao", "PtyStsAdvc/PtySts/Sts",
        type: :code,
        what: "O que aconteceu com o pedido.",
        codes: %{
          "COMP" => "Processado com sucesso.",
          "QUED" =>
            "Em suspenso. É o que vem quando se pede o registro de um participante indireto " <>
              "que já tem liquidante: o liquidante atual ganha 24 horas para confirmar o fim " <>
              "do relacionamento.",
          "REJT" => "Rejeitado."
        }
      ),
      entry(:rsn_prtry, "codigoDeErro", "PtyStsAdvc/PtySts/StsRsn/Rsn/Prtry",
        type: :code,
        requirement: :conditional,
        what: "Por que o pedido não passou direto.",
        rule: "Obrigatório em QUED e REJT, proibido em COMP.",
        codes: @error_codes
      ),
      entry(:sys_pty_ispb, "participante", "PtyStsAdvc/PtySts/SysPtyId/Id/Id/PrtryId/Id",
        type: :text,
        length: "8 caracteres",
        requirement: :conditional,
        what: "ISPB do participante que o pedido tratava.",
        rule:
          "O inverso do rsn_prtry: obrigatório em COMP, proibido em QUED e REJT. Faz " <>
            "sentido, porque só o pedido que deu certo tem participante para apontar."
      ),
      entry(
        :rspnsbl_pty_ispb,
        "participanteDireto",
        "PtyStsAdvc/PtySts/SysPtyId/RspnsblPtyId/Id/PrtryId/Id",
        type: :text,
        length: "8 caracteres",
        requirement: :optional,
        what: "ISPB do participante direto que passou a liquidar para ele.",
        rule: "Mora dentro do bloco do sys_pty_ispb, então não existe sem ele."
      )
    ]
  end
end
