defmodule PixSpiCatalog.Pacs002 do
  @moduledoc """
  Representação de domínio do pacs.002 (relatório de status de pagamento),
  versões 1.16 e 1.17 (ADR 0002) — a resposta a um pacs.008, referenciando
  a mensagem original por `OrgnlInstrId`/`OrgnlEndToEndId` e informando o
  status (`TxSts`) e, quando rejeitada, o motivo.

  Modela `TxInfAndSts` como exatamente 1 por mensagem (mesma simplificação
  do `Pacs008` para `CdtTrfTxInf`: o XSD permite lote, o Pix não usa) e
  `StsRsnInf` como no máximo 1 motivo, com sua lista de `AddtlInf`.

  Mesma validação em duas camadas do `Pacs008`: `build/3` confere os
  campos obrigatórios do domínio e depois reaproveita o `parse` do próprio
  módulo gerado pra validar pattern/enum/cardinalidade sem duplicar regra
  — inclusive o enum de `Rsn.Cd`, que diverge entre 1.16 e 1.17.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pacs002.{V1_16, V1_17}

  @type versao :: :v1_16 | :v1_17

  defstruct [
    :msg_id,
    :criado_em,
    :orgnl_instr_id,
    :orgnl_end_to_end_id,
    :tx_sts,
    :sts_rsn_cd,
    :fctv_intr_bk_sttlm_dt,
    :orgnl_intr_bk_sttlm_dt,
    sts_rsn_addtl_inf: []
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          orgnl_instr_id: String.t(),
          orgnl_end_to_end_id: String.t(),
          tx_sts: String.t(),
          sts_rsn_cd: String.t() | nil,
          sts_rsn_addtl_inf: [String.t()],
          fctv_intr_bk_sttlm_dt: DateTime.t() | nil,
          orgnl_intr_bk_sttlm_dt: Date.t() | nil
        }

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :orgnl_instr_id,
    :orgnl_end_to_end_id,
    :tx_sts
  ]

  @modulo_por_versao %{v1_16: V1_16, v1_17: V1_17}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao)
      when versao in [:v1_16, :v1_17] do
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

  @doc "Parseia um XML de pacs.002 (qualquer versão) de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_pacs002, modulo.msg_def_idr()}}
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
      "FIToFIPmtStsRpt" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "TxInfAndSts" => [termo_transacao(m)]
      }
    }
  end

  defp termo_transacao(m) do
    %{
      "OrgnlInstrId" => m.orgnl_instr_id,
      "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
      "TxSts" => m.tx_sts
    }
    |> talvez_por("StsRsnInf", sts_rsn_inf_lista(m))
    |> talvez_por("FctvIntrBkSttlmDt", fctv_intr_bk_sttlm_dt_termo(m.fctv_intr_bk_sttlm_dt))
    |> talvez_por("OrgnlTxRef", orgnl_tx_ref_termo(m.orgnl_intr_bk_sttlm_dt))
  end

  # `StsRsnInf` é `max: ilimitado` no schema (permite mais de um motivo); o
  # domínio modela no máximo 1, então a lista tem sempre 0 ou 1 item.
  defp sts_rsn_inf_lista(%{sts_rsn_cd: nil, sts_rsn_addtl_inf: []}), do: nil
  defp sts_rsn_inf_lista(m), do: [sts_rsn_inf_termo(m)]

  defp sts_rsn_inf_termo(m) do
    %{}
    |> talvez_por("Rsn", if(m.sts_rsn_cd, do: %{"Cd" => m.sts_rsn_cd}))
    |> talvez_por("AddtlInf", if(m.sts_rsn_addtl_inf != [], do: m.sts_rsn_addtl_inf))
  end

  defp fctv_intr_bk_sttlm_dt_termo(nil), do: nil
  defp fctv_intr_bk_sttlm_dt_termo(%DateTime{} = dt), do: %{"DtTm" => formatar_data_hora(dt)}

  defp orgnl_tx_ref_termo(nil), do: nil
  defp orgnl_tx_ref_termo(%Date{} = data), do: %{"IntrBkSttlmDt" => Date.to_iso8601(data)}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "FIToFIPmtStsRpt"])
    grp = doc["GrpHdr"]
    [tx] = doc["TxInfAndSts"]
    rsn_inf = tx |> Map.get("StsRsnInf", []) |> List.first(%{})

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      orgnl_instr_id: tx["OrgnlInstrId"],
      orgnl_end_to_end_id: tx["OrgnlEndToEndId"],
      tx_sts: tx["TxSts"],
      sts_rsn_cd: get_in(rsn_inf, ["Rsn", "Cd"]),
      sts_rsn_addtl_inf: Map.get(rsn_inf, "AddtlInf", []),
      fctv_intr_bk_sttlm_dt: parse_data_hora(get_in(tx, ["FctvIntrBkSttlmDt", "DtTm"])),
      orgnl_intr_bk_sttlm_dt: parse_data(get_in(tx, ["OrgnlTxRef", "IntrBkSttlmDt"]))
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

  defp parse_data(nil), do: nil
  defp parse_data(texto), do: Date.from_iso8601!(texto)
end
