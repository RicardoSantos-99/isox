defmodule PixSpiCatalog.Camt029 do
  @moduledoc """
  Representação de domínio do camt.029 (resposta ao camt.055 — aceite
  `ACCR` ou rejeição `RJCR`), versões 1.1 e 1.2 coexistindo. Correlaciona
  com o `PmtCxlId` do camt.055 original (aqui `OrgnlPmtInfCxlId`).

  `Sts.Conf` (enum de valor único `"INFO"`) fica fixo.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Generated.Camt029.{V1_1, V1_2}

  @type version :: :v1_1 | :v1_2

  defstruct [
    :assgnmt_id,
    :created_at,
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
          created_at: DateTime.t(),
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

  @required_fields [
    :assgnmt_id,
    :created_at,
    :assgnr_ispb,
    :assgne_ispb,
    :orgnl_pmt_inf_cxl_id,
    :orgnl_pmt_inf_id,
    :pmt_inf_cxl_sts,
    :orgnl_end_to_end_id,
    :cxl_prcg_tp,
    :prcg_dt_tm
  ]

  @module_by_version %{v1_1: V1_1, v1_2: V1_2}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = message, %AppHdr{} = header, version)
      when version in [:v1_1, :v1_2] do
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

  @doc "Parseia um XML de camt.029 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), version()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registry.parse(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_camt029, module.msg_def_idr()}}
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
      "RsltnOfInvstgtn" => %{
        "Assgnmt" => %{
          "Id" => m.assgnmt_id,
          "Assgnr" => %{"Agt" => agent_term(m.assgnr_ispb)},
          "Assgne" => %{"Agt" => agent_term(m.assgne_ispb)},
          "CreDtTm" => format_datetime(m.created_at)
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
            |> maybe_put(
              "CxlStsRsnInf",
              if(m.rsn_prtry, do: %{"Rsn" => %{"Prtry" => m.rsn_prtry}})
            )
        },
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
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "RsltnOfInvstgtn"])
    assgnmt = doc["Assgnmt"]
    orgnl = get_in(doc, ["CxlDtls", "OrgnlPmtInfAndSts"])
    cxl_prcg = get_in(doc, ["SplmtryData", "Envlp", "CxlPrcgDtls"])

    %__MODULE__{
      assgnmt_id: assgnmt["Id"],
      created_at: parse_datetime(assgnmt["CreDtTm"]),
      assgnr_ispb: get_in(assgnmt, ["Assgnr", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      assgne_ispb: get_in(assgnmt, ["Assgne", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_pmt_inf_cxl_id: orgnl["OrgnlPmtInfCxlId"],
      orgnl_pmt_inf_id: orgnl["OrgnlPmtInfId"],
      pmt_inf_cxl_sts: orgnl["PmtInfCxlSts"],
      orgnl_end_to_end_id: get_in(orgnl, ["TxInfAndSts", "OrgnlEndToEndId"]),
      rsn_prtry: get_in(orgnl, ["CxlStsRsnInf", "Rsn", "Prtry"]),
      cxl_prcg_tp: cxl_prcg["CxlPrcgTp"],
      prcg_dt_tm: parse_datetime(cxl_prcg["PrcgDtTm"])
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
