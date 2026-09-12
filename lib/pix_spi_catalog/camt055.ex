defmodule PixSpiCatalog.Camt055 do
  @moduledoc """
  Representação de domínio do camt.055 (pedido de cancelamento de ordem
  agendada — Pix Agendado), versão 1.1. Referencia a ordem agendada por
  `OrgnlEndToEndId` e traz motivo (`CxlRsnInf`). Todo campo do schema
  real é obrigatório.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt055.V1_1

  @type versao :: :v1_1

  defstruct [
    :assgnmt_id,
    :criado_em,
    :assgnr_ispb,
    :assgne_ispb,
    :pmt_cxl_id,
    :orgnl_pmt_inf_id,
    :orgtr_cpf_cnpj,
    :rsn_prtry,
    :orgnl_end_to_end_id,
    :cxl_prcg_tp,
    :prcg_dt_tm
  ]

  @type t :: %__MODULE__{
          assgnmt_id: String.t(),
          criado_em: DateTime.t(),
          assgnr_ispb: String.t(),
          assgne_ispb: String.t(),
          pmt_cxl_id: String.t(),
          orgnl_pmt_inf_id: String.t(),
          orgtr_cpf_cnpj: String.t(),
          rsn_prtry: String.t(),
          orgnl_end_to_end_id: String.t(),
          cxl_prcg_tp: String.t(),
          prcg_dt_tm: DateTime.t()
        }

  @campos_obrigatorios [
    :assgnmt_id,
    :criado_em,
    :assgnr_ispb,
    :assgne_ispb,
    :pmt_cxl_id,
    :orgnl_pmt_inf_id,
    :orgtr_cpf_cnpj,
    :rsn_prtry,
    :orgnl_end_to_end_id,
    :cxl_prcg_tp,
    :prcg_dt_tm
  ]

  @modulo_por_versao %{v1_1: V1_1}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_1] do
    with :ok <- validar_obrigatorios(mensagem) do
      modulo = Map.fetch!(@modulo_por_versao, versao)

      termo = %{
        "AppHdr" => AppHdr.termo(cabecalho, modulo.msg_def_idr()),
        "Document" => termo_document(mensagem)
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de camt.055 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt055, modulo.msg_def_idr()}}
        end

      erro ->
        erro
    end
  end

  defp confirmar(modulo, xml) do
    case modulo.parse(xml) do
      {:ok, _termo} -> {:ok, xml}
      {:error, motivo} -> {:error, motivo}
    end
  end

  defp validar_obrigatorios(mensagem) do
    faltando = Enum.filter(@campos_obrigatorios, &(Map.get(mensagem, &1) in [nil, ""]))

    if faltando == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(faltando)}"}
  end

  defp termo_document(m) do
    %{
      "CstmrPmtCxlReq" => %{
        "Assgnmt" => %{
          "Id" => m.assgnmt_id,
          "Assgnr" => %{"Agt" => agente_termo(m.assgnr_ispb)},
          "Assgne" => %{"Agt" => agente_termo(m.assgne_ispb)},
          "CreDtTm" => formatar_data_hora(m.criado_em)
        },
        "Undrlyg" => %{
          "OrgnlPmtInfAndCxl" => %{
            "PmtCxlId" => m.pmt_cxl_id,
            "OrgnlPmtInfId" => m.orgnl_pmt_inf_id,
            "CxlRsnInf" => %{
              "Orgtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgtr_cpf_cnpj}}}},
              "Rsn" => %{"Prtry" => m.rsn_prtry}
            },
            "TxInf" => %{
              "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
              "SplmtryData" => %{
                "Envlp" => %{
                  "CxlPrcgDtls" => %{
                    "CxlPrcgTp" => m.cxl_prcg_tp,
                    "PrcgDtTm" => formatar_data_hora(m.prcg_dt_tm)
                  }
                }
              }
            }
          }
        }
      }
    }
  end

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "CstmrPmtCxlReq"])
    assgnmt = doc["Assgnmt"]
    cxl = get_in(doc, ["Undrlyg", "OrgnlPmtInfAndCxl"])
    cxl_rsn = cxl["CxlRsnInf"]
    tx_inf = cxl["TxInf"]

    %__MODULE__{
      assgnmt_id: assgnmt["Id"],
      criado_em: parse_data_hora(assgnmt["CreDtTm"]),
      assgnr_ispb: get_in(assgnmt, ["Assgnr", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      assgne_ispb: get_in(assgnmt, ["Assgne", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      pmt_cxl_id: cxl["PmtCxlId"],
      orgnl_pmt_inf_id: cxl["OrgnlPmtInfId"],
      orgtr_cpf_cnpj: get_in(cxl_rsn, ["Orgtr", "Id", "PrvtId", "Othr", "Id"]),
      rsn_prtry: get_in(cxl_rsn, ["Rsn", "Prtry"]),
      orgnl_end_to_end_id: tx_inf["OrgnlEndToEndId"],
      cxl_prcg_tp: get_in(tx_inf, ["SplmtryData", "Envlp", "CxlPrcgDtls", "CxlPrcgTp"]),
      prcg_dt_tm:
        get_in(tx_inf, ["SplmtryData", "Envlp", "CxlPrcgDtls", "PrcgDtTm"]) |> parse_data_hora()
    }
  end

  defp formatar_data_hora(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_data_hora(nil), do: nil

  defp parse_data_hora(texto) do
    {:ok, dt, _offset} = DateTime.from_iso8601(texto)
    dt
  end
end
