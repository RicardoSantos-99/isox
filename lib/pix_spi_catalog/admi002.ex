defmodule PixSpiCatalog.Admi002 do
  @moduledoc """
  Representação de domínio do admi.002 (recusa de mensagem) — resposta de
  erro da ICOM referenciando a mensagem recusada por `RltdRef/Ref`, que é
  o `PI-ResourceId` devolvido no ingresso daquela mensagem (Manual VIII).

  Só existe uma versão no catálogo (1.5) — sem divergência a testar, mas
  `build/3` mantém o parâmetro de versão pela mesma razão do ADR 0002:
  a unidade de versionamento é `{mensagem, versão}`, não "o catálogo".

  Mesma validação em duas camadas dos outros dois: `build/3` confere
  obrigatoriedade do domínio e reaproveita o `parse` do módulo gerado
  pra pattern/enum/tamanho, sem duplicar regra.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Generated.Admi002.V1_5

  @type version :: :v1_5

  defstruct [:ref, :rjctg_pty_rsn, :rjctn_dt_tm, :err_lctn, :rsn_desc, :addtl_data]

  @type t :: %__MODULE__{
          ref: String.t(),
          rjctg_pty_rsn: String.t(),
          rjctn_dt_tm: DateTime.t() | nil,
          err_lctn: String.t() | nil,
          rsn_desc: String.t() | nil,
          addtl_data: String.t() | nil
        }

  @required_fields [:ref, :rjctg_pty_rsn]

  @module_by_version %{v1_5: V1_5}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_5] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(message)
      }

      with {:ok, xml} <- module.build(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Parseia um XML de admi.002 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), version()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registry.parse(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_admi002, module.msg_def_idr()}}
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

  defp document_term(m) do
    %{
      "admi.002.001.01" => %{
        "RltdRef" => %{"Ref" => m.ref},
        "Rsn" => %{
          "RjctgPtyRsn" => m.rjctg_pty_rsn,
          "RjctnDtTm" => format_datetime(m.rjctn_dt_tm),
          "ErrLctn" => m.err_lctn,
          "RsnDesc" => m.rsn_desc,
          "AddtlData" => m.addtl_data
        }
      }
    }
  end

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "admi.002.001.01"])
    rsn = doc["Rsn"]

    %__MODULE__{
      ref: get_in(doc, ["RltdRef", "Ref"]),
      rjctg_pty_rsn: rsn["RjctgPtyRsn"],
      rjctn_dt_tm: parse_datetime(rsn["RjctnDtTm"]),
      err_lctn: rsn["ErrLctn"],
      rsn_desc: rsn["RsnDesc"],
      addtl_data: rsn["AddtlData"]
    }
  end

  defp format_datetime(nil), do: nil

  defp format_datetime(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(text) do
    {:ok, dt, _offset} = DateTime.from_iso8601(text)
    dt
  end
end
