defmodule PixSpiCatalog.Admi004 do
  @moduledoc """
  Representação de domínio do admi.004 (evento de sistema, ex.: mudança de
  data contábil), versão 1.2 — notificação sem referência transacional.

  `EvtCd` tem um único valor possível no enum (`"SPI"`) — não é modelado
  como campo, fica fixo (mesmo tratamento de `SttlmMtd`/`ChrgBr` no
  `Pacs008`).
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Generated.Admi004.V1_2

  @type version :: :v1_2

  defstruct [:description]

  @type t :: %__MODULE__{description: String.t()}

  @module_by_version %{v1_2: V1_2}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_2] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => %{
          "SysEvtNtfctn" => %{"EvtInf" => %{"EvtCd" => "SPI", "EvtDesc" => message.description}}
        }
      }

      with {:ok, xml} <- module.build(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Parseia um XML de admi.004 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), version()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registry.parse(xml) do
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
    case module.parse(xml) do
      {:ok, _term} -> {:ok, xml}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_required(%{description: description}) when description in [nil, ""],
    do: {:error, "campos obrigatórios ausentes: [:description]"}

  defp validate_required(_message), do: :ok
end
