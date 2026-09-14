defmodule Isox.Reda017 do
  @moduledoc """
  Relatório de dados de participante.

  Versão 1.2. Reflete o cadastro atual, não é resposta a um pedido
  específico.

  No perfil do SPI, o que ele carrega é o prazo de confirmação de
  encerramento: as 24 horas que o liquidante atual tem para confirmar o
  fim do relacionamento com um indireto para quem há novo pedido de
  registro em suspenso. É o outro lado do `"QUED"` da `Isox.Reda016`.

  `MktSpcfcAttr.Nm` tem valor único (`"PRAZOCONFI"`) e fica fixo.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Reda017.V1_2

  @type version :: :v1_2

  defstruct [:msg_id, :created_at, :ispb, :confirmation_deadline]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          ispb: String.t(),
          confirmation_deadline: DateTime.t()
        }

  @required_fields [:msg_id, :created_at, :ispb, :confirmation_deadline]

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
          "PtyRpt" => %{
            "MsgHdr" => %{
              "MsgId" => message.msg_id,
              "CreDtTm" => format_datetime(message.created_at)
            },
            "RptOrErr" => %{
              "PtyRpt" => %{
                "PtyId" => %{
                  "Id" => %{"Id" => %{"PrtryId" => %{"Id" => message.ispb, "Issr" => "BCB"}}}
                },
                "PtyOrErr" => %{
                  "SysPty" => %{
                    "MktSpcfcAttr" => %{
                      "Nm" => "PRAZOCONFI",
                      "Val" => format_datetime(message.confirmation_deadline)
                    }
                  }
                }
              }
            }
          }
        }
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Decodifica um XML de reda.017 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} ->
            doc = get_in(term, ["Document", "PtyRpt"])
            pty_rpt = get_in(doc, ["RptOrErr", "PtyRpt"])

            message = %__MODULE__{
              msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
              created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
              ispb: get_in(pty_rpt, ["PtyId", "Id", "Id", "PrtryId", "Id"]),
              confirmation_deadline:
                get_in(pty_rpt, ["PtyOrErr", "SysPty", "MktSpcfcAttr", "Val"])
                |> parse_datetime()
            }

            {:ok, message, version}

          :error ->
            {:error, {:not_reda017, module.msg_def_idr()}}
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

  defp format_datetime(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(text) do
    {:ok, dt, _offset} = DateTime.from_iso8601(text)
    dt
  end
end
