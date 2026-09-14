defmodule Isox.Dictionary.Camt053 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "BkToCstmrStmt/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta. Em lote, vale para o XML inteiro."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "BkToCstmrStmt/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada. Em lote, vale para o XML inteiro."
      ),
      entry(:stmt_id, "idMensagemOriginal", "BkToCstmrStmt/Stmt/Id",
        type: :text,
        length: "32 caracteres",
        what: "O msg_id da camt.060 que pediu este extrato."
      ),
      entry(:acct_ispb, "participanteDireto", "BkToCstmrStmt/Stmt/Acct/Id/Othr/Id",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do dono da Conta PI."
      ),
      entry(:balances, nil, "BkToCstmrStmt/Stmt/Bal",
        type: :text,
        length: "1 ou mais itens",
        what: "Os saldos reportados, um item por tipo.",
        rule:
          "Um extrato traz vários tipos ao mesmo tempo, por isso é lista. O indicador de " <>
            "sinal (CdtDbtInd) é fixo em CRDT e não aparece na struct."
      ),
      entry(:tp_prtry, "tipoValor", "BkToCstmrStmt/Stmt/Bal/Tp/CdOrPrtry/Prtry",
        within: :balances,
        type: :code,
        what: "Que saldo é este.",
        codes: %{
          "SADP" =>
            "Saldo disponível: o total da Conta PI já descontado do bloqueado. É o que " <>
              "sobra para liquidar.",
          "SABK" => "Saldo bloqueado, preso em pagamentos que estão em processo de liquidação.",
          "PSSR" => "Parcela do saldo diário da Conta PI sujeita à remuneração.",
          "REMN" => "Valor efetivo da remuneração da Conta PI.",
          "VSME" =>
            "Percentual dos recursos correspondentes a saldos de moeda eletrônica alocados " <>
              "no Banco Central.",
          "VVSR" =>
            "Percentual da média diária do Valor Sujeito a Recolhimento, usado no limite de " <>
              "remuneração da Conta PI."
        }
      ),
      entry(:value, "valor", "BkToCstmrStmt/Stmt/Bal/Amt",
        within: :balances,
        type: :amount,
        length: "até 18 dígitos, 2 decimais",
        what: "Quanto é este saldo.",
        rule: "Moeda sempre BRL."
      ),
      entry(:dt_tm, "dataHoraValor", "BkToCstmrStmt/Stmt/Bal/Dt/DtTm",
        within: :balances,
        type: :datetime,
        what: "A que momento o saldo se refere."
      )
    ]
  end
end
