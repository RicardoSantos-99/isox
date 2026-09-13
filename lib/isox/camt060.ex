defmodule Isox.Camt060 do
  @moduledoc """
  Modelo ISO 20022 do camt.060 (requisição de relatório da Conta
  PI), versão 1.9 — `ReqdMsgNmId` é o campo despachante: decide se a
  resposta é camt.052, camt.053 ou camt.054.

  `RptgPrd` (período do relatório) é opcional como um todo; quando
  presente no schema real, exige `FrDt` + `FrTm`/`ToTm` juntos (e `Tp`
  fixo em `"ALLL"`, que não é campo do modelo). O modelo usa
  `rptg_prd_fr_dt` como sinal de presença do período inteiro.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Camt060.V1_9

  @type version :: :v1_9

  defstruct [
    :msg_id,
    :created_at,
    :reqd_msg_nm_id,
    :acct_ownr_ispb,
    :id,
    :rptg_prd_fr_dt,
    :rptg_prd_to_dt,
    :rptg_prd_fr_tm,
    :rptg_prd_to_tm,
    :reqd_bal_tp_prtry
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          reqd_msg_nm_id: String.t(),
          acct_ownr_ispb: String.t(),
          id: String.t() | nil,
          rptg_prd_fr_dt: Date.t() | nil,
          rptg_prd_to_dt: Date.t() | nil,
          rptg_prd_fr_tm: Time.t() | nil,
          rptg_prd_to_tm: Time.t() | nil,
          reqd_bal_tp_prtry: String.t() | nil
        }

  @required_fields [:msg_id, :created_at, :reqd_msg_nm_id, :acct_ownr_ispb]

  @module_by_version %{v1_9: V1_9}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_9] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(message)
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Decodifica um XML de camt.060 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_camt060, module.msg_def_idr()}}
        end

      error ->
        error
    end
  end

  defp confirm(module, xml) do
    case module.decode(xml) do
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
      "AcctRptgReq" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "RptgReq" =>
          %{
            "Id" => m.id,
            "ReqdMsgNmId" => m.reqd_msg_nm_id,
            "AcctOwnr" => %{
              "Agt" => %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => m.acct_ownr_ispb}}}
            }
          }
          |> maybe_put("RptgPrd", rptg_prd_term(m))
          |> maybe_put(
            "ReqdBalTp",
            if(m.reqd_bal_tp_prtry, do: %{"CdOrPrtry" => %{"Prtry" => m.reqd_bal_tp_prtry}})
          )
      }
    }
  end

  defp rptg_prd_term(%{rptg_prd_fr_dt: nil}), do: nil

  defp rptg_prd_term(m) do
    %{
      "FrToDt" => %{
        "FrDt" => Date.to_iso8601(m.rptg_prd_fr_dt),
        "ToDt" => date_or_nil(m.rptg_prd_to_dt)
      },
      "FrToTm" => %{
        "FrTm" => format_time(m.rptg_prd_fr_tm),
        "ToTm" => format_time(m.rptg_prd_to_tm)
      },
      "Tp" => "ALLL"
    }
  end

  defp date_or_nil(nil), do: nil
  defp date_or_nil(%Date{} = d), do: Date.to_iso8601(d)

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "AcctRptgReq"])
    req = doc["RptgReq"]
    rptg_prd = req["RptgPrd"] || %{}

    %__MODULE__{
      msg_id: get_in(doc, ["GrpHdr", "MsgId"]),
      created_at: parse_datetime(get_in(doc, ["GrpHdr", "CreDtTm"])),
      reqd_msg_nm_id: req["ReqdMsgNmId"],
      acct_ownr_ispb: get_in(req, ["AcctOwnr", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      id: req["Id"],
      rptg_prd_fr_dt: rptg_prd |> get_in(["FrToDt", "FrDt"]) |> parse_date(),
      rptg_prd_to_dt: rptg_prd |> get_in(["FrToDt", "ToDt"]) |> parse_date(),
      rptg_prd_fr_tm: rptg_prd |> get_in(["FrToTm", "FrTm"]) |> parse_time(),
      rptg_prd_to_tm: rptg_prd |> get_in(["FrToTm", "ToTm"]) |> parse_time(),
      reqd_bal_tp_prtry: get_in(req, ["ReqdBalTp", "CdOrPrtry", "Prtry"])
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

  defp parse_date(nil), do: nil
  defp parse_date(text), do: Date.from_iso8601!(text)

  defp format_time(nil), do: nil

  defp format_time(%Time{} = t) do
    (t |> Map.put(:microsecond, {0, 6}) |> Time.truncate(:millisecond) |> Time.to_iso8601()) <>
      "Z"
  end

  defp parse_time(nil), do: nil
  defp parse_time(text), do: text |> String.trim_trailing("Z") |> Time.from_iso8601!()
end
