defmodule PixSpiCatalog.Pain014 do
  @moduledoc """
  Representação de domínio do pain.014 (resposta a pain.013), versões 2.3
  e 2.4 coexistindo. Correlaciona com a instrução agendada por
  `OrgnlPmtInfId`/`OrgnlEndToEndId`.

  `docs/mensagens.md` (bacex) descreve um caso de fila (`queued`) pra
  esta mensagem, mas o schema real só define `TxSts` como `ACSP`/`RJCT`
  — vale corrigir o doc; não implementado aqui por não existir no schema.

  `InitgPty` (14 zeros) e `OrgnlGrpInfAndSts` (`OrgnlMsgId` com 32 zeros,
  `OrgnlMsgNmId` com 8 zeros) são valores fixos no perfil do BCB, não
  campos variáveis — a correlação de verdade acontece em
  `OrgnlPmtInfAndSts`, não no grupo.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pain014.{V2_3, V2_4}

  @type versao :: :v2_3 | :v2_4

  defstruct [
    :msg_id,
    :criado_em,
    :orgnl_pmt_inf_id,
    :orgnl_end_to_end_id,
    :tx_sts,
    :rsn_prtry,
    :dbtr_dcsn_dt_tm,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          orgnl_pmt_inf_id: String.t(),
          orgnl_end_to_end_id: String.t(),
          tx_sts: String.t(),
          rsn_prtry: String.t() | nil,
          dbtr_dcsn_dt_tm: DateTime.t(),
          cdtr_agt_ispb: String.t(),
          cdtr_cpf_cnpj: String.t()
        }

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :orgnl_pmt_inf_id,
    :orgnl_end_to_end_id,
    :tx_sts,
    :dbtr_dcsn_dt_tm,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj
  ]

  @modulo_por_versao %{v2_3: V2_3, v2_4: V2_4}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao)
      when versao in [:v2_3, :v2_4] do
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

  @doc "Parseia um XML de pain.014 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_pain014, modulo.msg_def_idr()}}
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
      "CdtrPmtActvtnReqStsRpt" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => formatar_data_hora(m.criado_em),
          "InitgPty" => %{
            "Id" => %{"OrgId" => %{"Othr" => %{"Id" => String.duplicate("0", 14)}}}
          }
        },
        "OrgnlGrpInfAndSts" => %{
          "OrgnlMsgId" => String.duplicate("0", 32),
          "OrgnlMsgNmId" => String.duplicate("0", 8)
        },
        "OrgnlPmtInfAndSts" => [
          %{
            "OrgnlPmtInfId" => m.orgnl_pmt_inf_id,
            "TxInfAndSts" =>
              %{
                "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
                "TxSts" => m.tx_sts,
                "DbtrDcsnDtTm" => formatar_data_hora(m.dbtr_dcsn_dt_tm),
                "OrgnlTxRef" => %{
                  "CdtrAgt" => agente_termo(m.cdtr_agt_ispb),
                  "Cdtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}}
                }
              }
              |> talvez_por(
                "StsRsnInf",
                if(m.rsn_prtry, do: %{"Rsn" => %{"Prtry" => m.rsn_prtry}})
              )
          }
        ]
      }
    }
  end

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "CdtrPmtActvtnReqStsRpt"])
    grp = doc["GrpHdr"]
    [orgnl] = doc["OrgnlPmtInfAndSts"]
    tx = orgnl["TxInfAndSts"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      orgnl_pmt_inf_id: orgnl["OrgnlPmtInfId"],
      orgnl_end_to_end_id: tx["OrgnlEndToEndId"],
      tx_sts: tx["TxSts"],
      rsn_prtry: get_in(tx, ["StsRsnInf", "Rsn", "Prtry"]),
      dbtr_dcsn_dt_tm: parse_data_hora(tx["DbtrDcsnDtTm"]),
      cdtr_agt_ispb: get_in(tx, ["OrgnlTxRef", "CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["OrgnlTxRef", "Cdtr", "Id", "PrvtId", "Othr", "Id"])
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
