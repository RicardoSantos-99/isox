defmodule PixSpiCatalog.Pain012 do
  @moduledoc """
  Representação de domínio do pain.012 (resposta a pain.009/pain.011 —
  aceite ou rejeição de mandato), versões 1.3 e 1.4 coexistindo.

  Modela `UndrlygAccptncDtls` como exatamente 1 (mesma simplificação dos
  outros). O mandato original aqui difere do `Pain009`/`Pain011`: tem
  `Dbtr.PstlAdr.TwnNm` (endereço, opcional) e `MndtRef` (opcional) que os
  outros dois não têm, e não tem `Adjstmnt` — conferido contra o schema
  real de cada mensagem, não assumido por semelhança.

  `MndtPrcgDtls` é `opcional (lista)` aqui (diferente do `Pain009`, onde
  é obrigatório com mínimo de 3) — `SplmtryData` ganha ainda `MndtSts`.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pain012.{V1_3, V1_4}

  @type versao :: :v1_3 | :v1_4

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :criado_em,
    :instg_agt_ispb,
    :accptd,
    :rjct_rsn_prtry,
    :orgnl_mndt_id,
    :orgnl_mndt_req_id,
    :orgnl_frqcy_tp,
    :orgnl_frst_colltn_dt,
    :orgnl_fnl_colltn_dt,
    :orgnl_trckg_ind,
    :orgnl_colltn_amt,
    :orgnl_cdtr_nome,
    :orgnl_cdtr_cpf_cnpj,
    :orgnl_cdtr_agt_ispb,
    :orgnl_dbtr_twn_nm,
    :orgnl_dbtr_cpf_cnpj,
    :orgnl_dbtr_conta_id,
    :orgnl_dbtr_conta_issr,
    :orgnl_dbtr_agt_ispb,
    :orgnl_ultmt_dbtr_nome,
    :orgnl_ultmt_dbtr_cpf_cnpj,
    :orgnl_mndt_ref,
    :orgnl_rfrd_doc_nb,
    :orgnl_rfrd_doc_cdtr_ref,
    :mndt_sts,
    mndt_prcg_dtls: []
  ]

  @type t :: %__MODULE__{}

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :instg_agt_ispb,
    :accptd,
    :orgnl_mndt_id,
    :orgnl_mndt_req_id,
    :orgnl_frqcy_tp,
    :orgnl_frst_colltn_dt,
    :orgnl_trckg_ind,
    :orgnl_cdtr_nome,
    :orgnl_cdtr_cpf_cnpj,
    :orgnl_cdtr_agt_ispb,
    :orgnl_dbtr_cpf_cnpj,
    :orgnl_dbtr_conta_id,
    :orgnl_dbtr_agt_ispb,
    :orgnl_rfrd_doc_nb
  ]

  @modulo_por_versao %{v1_3: V1_3, v1_4: V1_4}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao)
      when versao in [:v1_3, :v1_4] do
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

  @doc "Parseia um XML de pain.012 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_pain012, modulo.msg_def_idr()}}
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
      "MndtAccptncRpt" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => formatar_data_hora(m.criado_em),
          "InstgAgt" => agente_termo(m.instg_agt_ispb)
        },
        "UndrlygAccptncDtls" => [termo_detalhe(m)]
      }
    }
  end

  defp termo_detalhe(m) do
    %{
      "AccptncRslt" =>
        %{"Accptd" => to_string(m.accptd)}
        |> talvez_por("RjctRsn", if(m.rjct_rsn_prtry, do: %{"Prtry" => m.rjct_rsn_prtry})),
      "OrgnlMndt" => %{"OrgnlMndt" => termo_mandato_original(m)}
    }
    |> talvez_por("SplmtryData", splmtry_termo(m))
  end

  defp termo_mandato_original(m) do
    %{
      "MndtId" => m.orgnl_mndt_id,
      "MndtReqId" => m.orgnl_mndt_req_id,
      "Ocrncs" =>
        %{
          "SeqTp" => "RCUR",
          "Frqcy" => %{"Tp" => m.orgnl_frqcy_tp},
          "FrstColltnDt" => Date.to_iso8601(m.orgnl_frst_colltn_dt)
        }
        |> talvez_por(
          "FnlColltnDt",
          if(m.orgnl_fnl_colltn_dt, do: Date.to_iso8601(m.orgnl_fnl_colltn_dt))
        ),
      "TrckgInd" => to_string(m.orgnl_trckg_ind),
      "Cdtr" => %{
        "Nm" => m.orgnl_cdtr_nome,
        "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_cdtr_cpf_cnpj}}}
      },
      "CdtrAgt" => agente_termo(m.orgnl_cdtr_agt_ispb),
      "Dbtr" =>
        %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_dbtr_cpf_cnpj}}}}
        |> talvez_por("PstlAdr", if(m.orgnl_dbtr_twn_nm, do: %{"TwnNm" => m.orgnl_dbtr_twn_nm})),
      "DbtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.orgnl_dbtr_conta_id, "Issr" => m.orgnl_dbtr_conta_issr}}
      },
      "DbtrAgt" => agente_termo(m.orgnl_dbtr_agt_ispb),
      "RfrdDoc" => %{"Nb" => m.orgnl_rfrd_doc_nb, "CdtrRef" => m.orgnl_rfrd_doc_cdtr_ref}
    }
    |> talvez_por(
      "ColltnAmt",
      if(m.orgnl_colltn_amt,
        do: %{valor: to_string(m.orgnl_colltn_amt), atributos: %{"Ccy" => "BRL"}}
      )
    )
    |> talvez_por("UltmtDbtr", ultmt_dbtr_termo(m))
    |> talvez_por("MndtRef", m.orgnl_mndt_ref)
  end

  defp ultmt_dbtr_termo(%{orgnl_ultmt_dbtr_nome: nil}), do: nil

  defp ultmt_dbtr_termo(m) do
    %{
      "Nm" => m.orgnl_ultmt_dbtr_nome,
      "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_ultmt_dbtr_cpf_cnpj}}}
    }
  end

  defp splmtry_termo(%{mndt_prcg_dtls: [], mndt_sts: nil}), do: nil

  defp splmtry_termo(m) do
    %{}
    |> talvez_por(
      "MndtPrcgDtls",
      if(m.mndt_prcg_dtls != [], do: Enum.map(m.mndt_prcg_dtls, &termo_prcg/1))
    )
    |> talvez_por("MndtSts", m.mndt_sts)
    |> then(&%{"Envlp" => &1})
  end

  defp termo_prcg(p), do: %{"MndtPrcgTp" => p.tp, "PrcgDtTm" => formatar_data_hora(p.dt_tm)}

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "MndtAccptncRpt"])
    grp = doc["GrpHdr"]
    [detalhe] = doc["UndrlygAccptncDtls"]
    mndt = get_in(detalhe, ["OrgnlMndt", "OrgnlMndt"])
    ocrncs = mndt["Ocrncs"]
    ultmt_dbtr = mndt["UltmtDbtr"] || %{}
    dbtr_acct = mndt["DbtrAcct"]
    envlp = get_in(detalhe, ["SplmtryData", "Envlp"]) || %{}

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      instg_agt_ispb: get_in(grp, ["InstgAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      accptd: get_in(detalhe, ["AccptncRslt", "Accptd"]),
      rjct_rsn_prtry: get_in(detalhe, ["AccptncRslt", "RjctRsn", "Prtry"]),
      orgnl_mndt_id: mndt["MndtId"],
      orgnl_mndt_req_id: mndt["MndtReqId"],
      orgnl_frqcy_tp: get_in(ocrncs, ["Frqcy", "Tp"]),
      orgnl_frst_colltn_dt: ocrncs["FrstColltnDt"] |> parse_data(),
      orgnl_fnl_colltn_dt: ocrncs["FnlColltnDt"] |> parse_data(),
      orgnl_trckg_ind: mndt["TrckgInd"],
      orgnl_colltn_amt: get_in(mndt, ["ColltnAmt", :valor]),
      orgnl_cdtr_nome: get_in(mndt, ["Cdtr", "Nm"]),
      orgnl_cdtr_cpf_cnpj: get_in(mndt, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      orgnl_cdtr_agt_ispb: get_in(mndt, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_dbtr_twn_nm: get_in(mndt, ["Dbtr", "PstlAdr", "TwnNm"]),
      orgnl_dbtr_cpf_cnpj: get_in(mndt, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      orgnl_dbtr_conta_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      orgnl_dbtr_conta_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      orgnl_dbtr_agt_ispb: get_in(mndt, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_ultmt_dbtr_nome: ultmt_dbtr["Nm"],
      orgnl_ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      orgnl_mndt_ref: mndt["MndtRef"],
      orgnl_rfrd_doc_nb: get_in(mndt, ["RfrdDoc", "Nb"]),
      orgnl_rfrd_doc_cdtr_ref: get_in(mndt, ["RfrdDoc", "CdtrRef"]),
      mndt_sts: envlp["MndtSts"],
      mndt_prcg_dtls: envlp |> Map.get("MndtPrcgDtls", []) |> Enum.map(&prcg_de_termo/1)
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
