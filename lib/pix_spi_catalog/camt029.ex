defmodule PixSpiCatalog.Camt029 do
  @moduledoc """
  Representação de domínio do camt.029 (resposta ao camt.055 — aceite
  `ACCR` ou rejeição `RJCR`), versões 1.1 e 1.2 coexistindo. Correlaciona
  com o `PmtCxlId` do camt.055 original (aqui `OrgnlPmtInfCxlId`).

  `Sts.Conf` (enum de valor único `"INFO"`) fica fixo.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt029.{V1_1, V1_2}

  @type versao :: :v1_1 | :v1_2

  defstruct [
    :assgnmt_id,
    :criado_em,
    :assgnr_ispb,
    :assgne_ispb,
    :orgnl_pmt_inf_cxl_id,
    :orgnl_pmt_inf_id,
    :pmt_inf_cxl_sts,
    :orgnl_end_to_end_id,
    :cxl_prcg_tp,
    :prcg_dt_tm,
    :rsn_prtry
  ]

  @type t :: %__MODULE__{
          assgnmt_id: String.t(),
          criado_em: DateTime.t(),
          assgnr_ispb: String.t(),
          assgne_ispb: String.t(),
          orgnl_pmt_inf_cxl_id: String.t(),
          orgnl_pmt_inf_id: String.t(),
          pmt_inf_cxl_sts: String.t(),
          orgnl_end_to_end_id: String.t(),
          cxl_prcg_tp: String.t(),
          prcg_dt_tm: DateTime.t(),
          rsn_prtry: String.t() | nil
        }

  @campos_obrigatorios [
    :assgnmt_id,
    :criado_em,
    :assgnr_ispb,
    :assgne_ispb,
    :orgnl_pmt_inf_cxl_id,
    :orgnl_pmt_inf_id,
    :pmt_inf_cxl_sts,
    :orgnl_end_to_end_id,
    :cxl_prcg_tp,
    :prcg_dt_tm
  ]

  @modulo_por_versao %{v1_1: V1_1, v1_2: V1_2}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao)
      when versao in [:v1_1, :v1_2] do
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

  @doc "Parseia um XML de camt.029 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt029, modulo.msg_def_idr()}}
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
      "RsltnOfInvstgtn" => %{
        "Assgnmt" => %{
          "Id" => m.assgnmt_id,
          "Assgnr" => %{"Agt" => agente_termo(m.assgnr_ispb)},
          "Assgne" => %{"Agt" => agente_termo(m.assgne_ispb)},
          "CreDtTm" => formatar_data_hora(m.criado_em)
        },
        "Sts" => %{"Conf" => "INFO"},
        "CxlDtls" => %{
          "OrgnlPmtInfAndSts" =>
            %{
              "OrgnlPmtInfCxlId" => m.orgnl_pmt_inf_cxl_id,
              "OrgnlPmtInfId" => m.orgnl_pmt_inf_id,
              "PmtInfCxlSts" => m.pmt_inf_cxl_sts,
              "TxInfAndSts" => %{"OrgnlEndToEndId" => m.orgnl_end_to_end_id}
            }
            |> talvez_por(
              "CxlStsRsnInf",
              if(m.rsn_prtry, do: %{"Rsn" => %{"Prtry" => m.rsn_prtry}})
            )
        },
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
  end

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "RsltnOfInvstgtn"])
    assgnmt = doc["Assgnmt"]
    orgnl = get_in(doc, ["CxlDtls", "OrgnlPmtInfAndSts"])
    cxl_prcg = get_in(doc, ["SplmtryData", "Envlp", "CxlPrcgDtls"])

    %__MODULE__{
      assgnmt_id: assgnmt["Id"],
      criado_em: parse_data_hora(assgnmt["CreDtTm"]),
      assgnr_ispb: get_in(assgnmt, ["Assgnr", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      assgne_ispb: get_in(assgnmt, ["Assgne", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_pmt_inf_cxl_id: orgnl["OrgnlPmtInfCxlId"],
      orgnl_pmt_inf_id: orgnl["OrgnlPmtInfId"],
      pmt_inf_cxl_sts: orgnl["PmtInfCxlSts"],
      orgnl_end_to_end_id: get_in(orgnl, ["TxInfAndSts", "OrgnlEndToEndId"]),
      rsn_prtry: get_in(orgnl, ["CxlStsRsnInf", "Rsn", "Prtry"]),
      cxl_prcg_tp: cxl_prcg["CxlPrcgTp"],
      prcg_dt_tm: parse_data_hora(cxl_prcg["PrcgDtTm"])
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
