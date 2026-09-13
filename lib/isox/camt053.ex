defmodule Isox.Camt053 do
  @moduledoc """
  Modelo ISO 20022 do camt.053 (saldo/demonstrativo da Conta PI,
  resposta a camt.060), versão 1.4.

  `Stmt` é `max: ilimitado` — `camt.060` pede uma conta por vez, então o
  caminho comum é 1, mas `encode/3` aceita 1 mensagem ou uma lista
  (lote: vários `Stmt` na mesma `Document`) e `decode/1` devolve 1
  struct ou uma lista de volta, mesmo padrão do `Pacs002`/`Pacs004`/
  `Pacs008`. Já `Bal` dentro de cada `Stmt` é `max: ilimitado` de
  verdade — um extrato reporta vários tipos de saldo ao mesmo tempo
  (disponível, bloqueado, remuneração...) — e é modelado como lista.

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

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista de mensagens (lote — vira vários
  `Stmt` na mesma `Document`).

  `msg_id`/`created_at` são de `GrpHdr` (uma vez por mensagem XML) — em
  lote, têm que ser iguais em todos os itens da lista.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v1_4] do
    with :ok <- validate_all_required(messages),
         :ok <- validate_shared_header(messages) do
      module = Map.fetch!(@module_by_version, version)
      [first | _] = messages

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(first, messages)
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc """
  Decodifica um XML de camt.053 de volta para a struct — ou, quando a
  mensagem traz mais de um `Stmt` (lote), para uma lista de structs.
  """
  @spec decode(binary()) :: {:ok, t() | [t(), ...], version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    with {:ok, module, term} <- Isox.Registry.decode(xml),
         {:ok, version} <- version_for(module),
         {:ok, message_or_messages} <- struct_from_term(term) do
      {:ok, message_or_messages, version}
    end
  end

  defp version_for(module) do
    case Map.fetch(@version_by_module, module) do
      {:ok, version} -> {:ok, version}
      :error -> {:error, {:not_camt053, module.msg_def_idr()}}
    end
  end

  defp confirm(module, xml) do
    case module.decode(xml) do
      {:ok, _term} -> {:ok, xml}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_all_required(messages) do
    Enum.reduce_while(messages, :ok, fn message, :ok ->
      case validate_required(message) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_required(message) do
    missing = Enum.filter(@required_fields, &(Map.get(message, &1) in [nil, ""]))

    if missing == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(missing)}"}
  end

  defp validate_shared_header([_single]), do: :ok

  defp validate_shared_header([%{msg_id: msg_id, created_at: created_at} | rest]) do
    if Enum.all?(rest, &(&1.msg_id == msg_id and &1.created_at == created_at)) do
      :ok
    else
      {:error, "msg_id/created_at precisam ser iguais em todas as mensagens do lote"}
    end
  end

  defp document_term(first, messages) do
    %{
      "BkToCstmrStmt" => %{
        "GrpHdr" => %{"MsgId" => first.msg_id, "CreDtTm" => format_datetime(first.created_at)},
        "Stmt" => Enum.map(messages, &stmt_term/1)
      }
    }
  end

  defp stmt_term(m) do
    %{
      "Id" => m.stmt_id,
      "Acct" => %{"Id" => %{"Othr" => %{"Id" => m.acct_ispb}}},
      "Bal" => Enum.map(m.balances, &balance_term/1)
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
    grp = doc["GrpHdr"]

    case doc["Stmt"] do
      [stmt] -> {:ok, stmt_from_term(grp, stmt)}
      stmts -> {:ok, Enum.map(stmts, &stmt_from_term(grp, &1))}
    end
  end

  defp stmt_from_term(grp, stmt) do
    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
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
