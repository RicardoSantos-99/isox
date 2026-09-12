defmodule PixSpiCatalog.Pibr001 do
  @moduledoc """
  Representação de domínio do pibr.001 (echo request), versão 1.3 — ping:
  `Data` é um texto livre (até 35 caracteres) que o pibr.002 de resposta
  ecoa em `OrgnlData`.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pibr001.V1_3

  @type versao :: :v1_3

  defstruct [:msg_id, :criado_em, :data]

  @type t :: %__MODULE__{msg_id: String.t(), criado_em: DateTime.t(), data: String.t()}

  @campos_obrigatorios [:msg_id, :criado_em, :data]

  @modulo_por_versao %{v1_3: V1_3}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_3] do
    with :ok <- validar_obrigatorios(mensagem) do
      modulo = Map.fetch!(@modulo_por_versao, versao)

      termo = %{
        "AppHdr" => AppHdr.termo(cabecalho, modulo.msg_def_idr()),
        "Document" => %{
          "EchoReq" => %{
            "GrpHdr" => %{
              "MsgId" => mensagem.msg_id,
              "CreDtTm" => formatar_data_hora(mensagem.criado_em)
            },
            "EchoTxInf" => %{"Data" => mensagem.data}
          }
        }
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de pibr.001 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} ->
            doc = get_in(termo, ["Document", "EchoReq"])

            mensagem = %__MODULE__{
              msg_id: get_in(doc, ["GrpHdr", "MsgId"]),
              criado_em: parse_data_hora(get_in(doc, ["GrpHdr", "CreDtTm"])),
              data: get_in(doc, ["EchoTxInf", "Data"])
            }

            {:ok, mensagem, versao}

          :error ->
            {:error, {:nao_e_pibr001, modulo.msg_def_idr()}}
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
