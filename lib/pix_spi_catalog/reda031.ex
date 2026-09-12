defmodule PixSpiCatalog.Reda031 do
  @moduledoc """
  Representação de domínio do reda.031 (solicitação de exclusão de
  cadastro de participante), versão 1.2 — referencia o ISPB do
  participante a excluir.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Reda031.V1_2

  @type versao :: :v1_2

  defstruct [:msg_id, :criado_em, :ispb]

  @type t :: %__MODULE__{msg_id: String.t(), criado_em: DateTime.t(), ispb: String.t()}

  @campos_obrigatorios [:msg_id, :criado_em, :ispb]

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
          "PtyDeltnReq" => %{
            "MsgHdr" => %{
              "MsgId" => mensagem.msg_id,
              "CreDtTm" => formatar_data_hora(mensagem.criado_em)
            },
            "SysPtyId" => %{
              "Id" => %{"Id" => %{"PrtryId" => %{"Id" => mensagem.ispb, "Issr" => "BCB"}}}
            }
          }
        }
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de reda.031 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} ->
            doc = get_in(termo, ["Document", "PtyDeltnReq"])

            mensagem = %__MODULE__{
              msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
              criado_em: parse_data_hora(get_in(doc, ["MsgHdr", "CreDtTm"])),
              ispb: get_in(doc, ["SysPtyId", "Id", "Id", "PrtryId", "Id"])
            }

            {:ok, mensagem, versao}

          :error ->
            {:error, {:nao_e_reda031, modulo.msg_def_idr()}}
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

  defp validar_obrigatorios(mensagem) do
    faltando = Enum.filter(@campos_obrigatorios, &(Map.get(mensagem, &1) in [nil, ""]))

    if faltando == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(faltando)}"}
  end

  defp formatar_data_hora(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_data_hora(nil), do: nil

  defp parse_data_hora(texto) do
    {:ok, dt, _offset} = DateTime.from_iso8601(texto)
    dt
  end
end
