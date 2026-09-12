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
  alias PixSpiCatalog.Gerado.Admi002.V1_5

  @type versao :: :v1_5

  defstruct [:ref, :rjctg_pty_rsn, :rjctn_dt_tm, :err_lctn, :rsn_desc, :addtl_data]

  @type t :: %__MODULE__{
          ref: String.t(),
          rjctg_pty_rsn: String.t(),
          rjctn_dt_tm: DateTime.t() | nil,
          err_lctn: String.t() | nil,
          rsn_desc: String.t() | nil,
          addtl_data: String.t() | nil
        }

  @campos_obrigatorios [:ref, :rjctg_pty_rsn]

  @modulo_por_versao %{v1_5: V1_5}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_5] do
    with :ok <- validar_obrigatorios(mensagem) do
      modulo = Map.fetch!(@modulo_por_versao, versao)

      termo = %{
        "AppHdr" => AppHdr.termo(cabecalho, modulo.msg_def_idr()),
        "Document" => termo_document(mensagem)
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de admi.002 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_admi002, modulo.msg_def_idr()}}
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

  defp termo_document(m) do
    %{
      "admi.002.001.01" => %{
        "RltdRef" => %{"Ref" => m.ref},
        "Rsn" => %{
          "RjctgPtyRsn" => m.rjctg_pty_rsn,
          "RjctnDtTm" => formatar_data_hora(m.rjctn_dt_tm),
          "ErrLctn" => m.err_lctn,
          "RsnDesc" => m.rsn_desc,
          "AddtlData" => m.addtl_data
        }
      }
    }
  end

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "admi.002.001.01"])
    rsn = doc["Rsn"]

    %__MODULE__{
      ref: get_in(doc, ["RltdRef", "Ref"]),
      rjctg_pty_rsn: rsn["RjctgPtyRsn"],
      rjctn_dt_tm: parse_data_hora(rsn["RjctnDtTm"]),
      err_lctn: rsn["ErrLctn"],
      rsn_desc: rsn["RsnDesc"],
      addtl_data: rsn["AddtlData"]
    }
  end

  defp formatar_data_hora(nil), do: nil

  defp formatar_data_hora(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_data_hora(nil), do: nil

  defp parse_data_hora(texto) do
    {:ok, dt, _offset} = DateTime.from_iso8601(texto)
    dt
  end
end
