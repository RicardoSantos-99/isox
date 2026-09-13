defmodule Isox.Camt054 do
  @moduledoc """
  Modelo ISO 20022 do camt.054 (detalhamento de um lançamento da
  Conta PI — a contrapartida contábil de cada pacs.008/002 liquidada),
  versões 1.15 e 1.16 coexistindo. A maior mensagem do catálogo.

  `Ntfctn` é `max: ilimitado` no schema — o caminho comum é 1 (um
  lançamento por notificação, como o próprio mensagens.md descreve: "um
  por liquidação"), mas `encode/3` aceita 1 mensagem ou uma lista (lote:
  vários `Ntfctn` na mesma `Document`) e `decode/1` devolve 1 struct ou
  uma lista de volta, mesmo padrão do `Pacs002`/`Pacs004`/`Pacs008`.
  `Ntry` já é `max: 1` no schema real, isso não muda.

  Cobre o caminho comum de um lançamento de liquidação (mesmos dados de
  pagador/recebedor do `Pacs008`, mais metadados contábeis e, quando é
  devolução, `RtrInf`). Ficam de fora, mesma razão do `Pacs008`: `Tax` e
  `RmtInf.Strd` — ramos raros, disponíveis via codec genérico.

  `RltdAgts` é obrigatório como contêiner, mas `DbtrAgt`/`CdtrAgt` dentro
  dele são cada um independentemente opcional (diferente do `Pacs008`,
  onde os dois agentes são sempre obrigatórios) — confirmado contra o
  schema real, não assumido do padrão anterior.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Camt054.{V1_15, V1_16}

  @type version :: :v1_15 | :v1_16

  # a maior mensagem do catálogo de verdade tem mais de 31 campos; achatar
  # em sub-structs quebraria a simetria com o resto do modelo (Pacs008 e
  # companhia), sem ganho real — o VM ainda lida bem com 1 struct desse
  # tamanho isolado.
  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :created_at,
    :ntfctn_id,
    :acct_ispb,
    :value,
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
    :dbtr_name,
    :dbtr_cpf_cnpj,
    :dbtr_acct_id,
    :dbtr_acct_issr,
    :dbtr_acct_type,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_issr,
    :cdtr_acct_type,
    :cdtr_acct_proxy,
    :dbtr_agt_ispb,
    :cdtr_agt_ispb,
    :lcl_instrm,
    :purp_cd,
    :rmt_inf,
    :accptnc_dt_tm,
    :rtr_rsn_cd,
    :rtr_rsn_addtl_inf,
    :addtl_tx_inf,
    :addtl_ntry_inf,
    :addtl_ntfctn_inf
  ]

  @type t :: %__MODULE__{}

  @required_fields [
    :msg_id,
    :created_at,
    :ntfctn_id,
    :acct_ispb,
    :value,
    :cdt_dbt_ind,
    :sts_cd,
    :bktxcd_domn_cd,
    :bktxcd_fmly_cd,
    :bktxcd_sub_fmly_cd,
    :msg_nm_id,
    :end_to_end_id
  ]

  @module_by_version %{v1_15: V1_15, v1_16: V1_16}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista de mensagens (lote — vira vários
  `Ntfctn` na mesma `Document`).

  `msg_id`/`created_at` são de `GrpHdr` (uma vez por mensagem XML) — em
  lote, têm que ser iguais em todos os itens da lista.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v1_15, :v1_16] do
    with :ok <- validate_all_required(messages),
         :ok <- validate_shared_header(messages) do
      module = Map.fetch!(@module_by_version, version)
      [first | _] = messages

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(first, messages)
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc """
  Decodifica um XML de camt.054 de volta para a struct — ou, quando a
  mensagem traz mais de um `Ntfctn` (lote), para uma lista de structs.
  """
  @spec decode(binary()) :: {:ok, t() | [t(), ...], version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    with {:ok, module, term} <- Isox.Registry.decode(xml),
         {:ok, version} <- version_for(module),
         {:ok, message_or_messages} <- struct_from_term(term) do
      {:ok, message_or_messages, version}
    end
  end

  defp version_for(module) do
    case Map.fetch(@version_by_module, module) do
      {:ok, version} -> {:ok, version}
      :error -> {:error, {:not_camt054, module.msg_def_idr()}}
    end
  end

  defp confirm(module, xml) do
    case module.decode(xml) do
      {:ok, _term} -> {:ok, xml}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_all_required(messages) do
    Enum.reduce_while(messages, :ok, fn message, :ok ->
      case validate_required(message) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_required(message) do
    missing = Enum.filter(@required_fields, &(Map.get(message, &1) in [nil, ""]))

    if missing == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(missing)}"}
  end

  defp validate_shared_header([_single]), do: :ok

  defp validate_shared_header([%{msg_id: msg_id, created_at: created_at} | rest]) do
    if Enum.all?(rest, &(&1.msg_id == msg_id and &1.created_at == created_at)) do
      :ok
    else
      {:error, "msg_id/created_at precisam ser iguais em todas as mensagens do lote"}
    end
  end

  defp document_term(first, messages) do
    %{
      "BkToCstmrDbtCdtNtfctn" => %{
        "GrpHdr" => %{"MsgId" => first.msg_id, "CreDtTm" => format_datetime(first.created_at)},
        "Ntfctn" => Enum.map(messages, &notification_term/1)
      }
    }
  end

  defp notification_term(m) do
    %{
      "Id" => m.ntfctn_id,
      "Acct" => %{"Id" => %{"Othr" => %{"Id" => m.acct_ispb}}},
      "Ntry" => entry_term(m)
    }
    |> maybe_put("AddtlNtfctnInf", m.addtl_ntfctn_inf)
  end

  defp entry_term(m) do
    %{
      "Amt" => %{value: to_string(m.value), attributes: %{"Ccy" => "BRL"}},
      "CdtDbtInd" => m.cdt_dbt_ind,
      "Sts" => %{"Cd" => m.sts_cd},
      "BkTxCd" => %{
        "Domn" => %{
          "Cd" => m.bktxcd_domn_cd,
          "Fmly" => %{"Cd" => m.bktxcd_fmly_cd, "SubFmlyCd" => m.bktxcd_sub_fmly_cd}
        }
      },
      "AddtlInfInd" => %{"MsgNmId" => m.msg_nm_id},
      "NtryDtls" => %{"TxDtls" => tx_dtls_term(m)}
    }
    |> maybe_put("BookgDt", if(m.bookg_dt, do: %{"Dt" => Date.to_iso8601(m.bookg_dt)}))
    |> maybe_put("ValDt", if(m.val_dt, do: %{"DtTm" => format_datetime(m.val_dt)}))
    |> maybe_put("AddtlNtryInf", m.addtl_ntry_inf)
  end

  defp tx_dtls_term(m) do
    %{
      "Refs" =>
        %{
          "InstrId" => m.instr_id,
          "EndToEndId" => m.end_to_end_id,
          "TxId" => m.tx_id,
          "ClrSysRef" => m.clr_sys_ref
        }
        |> maybe_put(
          "Prtry",
          if(m.prtry_ref, do: %{"Tp" => "ServiceLevel", "Ref" => m.prtry_ref})
        )
    }
    |> maybe_put("RltdPties", rltd_pties_term(m))
    |> Map.put("RltdAgts", rltd_agts_term(m))
    |> maybe_put("LclInstrm", if(m.lcl_instrm, do: %{"Prtry" => m.lcl_instrm}))
    |> maybe_put("Purp", if(m.purp_cd, do: %{"Cd" => m.purp_cd}))
    |> maybe_put("RmtInf", if(m.rmt_inf, do: %{"Ustrd" => m.rmt_inf}))
    |> maybe_put(
      "RltdDts",
      if(m.accptnc_dt_tm, do: %{"AccptncDtTm" => format_datetime(m.accptnc_dt_tm)})
    )
    |> maybe_put("RtrInf", rtr_inf_term(m))
    |> maybe_put("AddtlTxInf", m.addtl_tx_inf)
  end

  defp rltd_pties_term(%{dbtr_name: nil}), do: nil

  defp rltd_pties_term(m) do
    %{
      "Dbtr" => %{
        "Pty" => %{
          "Nm" => m.dbtr_name,
          "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}
        }
      },
      "DbtrAcct" => account_term(m.dbtr_acct_id, m.dbtr_acct_issr, m.dbtr_acct_type),
      "Cdtr" => %{"Pty" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}}},
      "CdtrAcct" =>
        account_term(m.cdtr_acct_id, m.cdtr_acct_issr, m.cdtr_acct_type, m.cdtr_acct_proxy)
    }
    |> maybe_put(
      "InitgPty",
      if(m.initg_pty_id,
        do: %{"Pty" => %{"Id" => %{"OrgId" => %{"Othr" => %{"Id" => m.initg_pty_id}}}}}
      )
    )
  end

  defp account_term(id, issr, type, proxy \\ nil) do
    base = %{"Id" => %{"Othr" => %{"Id" => id, "Issr" => issr}}, "Tp" => %{"Cd" => type}}
    if proxy, do: Map.put(base, "Prxy", %{"Id" => proxy}), else: base
  end

  defp rltd_agts_term(m) do
    %{}
    |> maybe_put("DbtrAgt", if(m.dbtr_agt_ispb, do: agent_term(m.dbtr_agt_ispb)))
    |> maybe_put("CdtrAgt", if(m.cdtr_agt_ispb, do: agent_term(m.cdtr_agt_ispb)))
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp rtr_inf_term(%{rtr_rsn_cd: nil}), do: nil

  defp rtr_inf_term(m) do
    %{"Rsn" => %{"Cd" => m.rtr_rsn_cd}} |> maybe_put("AddtlInf", m.rtr_rsn_addtl_inf)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "BkToCstmrDbtCdtNtfctn"])
    grp = doc["GrpHdr"]

    case doc["Ntfctn"] do
      [ntfctn] -> {:ok, ntfctn_from_term(grp, ntfctn)}
      ntfctns -> {:ok, Enum.map(ntfctns, &ntfctn_from_term(grp, &1))}
    end
  end

  defp ntfctn_from_term(grp, ntfctn) do
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
      created_at: parse_datetime(grp["CreDtTm"]),
      ntfctn_id: ntfctn["Id"],
      acct_ispb: get_in(ntfctn, ["Acct", "Id", "Othr", "Id"]),
      addtl_ntfctn_inf: ntfctn["AddtlNtfctnInf"],
      value: get_in(ntry, ["Amt", :value]),
      cdt_dbt_ind: ntry["CdtDbtInd"],
      sts_cd: get_in(ntry, ["Sts", "Cd"]),
      bookg_dt: get_in(ntry, ["BookgDt", "Dt"]) |> parse_date(),
      val_dt: get_in(ntry, ["ValDt", "DtTm"]) |> parse_datetime(),
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
      dbtr_name: get_in(rltd_pties, ["Dbtr", "Pty", "Nm"]),
      dbtr_cpf_cnpj: get_in(rltd_pties, ["Dbtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_acct_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_acct_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_acct_type: get_in(dbtr_acct, ["Tp", "Cd"]),
      cdtr_cpf_cnpj: get_in(rltd_pties, ["Cdtr", "Pty", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_acct_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_acct_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_acct_type: get_in(cdtr_acct, ["Tp", "Cd"]),
      cdtr_acct_proxy: get_in(cdtr_acct, ["Prxy", "Id"]),
      dbtr_agt_ispb: get_in(rltd_agts, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(rltd_agts, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      lcl_instrm: get_in(tx, ["LclInstrm", "Prtry"]),
      purp_cd: get_in(tx, ["Purp", "Cd"]),
      rmt_inf: get_in(tx, ["RmtInf", "Ustrd"]),
      accptnc_dt_tm: get_in(tx, ["RltdDts", "AccptncDtTm"]) |> parse_datetime(),
      rtr_rsn_cd: get_in(rtr_inf, ["Rsn", "Cd"]),
      rtr_rsn_addtl_inf: rtr_inf["AddtlInf"],
      addtl_tx_inf: tx["AddtlTxInf"]
    }
  end

  defp format_datetime(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(text) do
    {:ok, dt, _offset} = DateTime.from_iso8601(text)
    dt
  end

  defp parse_date(nil), do: nil
  defp parse_date(text), do: Date.from_iso8601!(text)
end
