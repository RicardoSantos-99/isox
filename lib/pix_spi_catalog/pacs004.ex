defmodule PixSpiCatalog.Pacs004 do
  @moduledoc """
  Representação de domínio do pacs.004 (devolução), versão 1.5 — a ordem
  de devolução de uma pacs.008 já liquidada, referenciando a original por
  `OrgnlEndToEndId`.

  Modela `TxInf` como exatamente 1 por mensagem (mesma simplificação do
  `Pacs008`/`Pacs002` para os elementos de transação em lista).

  Mesma validação em duas camadas dos outros: `build/3` confere
  obrigatoriedade do domínio e reaproveita o `parse` do próprio módulo
  gerado pra pattern/enum/cardinalidade, sem duplicar regra.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pacs004.V1_5

  @type versao :: :v1_5

  defstruct [
    :msg_id,
    :criado_em,
    :rtr_id,
    :orgnl_end_to_end_id,
    :valor,
    :rtr_rsn_cd,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    sttlm_prty: "NORM",
    rtr_rsn_addtl_inf: nil,
    rmt_inf_ustrd: nil
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          rtr_id: String.t(),
          orgnl_end_to_end_id: String.t(),
          valor: String.t() | number(),
          sttlm_prty: String.t(),
          rtr_rsn_cd: String.t(),
          rtr_rsn_addtl_inf: String.t() | nil,
          dbtr_agt_ispb: String.t(),
          cdtr_agt_ispb: String.t(),
          rmt_inf_ustrd: String.t() | nil
        }

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :rtr_id,
    :orgnl_end_to_end_id,
    :valor,
    :sttlm_prty,
    :rtr_rsn_cd,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb
  ]

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

  @doc "Parseia um XML de pacs.004 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_pacs004, modulo.msg_def_idr()}}
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
      "PmtRtr" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => formatar_data_hora(m.criado_em),
          "NbOfTxs" => "1",
          "SttlmInf" => %{"SttlmMtd" => "CLRG"}
        },
        "TxInf" => [termo_transacao(m)]
      }
    }
  end

  defp termo_transacao(m) do
    %{
      "RtrId" => m.rtr_id,
      "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
      "RtrdIntrBkSttlmAmt" => %{valor: to_string(m.valor), atributos: %{"Ccy" => "BRL"}},
      "SttlmPrty" => m.sttlm_prty,
      "ChrgBr" => "SLEV",
      "RtrRsnInf" => %{"Rsn" => %{"Cd" => m.rtr_rsn_cd}, "AddtlInf" => m.rtr_rsn_addtl_inf},
      "OrgnlTxRef" =>
        %{
          "DbtrAgt" => agente_termo(m.dbtr_agt_ispb),
          "CdtrAgt" => agente_termo(m.cdtr_agt_ispb)
        }
        |> talvez_por("RmtInf", rmt_inf_termo(m.rmt_inf_ustrd))
    }
  end

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp rmt_inf_termo(nil), do: nil
  defp rmt_inf_termo(texto), do: %{"Ustrd" => texto}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "PmtRtr"])
    grp = doc["GrpHdr"]
    [tx] = doc["TxInf"]
    rsn_inf = tx["RtrRsnInf"]
    orgnl_ref = tx["OrgnlTxRef"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      rtr_id: tx["RtrId"],
      orgnl_end_to_end_id: tx["OrgnlEndToEndId"],
      valor: get_in(tx, ["RtrdIntrBkSttlmAmt", :valor]),
      sttlm_prty: tx["SttlmPrty"],
      rtr_rsn_cd: get_in(rsn_inf, ["Rsn", "Cd"]),
      rtr_rsn_addtl_inf: rsn_inf["AddtlInf"],
      dbtr_agt_ispb: get_in(orgnl_ref, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(orgnl_ref, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      rmt_inf_ustrd: get_in(orgnl_ref, ["RmtInf", "Ustrd"])
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
