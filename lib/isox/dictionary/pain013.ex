defmodule Isox.Dictionary.Pain013 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @pmt "CdtrPmtActvtnReq/PmtInf"
  @tx "#{@pmt}/CdtTrfTx"

  @spec entries() :: [Entry.t()]
  def entries do
    cabecalho() ++ agendamento() ++ partes() ++ tributo()
  end

  defp cabecalho do
    [
      entry(:msg_id, "idMensagem", "CdtrPmtActvtnReq/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem. Em lote, vale para o XML inteiro.",
        rule:
          "O iniciador do agendamento (InitgPty) não é campo variável: o XSD exige 14 zeros " <>
            "literais, e por isso ele não aparece na struct. O mesmo vale para o método de " <>
            "pagamento (TRF), a prioridade (NORM), o tipo de prioridade (PAGAGD), a forma de " <>
            "iniciação (AUTO) e o participante tarifado (SLEV)."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "CdtrPmtActvtnReq/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a instrução foi criada. Em lote, vale para o XML inteiro."
      )
    ]
  end

  defp agendamento do
    [
      entry(:pmt_inf_id, "idConciliacaoRecebedor", "#{@pmt}/PmtInfId",
        type: :text,
        length: "até 35 caracteres",
        what: "Identificador da cobrança para o recebedor conciliar.",
        rule: "É o que a pain.014 devolve em orgnl_pmt_inf_id para dizer se aceitou."
      ),
      entry(
        :reqd_exctn_dt,
        "dataHoraRecebimentoPeloParticipanteDoUsuarioRecebedor",
        "#{@pmt}/ReqdExctnDt/DtTm",
        type: :datetime,
        requirement: :conditional,
        what: "Quando o pagamento deve ser executado.",
        rule:
          "O schema diz opcional, mas na prática é obrigatório com purp_prtry igual a AGND e " <>
            "proibido nos outros casos. Chegar com mais de 10 dias de antecedência traz " <>
            "pain.014 com FCD1; com menos de 2 dias, FCD2."
      ),
      entry(:xpry_dt, "dataDeVencimento", "#{@pmt}/XpryDt/Dt",
        type: :date,
        what: "Data de vencimento da cobrança.",
        rule:
          "Divergir da periodicidade da recorrência ou das regras do produto traz pain.014 " <>
            "com DTED."
      ),
      entry(:end_to_end_id, "idFimAFim", "#{@tx}/PmtId/EndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim que a pacs.008 vai carregar quando a data chegar.",
        rule:
          "É gerado aqui, não na hora do pagamento: a pacs.008 que nasce desta instrução " <>
            "repete este valor sem alterar."
      ),
      entry(:value, "valor", "#{@tx}/Amt/InstdAmt",
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        what: "Quanto vai ser cobrado.",
        rule:
          "Vai em InstdAmt, não em IntrBkSttlmAmt: ainda não houve liquidação. Valor acima " <>
            "do teto que o pagador definiu traz pain.014 com AM02; fora do que diz a " <>
            "recorrência, AM09."
      ),
      entry(:mndt_id, "idRecorrencia", "#{@tx}/MndtRltdInf/MndtId",
        type: :text,
        length: "29 caracteres",
        what: "A recorrência que autoriza esta cobrança.",
        rule:
          "Precisa existir e estar confirmada: inexistente traz pain.014 com MIDI, e status " <>
            "diferente de CFDB traz MSUC."
      ),
      entry(:purp_prtry, "finalidadeDoAgendamento", "#{@tx}/Purp/Prtry",
        type: :code,
        what: "Que tentativa é esta.",
        rule: "Aqui a finalidade vai em Prtry, com enum próprio, não em Cd como na pacs.008.",
        codes: %{
          "AGND" => "Primeira tentativa de pagamento da cobrança.",
          "NTAG" => "Nova tentativa de pagamento, depois do vencimento.",
          "RIFL" => "Reenvio da instrução por erro no fluxo de liquidação da original."
        }
      ),
      entry(:rmt_inf, "informacoesEntreUsuarios", "#{@tx}/RmtInf/Ustrd",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "Mensagem para o pagador."
      )
    ]
  end

  defp partes do
    [
      entry(:dbtr_cpf_cnpj, "cpfCnpjUsuarioPagador", "#{@pmt}/Dbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem paga.",
        rule: "Divergir da recorrência traz pain.014 com DENC."
      ),
      entry(
        :dbtr_agt_ispb,
        "participanteDoUsuarioPagador",
        "#{@pmt}/DbtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem paga, que é quem responde com a pain.014."
      ),
      entry(:ultmt_dbtr_name, "nomeDevedor", "#{@pmt}/UltmtDbtr/Nm",
        type: :text,
        length: "até 140 caracteres",
        requirement: :optional,
        what: "Nome do devedor final, quando quem paga não é quem deve."
      ),
      entry(:ultmt_dbtr_cpf_cnpj, "cpfCnpjDevedor", "#{@pmt}/UltmtDbtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        requirement: :optional,
        what: "CPF ou CNPJ do devedor final.",
        rule: "Incorreto traz pain.014 com UDEI."
      ),
      entry(
        :cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@tx}/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem cobra."
      ),
      entry(:cdtr_cpf_cnpj, "cpfCnpjUsuarioRecebedor", "#{@tx}/Cdtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "14 caracteres",
        what: "CNPJ de quem cobra.",
        rule: "Divergir da recorrência traz pain.014 com CRNC."
      ),
      entry(:cdtr_acct_id, "contaUsuarioRecebedor", "#{@tx}/CdtrAcct/Id/Othr/Id",
        type: :numeric,
        length: "até 20 dígitos",
        what: "Conta que vai receber."
      ),
      entry(:cdtr_acct_issr, "agenciaUsuarioRecebedor", "#{@tx}/CdtrAcct/Id/Othr/Issr",
        type: :numeric,
        length: "até 4 dígitos",
        requirement: :optional,
        what: "Agência da conta recebedora."
      ),
      entry(:cdtr_acct_type, "tipoContaUsuarioRecebedor", "#{@tx}/CdtrAcct/Tp/Cd",
        type: :code,
        what: "Tipo da conta recebedora.",
        rule:
          "Aqui o domínio é menor que o da pacs.008: só três tipos, sem conta-salário e sem " <>
            "Conta PI.",
        codes: %{
          "CACC" => "Conta corrente.",
          "SVGS" => "Conta de poupança.",
          "TRAN" => "Conta de pagamento."
        }
      )
    ]
  end

  defp tributo do
    [
      entry(:tax_ref_nb, "docFiscal", "#{@tx}/Tax/RefNb",
        type: :text,
        length: "até 50 caracteres",
        requirement: :optional,
        what: "Número do documento fiscal da cobrança."
      ),
      entry(:tax_records, "registro", "#{@tx}/Tax/Rcrd",
        type: :text,
        length: "2 a 4 itens",
        requirement: :optional,
        what: "Os tributos do Split Payment, quando a cobrança tem divisão de IBS e CBS.",
        rule:
          "Só é permitido quando dbtr_cpf_cnpj é CNPJ. Cada tipo de tributo precisa de um " <>
            "registro com ctgy INF, e a soma dos valores não pode passar do value."
      ),
      entry(:tp, "tipoTributo", "#{@tx}/Tax/Rcrd/Tp",
        within: :tax_records,
        type: :code,
        what: "Qual tributo.",
        codes: %{
          "IBSSPLIT" => "Imposto sobre Bens e Serviços.",
          "CBSSPLIT" => "Contribuição Social sobre Bens e Serviços."
        }
      ),
      entry(:ctgy, "categoriaTributo", "#{@tx}/Tax/Rcrd/Ctgy",
        within: :tax_records,
        type: :code,
        what: "Se este valor é o declarado ou o corrigido.",
        rule: "Quando os dois existem para o mesmo tributo, o corrigido prevalece.",
        codes: %{
          "INF" => "Valor informado, declarado pelo recebedor ou pelo pagador.",
          "COR" => "Valor corrigido, devolvido pela Plataforma Pública."
        }
      ),
      entry(:ttl_amt, "valorDoTributo", "#{@tx}/Tax/Rcrd/TaxAmt/TtlAmt",
        within: :tax_records,
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        what: "Quanto é o tributo."
      )
    ]
  end
end
