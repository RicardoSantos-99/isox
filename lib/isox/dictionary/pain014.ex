defmodule Isox.Dictionary.Pain014 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @sts "CdtrPmtActvtnReqStsRpt/OrgnlPmtInfAndSts"
  @tx "#{@sts}/TxInfAndSts"

  @rejection_codes %{
    "AB10" => "Interrompida por erro no participante do pagador.",
    "AC05" => "Conta do pagador encerrada.",
    "AC06" => "Conta do pagador bloqueada.",
    "AM02" => "Valor da cobrança acima do máximo que o pagador estabeleceu.",
    "AM09" => "Valor da cobrança diferente do estabelecido na recorrência.",
    "CRNC" => "CNPJ do recebedor não corresponde ao da recorrência.",
    "DENC" => "CPF ou CNPJ do pagador não corresponde ao da recorrência.",
    "DTED" => "Data de vencimento em desacordo com a periodicidade ou com as regras do produto.",
    "DTNT" => "Nova tentativa pós-vencimento fora do limite de dias da regra de negócio.",
    "FCD1" => "pain.013 recebida com mais de 10 dias de antecedência da liquidação prevista.",
    "FCD2" => "pain.013 recebida com menos de 2 dias de antecedência da liquidação prevista.",
    "GRER" => "Erro genérico. Só quando nenhum outro código serve.",
    "IRNT" => "Esta cobrança recorrente não admite nova tentativa pós-vencimento.",
    "MIDI" => "idRecorrencia inexistente ou incorreto.",
    "MSUC" => "A recorrência não está confirmada pelo usuário pagador.",
    "NIEC" => "A mesma cobrança já tem ordem agendada, ainda pendente de envio ao SPI.",
    "NIPA" => "O pagamento já foi efetivado.",
    "NITX" => "A instrução não corresponde a nenhuma cobrança recorrente gerada antes.",
    "QUNT" => "Excedeu o limite de novas tentativas pós-vencimento.",
    "UDEI" => "CPF ou CNPJ do devedor final incorreto."
  }

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "CdtrPmtActvtnReqStsRpt/GrpHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta resposta. Em lote, vale para o XML inteiro.",
        rule:
          "Três campos obrigatórios do grupo não aparecem na struct porque o XSD os fixa em " <>
            "zeros literais: o iniciador do agendamento ([0]{14}), o identificador da " <>
            "mensagem original ([0]{32}) e o tipo dela ([0]{8}). A correlação de verdade " <>
            "acontece em orgnl_pmt_inf_id e orgnl_end_to_end_id, não no grupo."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "CdtrPmtActvtnReqStsRpt/GrpHdr/CreDtTm",
        type: :datetime,
        what: "Quando a resposta foi criada. Em lote, vale para o XML inteiro."
      ),
      entry(:orgnl_pmt_inf_id, "idConciliacaoRecebedorOriginal", "#{@sts}/OrgnlPmtInfId",
        type: :text,
        length: "até 35 caracteres",
        what: "O pmt_inf_id da pain.013 que está sendo respondida."
      ),
      entry(:orgnl_end_to_end_id, "idFimAFimOriginal", "#{@tx}/OrgnlEndToEndId",
        type: :text,
        length: "32 caracteres",
        what: "O idFimAFim da instrução agendada."
      ),
      entry(:tx_sts, "situacaoDaTransacao", "#{@sts}/PmtInfSts",
        type: :code,
        what: "Se o participante do pagador aceitou a instrução.",
        rule:
          "O schema só define estes dois: não existe estado de fila ou pendência na " <>
            "pain.014.",
        codes: %{
          "ACSP" => "Aceita após as validações do participante do pagador.",
          "RJCT" => "Rejeitada pelo participante do pagador."
        }
      ),
      entry(:rsn_prtry, "codigoDeErro", "#{@sts}/StsRsnInf/Rsn/Prtry",
        type: :code,
        requirement: :conditional,
        what: "Por que a instrução foi rejeitada.",
        rule: "Obrigatório com RJCT, proibido com ACSP.",
        codes: @rejection_codes
      ),
      entry(
        :dbtr_dcsn_dt_tm,
        "dataHoraAceitacaoOuRejeicaoDoAgendamento",
        "#{@tx}/DbtrDcsnDtTm",
        type: :datetime,
        what: "Quando o participante do pagador decidiu."
      ),
      entry(
        :cdtr_agt_ispb,
        "participanteDoUsuarioRecebedor",
        "#{@tx}/OrgnlTxRef/CdtrAgt/FinInstnId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de quem cobra, repetido da pain.013."
      ),
      entry(
        :cdtr_cpf_cnpj,
        "cpfCnpjUsuarioRecebedor",
        "#{@tx}/OrgnlTxRef/Cdtr/Id/PrvtId/Othr/Id",
        type: :text,
        length: "11 ou 14 dígitos",
        what: "CPF ou CNPJ de quem cobra, repetido da pain.013."
      )
    ]
  end
end
