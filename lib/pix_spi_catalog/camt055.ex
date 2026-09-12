defmodule PixSpiCatalog.Camt055 do
  @moduledoc """
  Representação de domínio do camt.055 (pedido de cancelamento de ordem
  agendada — Pix Agendado), versão 1.1. Referencia a ordem agendada por
  `OrgnlEndToEndId` e traz motivo (`CxlRsnInf`). Todo campo do schema
  real é obrigatório.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Generated.Camt055.V1_1

  @type version :: :v1_1

  defstruct [
    :assgnmt_id,
    :created_at,
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
          created_at: DateTime.t(),
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

  @required_fields [
    :assgnmt_id,
    :created_at,
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

  @module_by_version %{v1_1: V1_1}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_1] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(message)
      }

      with {:ok, xml} <- module.build(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Parseia um XML de camt.055 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), version()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registry.parse(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_camt055, module.msg_def_idr()}}
        end

      error ->
        error
    end
  end

  defp confirm(module, xml) do
    case module.parse(xml) do
      {:ok, _term} -> {:ok, xml}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_required(message) do
    missing = Enum.filter(@required_fields, &(Map.get(message, &1) in [nil, ""]))

    if missing == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(missing)}"}
  end

  defp document_term(m) do
    %{
      "CstmrPmtCxlReq" => %{
        "Assgnmt" => %{
          "Id" => m.assgnmt_id,
          "Assgnr" => %{"Agt" => agent_term(m.assgnr_ispb)},
          "Assgne" => %{"Agt" => agent_term(m.assgne_ispb)},
          "CreDtTm" => format_datetime(m.created_at)
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
                    "PrcgDtTm" => format_datetime(m.prcg_dt_tm)
                  }
                }
              }
            }
          }
        }
      }
    }
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "CstmrPmtCxlReq"])
    assgnmt = doc["Assgnmt"]
    cxl = get_in(doc, ["Undrlyg", "OrgnlPmtInfAndCxl"])
    cxl_rsn = cxl["CxlRsnInf"]
    tx_inf = cxl["TxInf"]

    %__MODULE__{
      assgnmt_id: assgnmt["Id"],
      created_at: parse_datetime(assgnmt["CreDtTm"]),
      assgnr_ispb: get_in(assgnmt, ["Assgnr", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      assgne_ispb: get_in(assgnmt, ["Assgne", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      pmt_cxl_id: cxl["PmtCxlId"],
      orgnl_pmt_inf_id: cxl["OrgnlPmtInfId"],
      orgtr_cpf_cnpj: get_in(cxl_rsn, ["Orgtr", "Id", "PrvtId", "Othr", "Id"]),
      rsn_prtry: get_in(cxl_rsn, ["Rsn", "Prtry"]),
      orgnl_end_to_end_id: tx_inf["OrgnlEndToEndId"],
      cxl_prcg_tp: get_in(tx_inf, ["SplmtryData", "Envlp", "CxlPrcgDtls", "CxlPrcgTp"]),
      prcg_dt_tm:
        get_in(tx_inf, ["SplmtryData", "Envlp", "CxlPrcgDtls", "PrcgDtTm"]) |> parse_datetime()
    }
  end

  defp format_datetime(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(text) do
    {:ok, dt, _offset} = DateTime.from_iso8601(text)
    dt
  end
end
