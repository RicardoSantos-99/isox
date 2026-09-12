defmodule PixSpiCatalog.Pain009 do
  @moduledoc """
  Representação de domínio do pain.009 (solicitação de autorização de
  recorrência / mandato), versão 1.1 — cria o estado de mandato pendente:
  `MndtId`, frequência, datas de vigência, valor.

  Modela `Mndt` como exatamente 1 por mensagem (mesma simplificação do
  `Pacs008`). `MndtPrcgDtls` é `max: ilimitado` de verdade (histórico de
  processamento), modelado como lista — schema exige ao menos 1.
  `Ocrncs.SeqTp` (enum de valor único `"RCUR"`) fica fixo.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pain009.V1_1

  @type versao :: :v1_1

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :criado_em,
    :mndt_id,
    :mndt_req_id,
    :frqcy_tp,
    :frst_colltn_dt,
    :fnl_colltn_dt,
    :trckg_ind,
    :colltn_amt,
    :adjstmnt_dt_ind,
    :adjstmnt_amt,
    :cdtr_nome,
    :cdtr_cpf_cnpj,
    :cdtr_agt_ispb,
    :dbtr_cpf_cnpj,
    :dbtr_conta_id,
    :dbtr_conta_issr,
    :dbtr_agt_ispb,
    :ultmt_dbtr_nome,
    :ultmt_dbtr_cpf_cnpj,
    :rfrd_doc_nb,
    :rfrd_doc_cdtr_ref,
    mndt_prcg_dtls: []
  ]

  @type prcg_dtls :: %{tp: String.t(), dt_tm: DateTime.t()}
  @type t :: %__MODULE__{}

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :mndt_id,
    :mndt_req_id,
    :frqcy_tp,
    :frst_colltn_dt,
    :trckg_ind,
    :cdtr_nome,
    :cdtr_cpf_cnpj,
    :cdtr_agt_ispb,
    :dbtr_cpf_cnpj,
    :dbtr_conta_id,
    :dbtr_agt_ispb,
    :rfrd_doc_nb
  ]

  @modulo_por_versao %{v1_1: V1_1}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_1] do
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

  @doc "Parseia um XML de pain.009 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_pain009, modulo.msg_def_idr()}}
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
      "MndtInitnReq" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "Mndt" => [termo_mandato(m)]
      }
    }
  end

  defp termo_mandato(m) do
    %{
      "MndtId" => m.mndt_id,
      "MndtReqId" => m.mndt_req_id,
      "Ocrncs" =>
        %{
          "SeqTp" => "RCUR",
          "Frqcy" => %{"Tp" => m.frqcy_tp},
          "FrstColltnDt" => Date.to_iso8601(m.frst_colltn_dt)
        }
        |> talvez_por("FnlColltnDt", if(m.fnl_colltn_dt, do: Date.to_iso8601(m.fnl_colltn_dt))),
      "TrckgInd" => to_string(m.trckg_ind),
      "Cdtr" => %{
        "Nm" => m.cdtr_nome,
        "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}
      },
      "CdtrAgt" => agente_termo(m.cdtr_agt_ispb),
      "Dbtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}},
      "DbtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.dbtr_conta_id, "Issr" => m.dbtr_conta_issr}}
      },
      "DbtrAgt" => agente_termo(m.dbtr_agt_ispb),
      "RfrdDoc" => %{"Nb" => m.rfrd_doc_nb, "CdtrRef" => m.rfrd_doc_cdtr_ref},
      "SplmtryData" => %{
        "Envlp" => %{"MndtPrcgDtls" => Enum.map(m.mndt_prcg_dtls, &termo_prcg/1)}
      }
    }
    |> talvez_por(
      "ColltnAmt",
      if(m.colltn_amt, do: %{valor: to_string(m.colltn_amt), atributos: %{"Ccy" => "BRL"}})
    )
    |> talvez_por("Adjstmnt", adjstmnt_termo(m))
    |> talvez_por("UltmtDbtr", ultmt_dbtr_termo(m))
  end

  defp termo_prcg(p), do: %{"MndtPrcgTp" => p.tp, "PrcgDtTm" => formatar_data_hora(p.dt_tm)}

  defp adjstmnt_termo(%{adjstmnt_amt: nil}), do: nil

  defp adjstmnt_termo(m) do
    %{
      "DtAdjstmntRuleInd" => to_string(m.adjstmnt_dt_ind),
      "Amt" => %{valor: to_string(m.adjstmnt_amt), atributos: %{"Ccy" => "BRL"}}
    }
  end

  defp ultmt_dbtr_termo(%{ultmt_dbtr_nome: nil}), do: nil

  defp ultmt_dbtr_termo(m) do
    %{
      "Nm" => m.ultmt_dbtr_nome,
      "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.ultmt_dbtr_cpf_cnpj}}}
    }
  end

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "MndtInitnReq"])
    grp = doc["GrpHdr"]
    [mndt] = doc["Mndt"]
    ocrncs = mndt["Ocrncs"]
    adjstmnt = mndt["Adjstmnt"] || %{}
    ultmt_dbtr = mndt["UltmtDbtr"] || %{}
    dbtr_acct = mndt["DbtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      mndt_id: mndt["MndtId"],
      mndt_req_id: mndt["MndtReqId"],
      frqcy_tp: get_in(ocrncs, ["Frqcy", "Tp"]),
      frst_colltn_dt: ocrncs["FrstColltnDt"] |> parse_data(),
      fnl_colltn_dt: ocrncs["FnlColltnDt"] |> parse_data(),
      trckg_ind: mndt["TrckgInd"],
      colltn_amt: get_in(mndt, ["ColltnAmt", :valor]),
      adjstmnt_dt_ind: adjstmnt["DtAdjstmntRuleInd"],
      adjstmnt_amt: get_in(adjstmnt, ["Amt", :valor]),
      cdtr_nome: get_in(mndt, ["Cdtr", "Nm"]),
      cdtr_cpf_cnpj: get_in(mndt, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_agt_ispb: get_in(mndt, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      dbtr_cpf_cnpj: get_in(mndt, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_conta_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_conta_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_agt_ispb: get_in(mndt, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      ultmt_dbtr_nome: ultmt_dbtr["Nm"],
      ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      rfrd_doc_nb: get_in(mndt, ["RfrdDoc", "Nb"]),
      rfrd_doc_cdtr_ref: get_in(mndt, ["RfrdDoc", "CdtrRef"]),
      mndt_prcg_dtls:
        mndt |> get_in(["SplmtryData", "Envlp", "MndtPrcgDtls"]) |> Enum.map(&prcg_de_termo/1)
    }
  end

  defp prcg_de_termo(t), do: %{tp: t["MndtPrcgTp"], dt_tm: parse_data_hora(t["PrcgDtTm"])}

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
