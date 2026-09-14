defmodule Isox.Camt060 do
  @moduledoc """
  Consulta à Conta PI: saldo, extrato, relação de lançamentos ou detalhe
  de um lançamento.

  Versão 1.9. `reqd_msg_nm_id` é o campo que despacha: ele decide se a
  resposta volta como `Isox.Camt052`, `Isox.Camt053` ou `Isox.Camt054`.
  Junto com `reqd_bal_tp_prtry`, forma a pergunta completa.

  ## O período

  `RptgPrd` é opcional inteiro, e `rptg_prd_fr_dt` funciona como sinal de
  presença dele. `Tp` é fixo em `"ALLL"` e não vira campo.

  O horário (`rptg_prd_fr_tm` e `rptg_prd_to_tm`) é opcional por conta
  própria dentro do período, não exigido junto com as datas. A planilha é
  explícita: horário só entra na relação de lançamentos. Consulta de saldo
  de dia anterior, de remuneração da Conta PI e de arquivo `TRD` ou `TRT`
  usam só data. Os exemplos oficiais confirmam
  (`camt.060_SALDO_DATA_ANTERIOR`, `_SOLIC_REMUNERACAO_CONTA_PI`,
  `_SOLIC_ARQUIVO_TRD`, todos com `RptgPrd` sem `FrToTm`).

  #{Isox.Dictionary.doc(__MODULE__)}
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
    with :ok <- validate_required(message),
         :ok <- validate_rptg_prd_tm(message) do
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

  # FrTm/ToTm são obrigatórios juntos dentro de FrToTm no schema real
  # (nenhum dos dois tem minOccurs="0"), mas FrToTm inteiro é opcional
  # dentro de RptgPrd. rptg_prd_fr_tm e rptg_prd_to_tm têm que vir os
  # dois ou nenhum dos dois.
  defp validate_rptg_prd_tm(%{rptg_prd_fr_tm: nil, rptg_prd_to_tm: nil}), do: :ok

  defp validate_rptg_prd_tm(%{rptg_prd_fr_tm: fr_tm, rptg_prd_to_tm: to_tm})
       when not is_nil(fr_tm) and not is_nil(to_tm),
       do: :ok

  defp validate_rptg_prd_tm(_message) do
    {:error, "rptg_prd_fr_tm e rptg_prd_to_tm precisam vir juntos, ou nenhum dos dois"}
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
      "Tp" => "ALLL"
    }
    |> maybe_put("FrToTm", fr_to_tm_term(m))
  end

  defp fr_to_tm_term(%{rptg_prd_fr_tm: nil}), do: nil

  defp fr_to_tm_term(m) do
    %{"FrTm" => format_time(m.rptg_prd_fr_tm), "ToTm" => format_time(m.rptg_prd_to_tm)}
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
