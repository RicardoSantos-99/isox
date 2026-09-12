defmodule PixSpiCatalog.Camt052 do
  @moduledoc """
  Representação de domínio do camt.052 (relação de lançamentos da Conta
  PI, resposta a camt.060), versão 1.3.

  `Rpt` é `max: ilimitado` no schema, mas como `camt.060` sempre pede o
  relatório de **uma** conta por vez, modela exatamente 1 (mesma
  simplificação do `Pacs008` para `CdtTrfTxInf`).

  Este perfil do BCB é resumido: só conta de lançamentos
  (`NbOfNtries`) e texto livre (`AddtlRptInf`) — o detalhamento por
  lançamento é o camt.054, não este.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt052.V1_3

  @type versao :: :v1_3

  defstruct [:msg_id, :criado_em, :rpt_id, :acct_ispb, :nb_of_ntries, :addtl_rpt_inf]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          rpt_id: String.t(),
          acct_ispb: String.t(),
          nb_of_ntries: String.t() | non_neg_integer(),
          addtl_rpt_inf: String.t()
        }

  @campos_obrigatorios [:msg_id, :criado_em, :rpt_id, :acct_ispb, :nb_of_ntries, :addtl_rpt_inf]

  @modulo_por_versao %{v1_3: V1_3}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_3] do
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

  @doc "Parseia um XML de camt.052 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt052, modulo.msg_def_idr()}}
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
      "BkToCstmrAcctRpt" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "Rpt" => [
          %{
            "Id" => m.rpt_id,
            "Acct" => %{"Id" => %{"Othr" => %{"Id" => m.acct_ispb}}},
            "TxsSummry" => %{"TtlNtries" => %{"NbOfNtries" => to_string(m.nb_of_ntries)}},
            "AddtlRptInf" => m.addtl_rpt_inf
          }
        ]
      }
    }
  end

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "BkToCstmrAcctRpt"])
    [rpt] = doc["Rpt"]

    %__MODULE__{
      msg_id: get_in(doc, ["GrpHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["GrpHdr", "CreDtTm"])),
      rpt_id: rpt["Id"],
      acct_ispb: get_in(rpt, ["Acct", "Id", "Othr", "Id"]),
      nb_of_ntries: get_in(rpt, ["TxsSummry", "TtlNtries", "NbOfNtries"]),
      addtl_rpt_inf: rpt["AddtlRptInf"]
    }
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
