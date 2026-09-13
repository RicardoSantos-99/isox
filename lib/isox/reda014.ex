defmodule Isox.Reda014 do
  @moduledoc """
  Modelo ISO 20022 do reda.014 (solicitação de cadastro de
  participante indireto sob um direto), versão 1.3.

  `Tp.Prtry` (enum de valor único `"IDRT"`) e `MktSpcfcAttr.Nm` (enum de
  valor único `"CNPJIDRT"`) ficam fixos — o schema real não modela outra
  opção pra esta mensagem.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Reda014.V1_3

  @type version :: :v1_3

  defstruct [:msg_id, :created_at, :ispb, :cnpj]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          ispb: String.t(),
          cnpj: String.t()
        }

  @required_fields [:msg_id, :created_at, :ispb, :cnpj]

  @module_by_version %{v1_3: V1_3}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_3] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => %{
          "PtyCreReq" => %{
            "MsgHdr" => %{
              "MsgId" => message.msg_id,
              "CreDtTm" => format_datetime(message.created_at)
            },
            "Pty" => %{
              "PtyId" => %{
                "Id" => %{"Id" => %{"PrtryId" => %{"Id" => message.ispb, "Issr" => "BCB"}}}
              },
              "Tp" => %{"Prtry" => "IDRT"},
              "MktSpcfcAttr" => %{"Nm" => "CNPJIDRT", "Val" => message.cnpj}
            }
          }
        }
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Decodifica um XML de reda.014 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} ->
            doc = get_in(term, ["Document", "PtyCreReq"])
            pty = doc["Pty"]

            message = %__MODULE__{
              msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
              created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
              ispb: get_in(pty, ["PtyId", "Id", "Id", "PrtryId", "Id"]),
              cnpj: get_in(pty, ["MktSpcfcAttr", "Val"])
            }

            {:ok, message, version}

          :error ->
            {:error, {:not_reda014, module.msg_def_idr()}}
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
