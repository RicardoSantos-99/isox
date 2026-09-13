defmodule Isox.Camt052 do
  @moduledoc """
  Modelo ISO 20022 do camt.052 (relação de lançamentos da Conta
  PI, resposta a camt.060), versão 1.3.

  `Rpt` é `max: ilimitado` no schema — `camt.060` sempre pede o relatório
  de uma conta por vez, então o caminho comum é 1, mas `encode/3` aceita
  1 mensagem ou uma lista (lote: vários `Rpt` na mesma `Document`) e
  `decode/1` devolve 1 struct ou uma lista de volta, mesmo padrão do
  `Pacs002`/`Pacs004`/`Pacs008` (que têm exemplo oficial de lote real).

  Este perfil do BCB é resumido: só conta de lançamentos
  (`NbOfNtries`) e text livre (`AddtlRptInf`) — o detalhamento por
  lançamento é o camt.054, não este.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Camt052.V1_3

  @type version :: :v1_3

  defstruct [:msg_id, :created_at, :rpt_id, :acct_ispb, :nb_of_ntries, :addtl_rpt_inf]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          rpt_id: String.t(),
          acct_ispb: String.t(),
          nb_of_ntries: String.t() | non_neg_integer(),
          addtl_rpt_inf: String.t()
        }

  @required_fields [:msg_id, :created_at, :rpt_id, :acct_ispb, :nb_of_ntries, :addtl_rpt_inf]

  @module_by_version %{v1_3: V1_3}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista de mensagens (lote — vira vários
  `Rpt` na mesma `Document`).

  `msg_id`/`created_at` são de `GrpHdr` (uma vez por mensagem XML) — em
  lote, têm que ser iguais em todos os itens da lista.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v1_3] do
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
  Decodifica um XML de camt.052 de volta para a struct — ou, quando a
  mensagem traz mais de um `Rpt` (lote), para uma lista de structs.
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
      :error -> {:error, {:not_camt052, module.msg_def_idr()}}
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
      "BkToCstmrAcctRpt" => %{
        "GrpHdr" => %{"MsgId" => first.msg_id, "CreDtTm" => format_datetime(first.created_at)},
        "Rpt" => Enum.map(messages, &rpt_term/1)
      }
    }
  end

  defp rpt_term(m) do
    %{
      "Id" => m.rpt_id,
      "Acct" => %{"Id" => %{"Othr" => %{"Id" => m.acct_ispb}}},
      "TxsSummry" => %{"TtlNtries" => %{"NbOfNtries" => to_string(m.nb_of_ntries)}},
      "AddtlRptInf" => m.addtl_rpt_inf
    }
  end

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "BkToCstmrAcctRpt"])
    grp = doc["GrpHdr"]

    case doc["Rpt"] do
      [rpt] -> {:ok, rpt_from_term(grp, rpt)}
      rpts -> {:ok, Enum.map(rpts, &rpt_from_term(grp, &1))}
    end
  end

  defp rpt_from_term(grp, rpt) do
    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      rpt_id: rpt["Id"],
      acct_ispb: get_in(rpt, ["Acct", "Id", "Othr", "Id"]),
      nb_of_ntries: get_in(rpt, ["TxsSummry", "TtlNtries", "NbOfNtries"]),
      addtl_rpt_inf: rpt["AddtlRptInf"]
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
