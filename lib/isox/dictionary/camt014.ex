defmodule Isox.Dictionary.Camt014 do
  @moduledoc false

  import Isox.Dictionary.Builder

  alias Isox.Dictionary.Entry

  @spec entries() :: [Entry.t()]
  def entries do
    [
      entry(:msg_id, "idMensagem", "RtrMmb/MsgHdr/MsgId",
        type: :text,
        length: "32 caracteres",
        what: "Identificador desta mensagem."
      ),
      entry(:created_at, "dataHoraCriacaoParaEmissao", "RtrMmb/MsgHdr/CreDtTm",
        type: :datetime,
        what: "Quando o aviso foi criado."
      ),
      entry(:mmb_id_ispb, "participante", "RtrMmb/RptOrErr/Rpt/MmbId/ClrSysMmbId/MmbId",
        type: :text,
        length: "8 caracteres",
        what: "ISPB do participante de que este aviso trata."
      ),
      entry(:mmb_nm, "nomeReduzidoParticipante", "RtrMmb/RptOrErr/Rpt/MmbOrErr/Mmb/Nm",
        type: :text,
        length: "até 140 caracteres",
        what: "Nome curto do participante, o que aparece para o usuário final."
      ),
      entry(
        :mmb_rtr_adr,
        "cnpjDoParticipante",
        "RtrMmb/RptOrErr/Rpt/MmbOrErr/Mmb/RtrAdr/Othr/Id",
        type: :text,
        length: "14 caracteres",
        what: "CNPJ do participante.",
        rule:
          "O nome do elemento no XML (RtrAdr, endereço de retorno) vem do ISO e não descreve " <>
            "o que o SPI põe aqui."
      ),
      entry(:mmb_tp_cd, "tipoParticipanteSpi", "RtrMmb/RptOrErr/Rpt/MmbOrErr/Mmb/Tp/Cd",
        type: :code,
        what: "Se o participante liquida direto no SPI ou depende de um liquidante.",
        codes: %{
          "DRCT" => "Participante direto, titular de Conta PI.",
          "IDRT" => "Participante indireto, que liquida através de um direto."
        }
      ),
      entry(:mmb_sts_cd, "situacaoParticipante", "RtrMmb/RptOrErr/Rpt/MmbOrErr/Mmb/Sts/Cd",
        type: :code,
        what: "O que mudou na situação do participante.",
        codes: %{
          "ENBL" => "Entrou ou voltou a operar no SPI.",
          "DLTD" => "Saiu ou foi suspenso do SPI."
        }
      ),
      entry(:full_lgl_nm, "nomeCompletoParticipante", "RtrMmb/PtyRoleIdSD1/FullLglNm",
        type: :text,
        length: "até 350 caracteres",
        what: "Razão social do participante."
      ),
      entry(
        :role_plyr_prtry,
        "modalidadeParticipacaoPix",
        "RtrMmb/PtyRoleIdSD1/RolePlyr/PtyRole/Prtry",
        type: :code,
        what: "O papel que a instituição exerce no arranjo Pix.",
        codes: %{
          "PDCT" =>
            "Provedor de conta transacional: oferece conta de depósito ou de pagamento " <>
              "pré-paga ao usuário final.",
          "ITUS" =>
            "Instituição usuária: autorizada pelo BCB, participa do Pix sem ofertar conta " <>
              "ao usuário final.",
          "LESP" => "Liquidante especial: presta serviço de liquidação a outros participantes.",
          "GOVE" => "Ente governamental ligado ao governo federal."
        }
      )
    ]
  end
end
