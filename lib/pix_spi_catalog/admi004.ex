defmodule PixSpiCatalog.Admi004 do
  @moduledoc """
  Representação de domínio do admi.004 (evento de sistema, ex.: mudança de
  data contábil), versão 1.2 — notificação sem referência transacional.

  `EvtCd` tem um único valor possível no enum (`"SPI"`) — não é modelado
  como campo, fica fixo (mesmo tratamento de `SttlmMtd`/`ChrgBr` no
  `Pacs008`).
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Admi004.V1_2

  @type versao :: :v1_2

  defstruct [:desc]

  @type t :: %__MODULE__{desc: String.t()}

  @modulo_por_versao %{v1_2: V1_2}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_2] do
    with :ok <- validar_obrigatorios(mensagem) do
      modulo = Map.fetch!(@modulo_por_versao, versao)

      termo = %{
        "AppHdr" => AppHdr.termo(cabecalho, modulo.msg_def_idr()),
        "Document" => %{
          "SysEvtNtfctn" => %{"EvtInf" => %{"EvtCd" => "SPI", "EvtDesc" => mensagem.desc}}
        }
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de admi.004 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} ->
            desc = get_in(termo, ["Document", "SysEvtNtfctn", "EvtInf", "EvtDesc"])
            {:ok, %__MODULE__{desc: desc}, versao}

          :error ->
            {:error, {:nao_e_admi004, modulo.msg_def_idr()}}
        end

      erro ->
        erro
    end
  end

  defp confirmar(modulo, xml) do
    case modulo.parse(xml) do
      {:ok, _termo} -> {:ok, xml}
      {:error, motivo} -> {:error, motivo}
    end
  end

  defp validar_obrigatorios(%{desc: desc}) when desc in [nil, ""],
    do: {:error, "campos obrigatórios ausentes: [:desc]"}

  defp validar_obrigatorios(_mensagem), do: :ok
end
