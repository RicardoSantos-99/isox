defmodule Isox.Camt025 do
  @moduledoc """
  Recibo: a resposta a uma ou mais `Isox.Trck002`.

  Versão 1.0. Um recibo responde até 500 reportes de uma vez, cada um
  aceito ou rejeitado por conta própria: o mesmo recibo pode ter aceite e
  rejeição misturados. A correlação de cada item é por `orgnl_msg_id` e
  `orgnl_pmt_id`.

  ## O motivo da rejeição

  O bloco `StsRsn` existe quando `sts` é `"RJCT"`. Quem decide se ele
  aparece é `rsn_prtry`, porque `Rsn` é obrigatório dentro dele e
  `AddtlInf` é que é opcional. Por isso `addtl_inf` sem `rsn_prtry` é
  rejeitado em `encode/3`: não haveria como montar um `StsRsn` válido.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Camt025.V1_0

  @type version :: :v1_0

  defstruct [:msg_id, :created_at, confirmations: []]

  @type confirmation :: %{
          orgnl_msg_id: String.t(),
          orgnl_pmt_id: String.t(),
          sts: String.t(),
          rsn_prtry: String.t() | nil,
          addtl_inf: String.t() | nil
        }

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          confirmations: [confirmation()]
        }

  @required_fields [:msg_id, :created_at]

  @module_by_version %{v1_0: V1_0}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_0] do
    with :ok <- validate_required(message),
         :ok <- validate_confirmations(message.confirmations) do
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

  @doc "Decodifica um XML de camt.025 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_camt025, module.msg_def_idr()}}
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

  # StsRsn.Rsn é obrigatório sempre que StsRsn aparece no schema real, e
  # AddtlInf é o campo opcional, não o contrário. addtl_inf sem
  # rsn_prtry não tem como virar XML válido (StsRsn exigiria Rsn), mas
  # sem esta checagem o erro só aparecia depois, no round-trip de
  # confirm/2, como "elemento obrigatório ausente: Rsn", confuso pra
  # quem não conhece a árvore XML interna.
  defp validate_confirmations(confirmations) do
    Enum.reduce_while(confirmations, :ok, fn c, :ok ->
      case validate_confirmation(c) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_confirmation(c) do
    if Map.get(c, :addtl_inf) != nil and Map.get(c, :rsn_prtry) == nil do
      {:error, "confirmação com addtl_inf mas sem rsn_prtry: StsRsn exige Rsn quando presente"}
    else
      :ok
    end
  end

  defp document_term(m) do
    %{
      "Rct" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "RctDtls" => Enum.map(m.confirmations, &confirmation_term/1)
      }
    }
  end

  defp confirmation_term(c) do
    %{
      "OrgnlMsgId" => %{"MsgId" => c.orgnl_msg_id},
      "OrgnlPmtId" => %{"PrtryId" => c.orgnl_pmt_id},
      "ReqHdlg" =>
        %{"Sts" => %{"Cd" => c.sts}}
        |> maybe_put("StsRsn", sts_rsn_term(c))
    }
  end

  defp sts_rsn_term(c) do
    case Map.get(c, :rsn_prtry) do
      nil ->
        nil

      rsn_prtry ->
        %{"Rsn" => %{"Prtry" => rsn_prtry}} |> maybe_put("AddtlInf", Map.get(c, :addtl_inf))
    end
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "Rct"])

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
      confirmations: doc |> Map.get("RctDtls", []) |> Enum.map(&confirmation_from_term/1)
    }
  end

  defp confirmation_from_term(t) do
    stsrsn = t["ReqHdlg"]["StsRsn"] || %{}

    %{
      orgnl_msg_id: get_in(t, ["OrgnlMsgId", "MsgId"]),
      orgnl_pmt_id: get_in(t, ["OrgnlPmtId", "PrtryId"]),
      sts: get_in(t, ["ReqHdlg", "Sts", "Cd"]),
      rsn_prtry: get_in(stsrsn, ["Rsn", "Prtry"]),
      addtl_inf: stsrsn["AddtlInf"]
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
