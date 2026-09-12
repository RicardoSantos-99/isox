defmodule PixSpiCatalog.Reda014 do
  @moduledoc """
  Representação de domínio do reda.014 (solicitação de cadastro de
  participante indireto sob um direto), versão 1.3.

  `Tp.Prtry` (enum de valor único `"IDRT"`) e `MktSpcfcAttr.Nm` (enum de
  valor único `"CNPJIDRT"`) ficam fixos — o schema real não modela outra
  opção pra esta mensagem.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Reda014.V1_3

  @type versao :: :v1_3

  defstruct [:msg_id, :criado_em, :ispb, :cnpj]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          ispb: String.t(),
          cnpj: String.t()
        }

  @campos_obrigatorios [:msg_id, :criado_em, :ispb, :cnpj]

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
          "PtyCreReq" => %{
            "MsgHdr" => %{
              "MsgId" => mensagem.msg_id,
              "CreDtTm" => formatar_data_hora(mensagem.criado_em)
            },
            "Pty" => %{
              "PtyId" => %{
                "Id" => %{"Id" => %{"PrtryId" => %{"Id" => mensagem.ispb, "Issr" => "BCB"}}}
              },
              "Tp" => %{"Prtry" => "IDRT"},
              "MktSpcfcAttr" => %{"Nm" => "CNPJIDRT", "Val" => mensagem.cnpj}
            }
          }
        }
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de reda.014 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} ->
            doc = get_in(termo, ["Document", "PtyCreReq"])
            pty = doc["Pty"]

            mensagem = %__MODULE__{
              msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
              criado_em: parse_data_hora(get_in(doc, ["MsgHdr", "CreDtTm"])),
              ispb: get_in(pty, ["PtyId", "Id", "Id", "PrtryId", "Id"]),
              cnpj: get_in(pty, ["MktSpcfcAttr", "Val"])
            }

            {:ok, mensagem, versao}

          :error ->
            {:error, {:nao_e_reda014, modulo.msg_def_idr()}}
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
