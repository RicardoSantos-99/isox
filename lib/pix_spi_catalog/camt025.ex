defmodule PixSpiCatalog.Camt025 do
  @moduledoc """
  Representação de domínio do camt.025 (recibo, resposta a trck.002),
  versão 1.0 — até 500 confirmações por mensagem (`RctDtls` é
  `max: ilimitado` no schema real, modelado como lista de verdade).

  Cada confirmação correlaciona com um trck.002 por `OrgnlMsgId`/
  `OrgnlPmtId` e traz um status (aceite/rejeição), com motivo opcional.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt025.V1_0

  @type versao :: :v1_0

  defstruct [:msg_id, :criado_em, confirmacoes: []]

  @type confirmacao :: %{
          orgnl_msg_id: String.t(),
          orgnl_pmt_id: String.t(),
          sts: String.t(),
          rsn_prtry: String.t() | nil,
          addtl_inf: String.t() | nil
        }

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          confirmacoes: [confirmacao()]
        }

  @campos_obrigatorios [:msg_id, :criado_em]

  @modulo_por_versao %{v1_0: V1_0}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_0] do
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

  @doc "Parseia um XML de camt.025 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt025, modulo.msg_def_idr()}}
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
      "Rct" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "RctDtls" => Enum.map(m.confirmacoes, &termo_confirmacao/1)
      }
    }
  end

  defp termo_confirmacao(c) do
    %{
      "OrgnlMsgId" => %{"MsgId" => c.orgnl_msg_id},
      "OrgnlPmtId" => %{"PrtryId" => c.orgnl_pmt_id},
      "ReqHdlg" =>
        %{"Sts" => %{"Cd" => c.sts}}
        |> talvez_por("StsRsn", sts_rsn_termo(c))
    }
  end

  defp sts_rsn_termo(c) do
    rsn_prtry = Map.get(c, :rsn_prtry)
    addtl_inf = Map.get(c, :addtl_inf)

    if rsn_prtry == nil and addtl_inf == nil do
      nil
    else
      %{"AddtlInf" => addtl_inf} |> talvez_por("Rsn", if(rsn_prtry, do: %{"Prtry" => rsn_prtry}))
    end
  end

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "Rct"])

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["MsgHdr", "CreDtTm"])),
      confirmacoes: doc |> Map.get("RctDtls", []) |> Enum.map(&confirmacao_de_termo/1)
    }
  end

  defp confirmacao_de_termo(t) do
    stsrsn = t["ReqHdlg"]["StsRsn"] || %{}

    %{
      orgnl_msg_id: get_in(t, ["OrgnlMsgId", "MsgId"]),
      orgnl_pmt_id: get_in(t, ["OrgnlPmtId", "PrtryId"]),
      sts: get_in(t, ["ReqHdlg", "Sts", "Cd"]),
      rsn_prtry: get_in(stsrsn, ["Rsn", "Prtry"]),
      addtl_inf: stsrsn["AddtlInf"]
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
