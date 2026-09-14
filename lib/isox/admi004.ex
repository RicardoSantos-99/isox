defmodule Isox.Admi004 do
  @moduledoc """
  Evento de sistema: o aviso que o SPI manda a todos os participantes, sem
  relação com transação nenhuma.

  Versão 1.2. O caso mais comum é a mudança da data contábil.

  O código do evento (`EvtCd`) tem um único valor possível no enum
  (`"SPI"`), então fica fixo e não vira campo, mesmo tratamento dado a
  `SttlmMtd` e `ChrgBr` na `Isox.Pacs008`.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Admi004.V1_2

  @type version :: :v1_2

  defstruct [:description]

  @type t :: %__MODULE__{description: String.t()}

  @module_by_version %{v1_2: V1_2}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_2] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => %{
          "SysEvtNtfctn" => %{"EvtInf" => %{"EvtCd" => "SPI", "EvtDesc" => message.description}}
        }
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Decodifica um XML de admi.004 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} ->
            description = get_in(term, ["Document", "SysEvtNtfctn", "EvtInf", "EvtDesc"])
            {:ok, %__MODULE__{description: description}, version}

          :error ->
            {:error, {:not_admi004, module.msg_def_idr()}}
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

  defp validate_required(%{description: description}) when description in [nil, ""],
    do: {:error, "campos obrigatórios ausentes: [:description]"}

  defp validate_required(_message), do: :ok
end
