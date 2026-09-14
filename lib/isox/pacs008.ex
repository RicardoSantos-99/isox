defmodule Isox.Pacs008 do
  @moduledoc """
  Ordem de crédito: a mensagem que move o dinheiro de um Pix.

  O participante do pagador manda uma pacs.008 ao SPI, e o SPI responde com
  uma `Isox.Pacs002` dizendo se liquidou ou rejeitou. Os dois lados se
  amarram pelo `end_to_end_id`.

  Versões 1.15 e 1.16 (ADR 0002). A struct dá nome a cada campo, em vez do
  mapa genérico e cru que o motor de codec interno produz.

  ## O que a struct cobre

  O caminho comum de um Pix: todos os campos obrigatórios da árvore real do
  XSD, mais os opcionais que aparecem de fato (`InstrId`, `TxId`,
  `InitgPty`, `Prxy`, `RmtInf.Ustrd`). Ficam de fora `Tax` e `RmtInf.Strd`,
  ramos raros fora do fluxo padrão do Pix.

  ## Lote

  `CdtTrfTxInf` é ilimitado no XSD, e o catálogo documenta lote de verdade
  (`pacs.008_CONTA_10_msg.xml`, 10 transações numa mensagem só). `encode/3`
  aceita 1 mensagem ou uma lista; `decode/1` devolve 1 struct ou uma lista,
  conforme o que o XML trouxer.

  Os quatro campos de `GrpHdr` (`msg_id`, `created_at`, `instr_prty`,
  `svc_lvl_prtry`) valem para o XML inteiro, não por transação, então em
  lote precisam estar iguais em todos os itens da lista.

  ## Validação

  `encode/3` confere os campos obrigatórios e, depois de montar o XML, faz o
  caminho de volta pelo módulo gerado. Isso reaproveita a validação de
  pattern, enum e cardinalidade que o parser já faz, sem duplicar regra
  nenhuma. O motor de codec sozinho não valida nada: ele confia no termo que
  recebe.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pacs008.{V1_15, V1_16}

  @type version :: :v1_15 | :v1_16

  defstruct [
    :msg_id,
    :created_at,
    instr_prty: "NORM",
    svc_lvl_prtry: nil,
    end_to_end_id: nil,
    tx_id: nil,
    instr_id: nil,
    value: nil,
    accptnc_dt_tm: nil,
    lcl_instrm: nil,
    initg_pty_id: nil,
    dbtr_name: nil,
    dbtr_cpf_cnpj: nil,
    dbtr_acct_id: nil,
    dbtr_acct_issr: nil,
    dbtr_acct_type: "CACC",
    dbtr_agt_ispb: nil,
    cdtr_cpf_cnpj: nil,
    cdtr_acct_id: nil,
    cdtr_acct_issr: nil,
    cdtr_acct_type: "CACC",
    cdtr_acct_proxy: nil,
    cdtr_agt_ispb: nil,
    purp_cd: nil,
    rmt_inf: nil
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          instr_prty: String.t(),
          svc_lvl_prtry: String.t(),
          end_to_end_id: String.t(),
          tx_id: String.t() | nil,
          instr_id: String.t() | nil,
          value: String.t() | number(),
          accptnc_dt_tm: DateTime.t(),
          lcl_instrm: String.t(),
          initg_pty_id: String.t() | nil,
          dbtr_name: String.t(),
          dbtr_cpf_cnpj: String.t(),
          dbtr_acct_id: String.t(),
          dbtr_acct_issr: String.t() | nil,
          dbtr_acct_type: String.t(),
          dbtr_agt_ispb: String.t(),
          cdtr_cpf_cnpj: String.t(),
          cdtr_acct_id: String.t(),
          cdtr_acct_issr: String.t() | nil,
          cdtr_acct_type: String.t(),
          cdtr_acct_proxy: String.t() | nil,
          cdtr_agt_ispb: String.t(),
          purp_cd: String.t(),
          rmt_inf: String.t() | nil
        }

  @required_fields [
    :msg_id,
    :created_at,
    :instr_prty,
    :svc_lvl_prtry,
    :end_to_end_id,
    :value,
    :accptnc_dt_tm,
    :lcl_instrm,
    :dbtr_name,
    :dbtr_cpf_cnpj,
    :dbtr_acct_id,
    :dbtr_acct_type,
    :dbtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_type,
    :cdtr_agt_ispb,
    :purp_cd
  ]

  @module_by_version %{v1_15: V1_15, v1_16: V1_16}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista (lote: vira várias `CdtTrfTxInf`
  na mesma `Document`, com `NbOfTxs` ajustado à quantidade).

  `msg_id`/`created_at`/`instr_prty`/`svc_lvl_prtry` são de `GrpHdr` (uma
  vez por mensagem XML). Em lote, têm que ser iguais em todos os itens
  da lista.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v1_15, :v1_16] do
    with :ok <- validate_all_required(messages),
         :ok <- validate_all_instr_id(messages, version),
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
  Decodifica um XML de pacs.008 (qualquer versão) de volta para a
  struct, ou para uma lista de structs quando a mensagem traz mais de uma `CdtTrfTxInf` (lote), para
  uma lista de structs.
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
      :error -> {:error, {:not_pacs008, module.msg_def_idr()}}
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

  defp validate_all_instr_id(messages, version) do
    Enum.reduce_while(messages, :ok, fn message, :ok ->
      case validate_instr_id(message, version) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_instr_id(%{instr_id: nil}, _version), do: :ok
  defp validate_instr_id(_message, :v1_16), do: :ok
  defp validate_instr_id(_message, _version), do: {:error, "InstrId só é aceito na versão 1.16"}

  defp validate_shared_header([_single]), do: :ok

  defp validate_shared_header([first | rest]) do
    %{
      msg_id: msg_id,
      created_at: created_at,
      instr_prty: instr_prty,
      svc_lvl_prtry: svc_lvl_prtry
    } = first

    same? =
      Enum.all?(rest, fn m ->
        m.msg_id == msg_id and m.created_at == created_at and m.instr_prty == instr_prty and
          m.svc_lvl_prtry == svc_lvl_prtry
      end)

    if same? do
      :ok
    else
      {:error,
       "msg_id/created_at/instr_prty/svc_lvl_prtry precisam ser iguais em todas as mensagens do lote"}
    end
  end

  defp document_term(first, messages) do
    %{
      "FIToFICstmrCdtTrf" => %{
        "GrpHdr" => %{
          "MsgId" => first.msg_id,
          "CreDtTm" => format_datetime(first.created_at),
          "NbOfTxs" => messages |> length() |> to_string(),
          "SttlmInf" => %{"SttlmMtd" => "CLRG"},
          "PmtTpInf" => %{
            "InstrPrty" => first.instr_prty,
            "SvcLvl" => %{"Prtry" => first.svc_lvl_prtry}
          }
        },
        "CdtTrfTxInf" => Enum.map(messages, &transaction_term/1)
      }
    }
  end

  defp transaction_term(m) do
    %{
      "PmtId" => %{
        "InstrId" => m.instr_id,
        "EndToEndId" => m.end_to_end_id,
        "TxId" => m.tx_id
      },
      "IntrBkSttlmAmt" => %{value: to_string(m.value), attributes: %{"Ccy" => "BRL"}},
      "AccptncDtTm" => format_datetime(m.accptnc_dt_tm),
      "ChrgBr" => "SLEV",
      "MndtRltdInf" => %{"Tp" => %{"LclInstrm" => %{"Prtry" => m.lcl_instrm}}},
      "Dbtr" => %{
        "Nm" => m.dbtr_name,
        "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}
      },
      "DbtrAcct" => account_term(m.dbtr_acct_id, m.dbtr_acct_issr, m.dbtr_acct_type),
      "DbtrAgt" => agent_term(m.dbtr_agt_ispb),
      "CdtrAgt" => agent_term(m.cdtr_agt_ispb),
      "Cdtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}},
      "CdtrAcct" =>
        account_term(m.cdtr_acct_id, m.cdtr_acct_issr, m.cdtr_acct_type, m.cdtr_acct_proxy),
      "Purp" => %{"Cd" => m.purp_cd}
    }
    |> maybe_put("InitgPty", initg_pty_term(m.initg_pty_id))
    |> maybe_put("RmtInf", rmt_inf_term(m.rmt_inf))
  end

  defp account_term(id, issr, type, proxy \\ nil) do
    base = %{"Id" => %{"Othr" => %{"Id" => id, "Issr" => issr}}, "Tp" => %{"Cd" => type}}
    if proxy, do: Map.put(base, "Prxy", %{"Id" => proxy}), else: base
  end

  defp agent_term(ispb) do
    %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}
  end

  defp initg_pty_term(nil), do: nil
  defp initg_pty_term(id), do: %{"Id" => %{"OrgId" => %{"Othr" => %{"Id" => id}}}}

  defp rmt_inf_term(nil), do: nil
  defp rmt_inf_term(text), do: %{"Ustrd" => text}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "FIToFICstmrCdtTrf"])
    grp = doc["GrpHdr"]

    case doc["CdtTrfTxInf"] do
      [tx] -> {:ok, tx_from_term(grp, tx)}
      txs -> {:ok, Enum.map(txs, &tx_from_term(grp, &1))}
    end
  end

  defp tx_from_term(grp, tx) do
    pmt_id = tx["PmtId"]
    dbtr_acct = tx["DbtrAcct"]
    cdtr_acct = tx["CdtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      instr_prty: get_in(grp, ["PmtTpInf", "InstrPrty"]),
      svc_lvl_prtry: get_in(grp, ["PmtTpInf", "SvcLvl", "Prtry"]),
      end_to_end_id: pmt_id["EndToEndId"],
      tx_id: pmt_id["TxId"],
      instr_id: pmt_id["InstrId"],
      value: get_in(tx, ["IntrBkSttlmAmt", :value]),
      accptnc_dt_tm: parse_datetime(tx["AccptncDtTm"]),
      lcl_instrm: get_in(tx, ["MndtRltdInf", "Tp", "LclInstrm", "Prtry"]),
      initg_pty_id: get_in(tx, ["InitgPty", "Id", "OrgId", "Othr", "Id"]),
      dbtr_name: get_in(tx, ["Dbtr", "Nm"]),
      dbtr_cpf_cnpj: get_in(tx, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_acct_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_acct_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_acct_type: get_in(dbtr_acct, ["Tp", "Cd"]),
      dbtr_agt_ispb: get_in(tx, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(tx, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_acct_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_acct_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_acct_type: get_in(cdtr_acct, ["Tp", "Cd"]),
      cdtr_acct_proxy: get_in(cdtr_acct, ["Prxy", "Id"]),
      purp_cd: get_in(tx, ["Purp", "Cd"]),
      rmt_inf: get_in(tx, ["RmtInf", "Ustrd"])
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
end
