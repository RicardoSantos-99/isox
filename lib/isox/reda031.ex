defmodule Isox.Reda031 do
  @moduledoc """
  Pedido de encerramento do serviço de liquidação para um participante
  indireto.

  Versão 1.2. A resposta é uma `Isox.Reda016`.

  Aqui `ispb` é o do participante indireto para quem o serviço vai acabar,
  o contrário da `Isox.Reda014`, onde o ISPB é o de quem pede.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Reda031.V1_2

  @type version :: :v1_2

  defstruct [:msg_id, :created_at, :ispb]

  @type t :: %__MODULE__{msg_id: String.t(), created_at: DateTime.t(), ispb: String.t()}

  @required_fields [:msg_id, :created_at, :ispb]

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
          "PtyDeltnReq" => %{
            "MsgHdr" => %{
              "MsgId" => message.msg_id,
              "CreDtTm" => format_datetime(message.created_at)
            },
            "SysPtyId" => %{
              "Id" => %{"Id" => %{"PrtryId" => %{"Id" => message.ispb, "Issr" => "BCB"}}}
            }
          }
        }
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Decodifica um XML de reda.031 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} ->
            doc = get_in(term, ["Document", "PtyDeltnReq"])

            message = %__MODULE__{
              msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
              created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
              ispb: get_in(doc, ["SysPtyId", "Id", "Id", "PrtryId", "Id"])
            }

            {:ok, message, version}

          :error ->
            {:error, {:not_reda031, module.msg_def_idr()}}
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
