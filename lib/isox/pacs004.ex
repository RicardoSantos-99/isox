defmodule Isox.Pacs004 do
  @moduledoc """
  Modelo ISO 20022 do pacs.004 (devolução), versão 1.5 — a ordem
  de devolução de uma pacs.008 já liquidada, referenciando a original por
  `OrgnlEndToEndId`.

  `TxInf` é `max: ilimitado` no XSD e o catálogo oficial documenta lote de
  verdade (`pacs.004_SPI_10_msg.xml`, 10 transações numa mensagem só).
  `encode/3` aceita 1 mensagem ou uma lista (lote); `decode/1` devolve 1
  struct ou uma lista, dependendo de quantas `TxInf` o XML trouxer.

  Mesma validação em duas camadas dos outros: `encode/3` confere
  obrigatoriedade do modelo e reaproveita o `decode` do próprio módulo
  gerado pra pattern/enum/cardinalidade, sem duplicar regra.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pacs004.V1_5

  @type version :: :v1_5

  defstruct [
    :msg_id,
    :created_at,
    :rtr_id,
    :orgnl_end_to_end_id,
    :value,
    :rtr_rsn_cd,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    sttlm_prty: "NORM",
    rtr_rsn_addtl_inf: nil,
    rmt_inf_ustrd: nil
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          rtr_id: String.t(),
          orgnl_end_to_end_id: String.t(),
          value: String.t() | number(),
          sttlm_prty: String.t(),
          rtr_rsn_cd: String.t(),
          rtr_rsn_addtl_inf: String.t() | nil,
          dbtr_agt_ispb: String.t(),
          cdtr_agt_ispb: String.t(),
          rmt_inf_ustrd: String.t() | nil
        }

  @required_fields [
    :msg_id,
    :created_at,
    :rtr_id,
    :orgnl_end_to_end_id,
    :value,
    :sttlm_prty,
    :rtr_rsn_cd,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb
  ]

  @module_by_version %{v1_5: V1_5}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista (lote — vira várias `TxInf` na
  mesma `Document`, com `NbOfTxs` ajustado à quantidade).

  `msg_id`/`created_at` são de `GrpHdr` (uma vez por mensagem XML) — em
  lote, têm que ser iguais em todos os itens da lista.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v1_5] do
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
  Decodifica um XML de pacs.004 de volta para a struct — ou, quando a
  mensagem traz mais de uma `TxInf` (lote), para uma lista de structs.
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
      :error -> {:error, {:not_pacs004, module.msg_def_idr()}}
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
      "PmtRtr" => %{
        "GrpHdr" => %{
          "MsgId" => first.msg_id,
          "CreDtTm" => format_datetime(first.created_at),
          "NbOfTxs" => messages |> length() |> to_string(),
          "SttlmInf" => %{"SttlmMtd" => "CLRG"}
        },
        "TxInf" => Enum.map(messages, &transaction_term/1)
      }
    }
  end

  defp transaction_term(m) do
    %{
      "RtrId" => m.rtr_id,
      "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
      "RtrdIntrBkSttlmAmt" => %{value: to_string(m.value), attributes: %{"Ccy" => "BRL"}},
      "SttlmPrty" => m.sttlm_prty,
      "ChrgBr" => "SLEV",
      "RtrRsnInf" => %{"Rsn" => %{"Cd" => m.rtr_rsn_cd}, "AddtlInf" => m.rtr_rsn_addtl_inf},
      "OrgnlTxRef" =>
        %{
          "DbtrAgt" => agent_term(m.dbtr_agt_ispb),
          "CdtrAgt" => agent_term(m.cdtr_agt_ispb)
        }
        |> maybe_put("RmtInf", rmt_inf_term(m.rmt_inf_ustrd))
    }
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp rmt_inf_term(nil), do: nil
  defp rmt_inf_term(text), do: %{"Ustrd" => text}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "PmtRtr"])
    grp = doc["GrpHdr"]

    case doc["TxInf"] do
      [tx] -> {:ok, tx_from_term(grp, tx)}
      txs -> {:ok, Enum.map(txs, &tx_from_term(grp, &1))}
    end
  end

  defp tx_from_term(grp, tx) do
    rsn_inf = tx["RtrRsnInf"]
    orgnl_ref = tx["OrgnlTxRef"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      rtr_id: tx["RtrId"],
      orgnl_end_to_end_id: tx["OrgnlEndToEndId"],
      value: get_in(tx, ["RtrdIntrBkSttlmAmt", :value]),
      sttlm_prty: tx["SttlmPrty"],
      rtr_rsn_cd: get_in(rsn_inf, ["Rsn", "Cd"]),
      rtr_rsn_addtl_inf: rsn_inf["AddtlInf"],
      dbtr_agt_ispb: get_in(orgnl_ref, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(orgnl_ref, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      rmt_inf_ustrd: get_in(orgnl_ref, ["RmtInf", "Ustrd"])
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
