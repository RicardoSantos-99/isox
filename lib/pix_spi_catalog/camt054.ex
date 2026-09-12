defmodule PixSpiCatalog.Camt054 do
  @moduledoc """
  Representação de domínio do camt.054 (detalhamento de um lançamento da
  Conta PI — a contrapartida contábil de cada pacs.008/002 liquidada),
  versões 1.15 e 1.16 coexistindo. A maior mensagem do catálogo.

  `Ntfctn` é `max: ilimitado`, simplificado pra exatamente 1 (um
  lançamento por notificação, como o próprio mensagens.md descreve: "um
  por liquidação" — mesma razão do `Pacs008` pra `CdtTrfTxInf`). `Ntry`
  já é `max: 1` no schema real.

  Cobre o caminho comum de um lançamento de liquidação (mesmos dados de
  pagador/recebedor do `Pacs008`, mais metadados contábeis e, quando é
  devolução, `RtrInf`). Ficam de fora, mesma razão do `Pacs008`: `Tax` e
  `RmtInf.Strd` — ramos raros, disponíveis via codec genérico.

  `RltdAgts` é obrigatório como contêiner, mas `DbtrAgt`/`CdtrAgt` dentro
  dele são cada um independentemente opcional (diferente do `Pacs008`,
  onde os dois agentes são sempre obrigatórios) — confirmado contra o
  schema real, não assumido do padrão anterior.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt054.{V1_15, V1_16}

  @type versao :: :v1_15 | :v1_16

  # a maior mensagem do catálogo de verdade tem mais de 31 campos; achatar
  # em sub-structs quebraria a simetria com o resto do domínio (Pacs008 e
  # companhia), sem ganho real — o VM ainda lida bem com 1 struct desse
  # tamanho isolado.
  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :criado_em,
    :ntfctn_id,
    :acct_ispb,
    :valor,
    :cdt_dbt_ind,
    :sts_cd,
    :bktxcd_domn_cd,
    :bktxcd_fmly_cd,
    :bktxcd_sub_fmly_cd,
    :msg_nm_id,
    :end_to_end_id,
    :bookg_dt,
    :val_dt,
    :instr_id,
    :tx_id,
    :clr_sys_ref,
    :prtry_ref,
    :initg_pty_id,
    :dbtr_nome,
    :dbtr_cpf_cnpj,
    :dbtr_conta_id,
    :dbtr_conta_issr,
    :dbtr_conta_tipo,
    :cdtr_cpf_cnpj,
    :cdtr_conta_id,
    :cdtr_conta_issr,
    :cdtr_conta_tipo,
    :cdtr_conta_chave,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    :lcl_instrm,
    :purp_cd,
    :info_pagamento,
    :accptnc_dt_tm,
    :rtr_rsn_cd,
    :rtr_rsn_addtl_inf,
    :addtl_tx_inf,
    :addtl_ntry_inf,
    :addtl_ntfctn_inf
  ]

  @type t :: %__MODULE__{}

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :ntfctn_id,
    :acct_ispb,
    :valor,
    :cdt_dbt_ind,
    :sts_cd,
    :bktxcd_domn_cd,
    :bktxcd_fmly_cd,
    :bktxcd_sub_fmly_cd,
    :msg_nm_id,
    :end_to_end_id
  ]

  @modulo_por_versao %{v1_15: V1_15, v1_16: V1_16}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao)
      when versao in [:v1_15, :v1_16] do
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

  @doc "Parseia um XML de camt.054 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt054, modulo.msg_def_idr()}}
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
      "BkToCstmrDbtCdtNtfctn" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "Ntfctn" => [termo_notificacao(m)]
      }
    }
  end

  defp termo_notificacao(m) do
    %{
      "Id" => m.ntfctn_id,
      "Acct" => %{"Id" => %{"Othr" => %{"Id" => m.acct_ispb}}},
      "Ntry" => termo_lancamento(m)
    }
    |> talvez_por("AddtlNtfctnInf", m.addtl_ntfctn_inf)
  end

  defp termo_lancamento(m) do
    %{
      "Amt" => %{valor: to_string(m.valor), atributos: %{"Ccy" => "BRL"}},
      "CdtDbtInd" => m.cdt_dbt_ind,
      "Sts" => %{"Cd" => m.sts_cd},
      "BkTxCd" => %{
        "Domn" => %{
          "Cd" => m.bktxcd_domn_cd,
          "Fmly" => %{"Cd" => m.bktxcd_fmly_cd, "SubFmlyCd" => m.bktxcd_sub_fmly_cd}
        }
      },
      "AddtlInfInd" => %{"MsgNmId" => m.msg_nm_id},
      "NtryDtls" => %{"TxDtls" => termo_tx_dtls(m)}
    }
    |> talvez_por("BookgDt", if(m.bookg_dt, do: %{"Dt" => Date.to_iso8601(m.bookg_dt)}))
    |> talvez_por("ValDt", if(m.val_dt, do: %{"DtTm" => formatar_data_hora(m.val_dt)}))
    |> talvez_por("AddtlNtryInf", m.addtl_ntry_inf)
  end

  defp termo_tx_dtls(m) do
    %{
      "Refs" =>
        %{
          "InstrId" => m.instr_id,
          "EndToEndId" => m.end_to_end_id,
          "TxId" => m.tx_id,
          "ClrSysRef" => m.clr_sys_ref
        }
        |> talvez_por(
          "Prtry",
          if(m.prtry_ref, do: %{"Tp" => "ServiceLevel", "Ref" => m.prtry_ref})
        )
    }
    |> talvez_por("RltdPties", rltd_pties_termo(m))
    |> Map.put("RltdAgts", rltd_agts_termo(m))
    |> talvez_por("LclInstrm", if(m.lcl_instrm, do: %{"Prtry" => m.lcl_instrm}))
    |> talvez_por("Purp", if(m.purp_cd, do: %{"Cd" => m.purp_cd}))
    |> talvez_por("RmtInf", if(m.info_pagamento, do: %{"Ustrd" => m.info_pagamento}))
    |> talvez_por(
      "RltdDts",
      if(m.accptnc_dt_tm, do: %{"AccptncDtTm" => formatar_data_hora(m.accptnc_dt_tm)})
    )
    |> talvez_por("RtrInf", rtr_inf_termo(m))
    |> talvez_por("AddtlTxInf", m.addtl_tx_inf)
  end

  defp rltd_pties_termo(%{dbtr_nome: nil}), do: nil

  defp rltd_pties_termo(m) do
    %{
      "Dbtr" => %{
        "Pty" => %{
          "Nm" => m.dbtr_nome,
          "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}
        }
      },
      "DbtrAcct" => conta_termo(m.dbtr_conta_id, m.dbtr_conta_issr, m.dbtr_conta_tipo),
      "Cdtr" => %{"Pty" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}}},
      "CdtrAcct" =>
        conta_termo(m.cdtr_conta_id, m.cdtr_conta_issr, m.cdtr_conta_tipo, m.cdtr_conta_chave)
    }
    |> talvez_por(
      "InitgPty",
      if(m.initg_pty_id,
        do: %{"Pty" => %{"Id" => %{"OrgId" => %{"Othr" => %{"Id" => m.initg_pty_id}}}}}
      )
    )
  end

  defp conta_termo(id, issr, tipo, chave \\ nil) do
    base = %{"Id" => %{"Othr" => %{"Id" => id, "Issr" => issr}}, "Tp" => %{"Cd" => tipo}}
    if chave, do: Map.put(base, "Prxy", %{"Id" => chave}), else: base
  end

  defp rltd_agts_termo(m) do
    %{}
    |> talvez_por("DbtrAgt", if(m.dbtr_agt_ispb, do: agente_termo(m.dbtr_agt_ispb)))
    |> talvez_por("CdtrAgt", if(m.cdtr_agt_ispb, do: agente_termo(m.cdtr_agt_ispb)))
  end

  defp agente_termo(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp rtr_inf_termo(%{rtr_rsn_cd: nil}), do: nil

  defp rtr_inf_termo(m) do
    %{"Rsn" => %{"Cd" => m.rtr_rsn_cd}} |> talvez_por("AddtlInf", m.rtr_rsn_addtl_inf)
  end

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "BkToCstmrDbtCdtNtfctn"])
    grp = doc["GrpHdr"]
    [ntfctn] = doc["Ntfctn"]
    ntry = ntfctn["Ntry"]
    tx = get_in(ntry, ["NtryDtls", "TxDtls"])
    refs = tx["Refs"]
    rltd_pties = tx["RltdPties"] || %{}
    dbtr_acct = rltd_pties["DbtrAcct"] || %{}
    cdtr_acct = rltd_pties["CdtrAcct"] || %{}
    rltd_agts = tx["RltdAgts"] || %{}
    rtr_inf = tx["RtrInf"] || %{}
    bktxcd_domn = get_in(ntry, ["BkTxCd", "Domn"])

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      ntfctn_id: ntfctn["Id"],
      acct_ispb: get_in(ntfctn, ["Acct", "Id", "Othr", "Id"]),
      addtl_ntfctn_inf: ntfctn["AddtlNtfctnInf"],
      valor: get_in(ntry, ["Amt", :valor]),
      cdt_dbt_ind: ntry["CdtDbtInd"],
      sts_cd: get_in(ntry, ["Sts", "Cd"]),
      bookg_dt: get_in(ntry, ["BookgDt", "Dt"]) |> parse_data(),
      val_dt: get_in(ntry, ["ValDt", "DtTm"]) |> parse_data_hora(),
      bktxcd_domn_cd: bktxcd_domn["Cd"],
      bktxcd_fmly_cd: get_in(bktxcd_domn, ["Fmly", "Cd"]),
      bktxcd_sub_fmly_cd: get_in(bktxcd_domn, ["Fmly", "SubFmlyCd"]),
      addtl_ntry_inf: ntry["AddtlNtryInf"],
      msg_nm_id: get_in(ntry, ["AddtlInfInd", "MsgNmId"]),
      instr_id: refs["InstrId"],
      end_to_end_id: refs["EndToEndId"],
      tx_id: refs["TxId"],
      clr_sys_ref: refs["ClrSysRef"],
      prtry_ref: get_in(refs, ["Prtry", "Ref"]),
      initg_pty_id: get_in(rltd_pties, ["InitgPty", "Pty", "Id", "OrgId", "Othr", "Id"]),
      dbtr_nome: get_in(rltd_pties, ["Dbtr", "Pty", "Nm"]),
      dbtr_cpf_cnpj: get_in(rltd_pties, ["Dbtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_conta_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_conta_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_conta_tipo: get_in(dbtr_acct, ["Tp", "Cd"]),
      cdtr_cpf_cnpj: get_in(rltd_pties, ["Cdtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_conta_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_conta_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_conta_tipo: get_in(cdtr_acct, ["Tp", "Cd"]),
      cdtr_conta_chave: get_in(cdtr_acct, ["Prxy", "Id"]),
      dbtr_agt_ispb: get_in(rltd_agts, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(rltd_agts, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      lcl_instrm: get_in(tx, ["LclInstrm", "Prtry"]),
      purp_cd: get_in(tx, ["Purp", "Cd"]),
      info_pagamento: get_in(tx, ["RmtInf", "Ustrd"]),
      accptnc_dt_tm: get_in(tx, ["RltdDts", "AccptncDtTm"]) |> parse_data_hora(),
      rtr_rsn_cd: get_in(rtr_inf, ["Rsn", "Cd"]),
      rtr_rsn_addtl_inf: rtr_inf["AddtlInf"],
      addtl_tx_inf: tx["AddtlTxInf"]
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
