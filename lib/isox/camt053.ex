defmodule Isox.Camt053 do
  @moduledoc """
  Modelo ISO 20022 do camt.053 (saldo/demonstrativo da Conta PI,
  resposta a camt.060), versão 1.4.

  `Stmt` é `max: ilimitado`, simplificado pra exatamente 1 (mesma razão
  do `Camt052`: `camt.060` pede uma conta por vez). Já `Bal` dentro do
  `Stmt` é `max: ilimitado` de verdade — um extrato reporta vários tipos
  de saldo ao mesmo tempo (disponível, bloqueado, remuneração...) — e é
  modelado como lista.

  `CdtDbtInd` (enum de valor único `"CRDT"`) fica fixo.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Camt053.V1_4

  @type version :: :v1_4

  defstruct [:msg_id, :created_at, :stmt_id, :acct_ispb, balances: []]

  @type saldo :: %{tp_prtry: String.t(), value: String.t() | number(), dt_tm: DateTime.t()}

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          stmt_id: String.t(),
          acct_ispb: String.t(),
          balances: [saldo()]
        }

  @required_fields [:msg_id, :created_at, :stmt_id, :acct_ispb]

  @module_by_version %{v1_4: V1_4}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_4] do
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

  @doc "Decodifica um XML de camt.053 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_camt053, module.msg_def_idr()}}
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
      "BkToCstmrStmt" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "Stmt" => [
          %{
            "Id" => m.stmt_id,
            "Acct" => %{"Id" => %{"Othr" => %{"Id" => m.acct_ispb}}},
            "Bal" => Enum.map(m.balances, &balance_term/1)
          }
        ]
      }
    }
  end

  defp balance_term(s) do
    %{
      "Tp" => %{"CdOrPrtry" => %{"Prtry" => s.tp_prtry}},
      "Amt" => %{value: to_string(s.value), attributes: %{"Ccy" => "BRL"}},
      "CdtDbtInd" => "CRDT",
      "Dt" => %{"DtTm" => format_datetime(s.dt_tm)}
    }
  end

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "BkToCstmrStmt"])
    [stmt] = doc["Stmt"]

    %__MODULE__{
      msg_id: get_in(doc, ["GrpHdr", "MsgId"]),
      created_at: parse_datetime(get_in(doc, ["GrpHdr", "CreDtTm"])),
      stmt_id: stmt["Id"],
      acct_ispb: get_in(stmt, ["Acct", "Id", "Othr", "Id"]),
      balances: stmt |> Map.get("Bal", []) |> Enum.map(&balance_from_term/1)
    }
  end

  defp balance_from_term(t) do
    %{
      tp_prtry: get_in(t, ["Tp", "CdOrPrtry", "Prtry"]),
      value: get_in(t, ["Amt", :value]),
      dt_tm: get_in(t, ["Dt", "DtTm"]) |> parse_datetime()
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
