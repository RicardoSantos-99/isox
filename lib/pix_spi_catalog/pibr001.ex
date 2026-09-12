defmodule PixSpiCatalog.Pibr001 do
  @moduledoc """
  Representação de domínio do pibr.001 (echo request), versão 1.3 — ping:
  `Data` é um text livre (até 35 caracteres) que o pibr.002 de resposta
  ecoa em `OrgnlData`.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Generated.Pibr001.V1_3

  @type version :: :v1_3

  defstruct [:msg_id, :created_at, :data]

  @type t :: %__MODULE__{msg_id: String.t(), created_at: DateTime.t(), data: String.t()}

  @required_fields [:msg_id, :created_at, :data]

  @module_by_version %{v1_3: V1_3}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_3] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => %{
          "EchoReq" => %{
            "GrpHdr" => %{
              "MsgId" => message.msg_id,
              "CreDtTm" => format_datetime(message.created_at)
            },
            "EchoTxInf" => %{"Data" => message.data}
          }
        }
      }

      with {:ok, xml} <- module.build(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Parseia um XML de pibr.001 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), version()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registry.parse(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} ->
            doc = get_in(term, ["Document", "EchoReq"])

            message = %__MODULE__{
              msg_id: get_in(doc, ["GrpHdr", "MsgId"]),
              created_at: parse_datetime(get_in(doc, ["GrpHdr", "CreDtTm"])),
              data: get_in(doc, ["EchoTxInf", "Data"])
            }

            {:ok, message, version}

          :error ->
            {:error, {:not_pibr001, module.msg_def_idr()}}
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
