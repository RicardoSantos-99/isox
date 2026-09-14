defmodule Isox.Dictionary.Reda022 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @responsible %{
    "CONTATOPSP" => "Funcionário responsável pela gestão da Conta PI da instituição.",
    "DIRETORPSP" =>
      "Diretor estatutário, ou quem ocupa cargo equivalente, responsável pelo " <>
        "cumprimento das normas do SPI e da Conta PI."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "PtyModReq/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "PtyModReq/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando o pedido foi criado."
      ),
      entry(:ispb, "participanteDireto", "PtyModReq/SysPtyId/Id/Id/PrtryId/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante direto cujo cadastro está sendo alterado.",
        rule:
          "Tem que ser o próprio remetente. Mandar alteração no cadastro de outra " <>
            "instituição traz reda.016 com ATC7."
      ),
      entry(:mod, "tipoModificacao", "PtyModReq/Mod",
        type: :text,
        length: "exatamente 4 itens",
        what:
          "As quatro alterações, sempre juntas: contato, diretor, palavra-chave e CPF do " <>
            "diretor.",
        rule:
          "O schema diz [4..4], não ilimitado: é sempre o pacote inteiro, uma de cada " <>
            "variante, nunca um subconjunto. O ScpIndctn é fixo em INSE e não aparece aqui."
      ),
      entry(:type, nil, "PtyModReq/Mod/ReqdMod",
        within: :mod,
        type: :code,
        what: "Qual das quatro variantes é este item.",
        codes: %{
          "contact" => "Dados dos funcionários que cuidam da Conta PI.",
          "director" => "Dados do diretor responsável.",
          "tech_adr" => "A palavra-chave do participante.",
          "mkt_spcfc_attr" => "O CPF do diretor."
        }
      ),
      entry(:nm, "nomeDiretor", "PtyModReq/Mod/ReqdMod/CtctDtls/ReqdModDiretor/Nm",
        within: :mod,
        type: :text,
        length: "até 140 caracteres",
        what: "Nome do diretor. Só na variante director, e é o campo que a distingue de contact."
      ),
      entry(:phne_nb, "telefone01", "PtyModReq/Mod/ReqdMod/CtctDtls/*/PhneNb",
        within: :mod,
        type: :text,
        length: "até 30 caracteres",
        what: "Telefone principal, nas variantes contact e director.",
        rule: "Sem espaços."
      ),
      entry(:mob_nb, "telefone02", "PtyModReq/Mod/ReqdMod/CtctDtls/*/MobNb",
        within: :mod,
        type: :text,
        length: "até 30 caracteres",
        requirement: :optional,
        what: "Segundo telefone."
      ),
      entry(:fax_nb, "telefone03Responsavel", "PtyModReq/Mod/ReqdMod/CtctDtls/*/FaxNb",
        within: :mod,
        type: :text,
        length: "até 30 caracteres",
        requirement: :optional,
        what: "Terceiro telefone. Só existe na variante contact."
      ),
      entry(:email_adr, "email", "PtyModReq/Mod/ReqdMod/CtctDtls/*/EmailAdr",
        within: :mod,
        type: :text,
        length: "até 77 caracteres",
        what: "E-mail para onde o SPI manda informe."
      ),
      entry(:rspnsblty, "tipoResponsavel", "PtyModReq/Mod/ReqdMod/CtctDtls/*/Rspnsblty",
        within: :mod,
        type: :code,
        what: "Que papel a pessoa tem.",
        rule:
          "Casa com a variante: contact exige CONTATOPSP, director exige DIRETORPSP. O XSD " <>
            "só garante que é um dos dois, não que é o certo para o ramo, então quem valida " <>
            "isso é o encode/3. Trocar os dois traz reda.016 com RP13.",
        codes: @responsible
      ),
      entry(:tech_adr, "palavraChave", "PtyModReq/Mod/ReqdMod/TechAdr/TechAdr",
        within: :mod,
        type: :text,
        length: "8 caracteres",
        what: "A palavra-chave do participante. Só na variante tech_adr.",
        rule: "Não informar traz reda.016 com PCH8."
      ),
      entry(:val, "cpfDiretor", "PtyModReq/Mod/ReqdMod/MktSpcfcAttr/Val",
        within: :mod,
        type: :text,
        length: "11 dígitos",
        what: "CPF do diretor. Só na variante mkt_spcfc_attr.",
        rule:
          "O nome do atributo é fixo (CPFDIRETOR) e não aparece na struct. Não informar traz " <>
            "reda.016 com CP10."
      )
    ]
  end
end
