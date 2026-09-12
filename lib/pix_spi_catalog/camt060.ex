defmodule PixSpiCatalog.Camt060 do
  @moduledoc """
  Representação de domínio do camt.060 (requisição de relatório da Conta
  PI), versão 1.9 — `ReqdMsgNmId` é o campo despachante: decide se a
  resposta é camt.052, camt.053 ou camt.054.

  `RptgPrd` (período do relatório) é opcional como um todo; quando
  presente no schema real, exige `FrDt` + `FrTm`/`ToTm` juntos (e `Tp`
  fixo em `"ALLL"`, que não é campo do domínio). O domínio usa
  `rptg_prd_fr_dt` como sinal de presença do período inteiro.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt060.V1_9

  @type versao :: :v1_9

  defstruct [
    :msg_id,
    :criado_em,
    :reqd_msg_nm_id,
    :acct_ownr_ispb,
    :id,
    :rptg_prd_fr_dt,
    :rptg_prd_to_dt,
    :rptg_prd_fr_tm,
    :rptg_prd_to_tm,
    :reqd_bal_tp_prtry
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          reqd_msg_nm_id: String.t(),
          acct_ownr_ispb: String.t(),
          id: String.t() | nil,
          rptg_prd_fr_dt: Date.t() | nil,
          rptg_prd_to_dt: Date.t() | nil,
          rptg_prd_fr_tm: Time.t() | nil,
          rptg_prd_to_tm: Time.t() | nil,
          reqd_bal_tp_prtry: String.t() | nil
        }

  @campos_obrigatorios [:msg_id, :criado_em, :reqd_msg_nm_id, :acct_ownr_ispb]

  @modulo_por_versao %{v1_9: V1_9}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_9] do
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

  @doc "Parseia um XML de camt.060 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt060, modulo.msg_def_idr()}}
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
      "AcctRptgReq" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "RptgReq" =>
          %{
            "Id" => m.id,
            "ReqdMsgNmId" => m.reqd_msg_nm_id,
            "AcctOwnr" => %{
              "Agt" => %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => m.acct_ownr_ispb}}}
            }
          }
          |> talvez_por("RptgPrd", rptg_prd_termo(m))
          |> talvez_por(
            "ReqdBalTp",
            if(m.reqd_bal_tp_prtry, do: %{"CdOrPrtry" => %{"Prtry" => m.reqd_bal_tp_prtry}})
          )
      }
    }
  end

  defp rptg_prd_termo(%{rptg_prd_fr_dt: nil}), do: nil

  defp rptg_prd_termo(m) do
    %{
      "FrToDt" => %{
        "FrDt" => Date.to_iso8601(m.rptg_prd_fr_dt),
        "ToDt" => data_ou_nil(m.rptg_prd_to_dt)
      },
      "FrToTm" => %{
        "FrTm" => formatar_hora(m.rptg_prd_fr_tm),
        "ToTm" => formatar_hora(m.rptg_prd_to_tm)
      },
      "Tp" => "ALLL"
    }
  end

  defp data_ou_nil(nil), do: nil
  defp data_ou_nil(%Date{} = d), do: Date.to_iso8601(d)

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "AcctRptgReq"])
    req = doc["RptgReq"]
    rptg_prd = req["RptgPrd"] || %{}

    %__MODULE__{
      msg_id: get_in(doc, ["GrpHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["GrpHdr", "CreDtTm"])),
      reqd_msg_nm_id: req["ReqdMsgNmId"],
      acct_ownr_ispb: get_in(req, ["AcctOwnr", "Agt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      id: req["Id"],
      rptg_prd_fr_dt: rptg_prd |> get_in(["FrToDt", "FrDt"]) |> parse_data(),
      rptg_prd_to_dt: rptg_prd |> get_in(["FrToDt", "ToDt"]) |> parse_data(),
      rptg_prd_fr_tm: rptg_prd |> get_in(["FrToTm", "FrTm"]) |> parse_hora(),
      rptg_prd_to_tm: rptg_prd |> get_in(["FrToTm", "ToTm"]) |> parse_hora(),
      reqd_bal_tp_prtry: get_in(req, ["ReqdBalTp", "CdOrPrtry", "Prtry"])
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

  defp formatar_hora(nil), do: nil

  defp formatar_hora(%Time{} = t) do
    (t |> Map.put(:microsecond, {0, 6}) |> Time.truncate(:millisecond) |> Time.to_iso8601()) <>
      "Z"
  end

  defp parse_hora(nil), do: nil
  defp parse_hora(texto), do: texto |> String.trim_trailing("Z") |> Time.from_iso8601!()
end
