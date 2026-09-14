defmodule Isox.Pain012 do
  @moduledoc """
  Resposta sobre uma recorrência do Pix Automático: aceita ou recusa uma
  `Isox.Pain009` ou uma `Isox.Pain011`.

  Versões 1.3 e 1.4 coexistindo. `accptd` é o campo que se lê primeiro, e
  `mndt_sts` diz a que mensagem esta resposta se refere: `"PDNG"` responde
  a uma pain.009, `"CCLD"` responde a uma pain.011.

  ## A cópia da recorrência difere das outras duas

  O bloco do mandato original aqui não é igual ao da pain.009 nem ao da
  pain.011. Tem `Dbtr.PstlAdr.TwnNm` e `MndtRef`, que as outras não têm, e
  não tem `Adjstmnt`. Isso foi conferido contra o schema real de cada uma,
  não deduzido por semelhança.

  `MndtPrcgDtls` é opcional e vai de 0 a 3 itens, diferente da pain.009,
  que exige exatamente 3. `SplmtryData` ganha ainda `MndtSts`.

  ## Regra cruzada que o XSD não expressa

  Validada em `encode/3`, a partir da planilha e confirmada nos 12
  exemplos oficiais do BCB, sem exceção:

  - `accptd` falso exige `rjct_rsn_prtry` presente, e `mndt_sts` e
    `mndt_prcg_dtls` ausentes.
  - `accptd` verdadeiro exige o oposto: `rjct_rsn_prtry` ausente e
    `mndt_sts` presente.

  Que domínios de `mndt_prcg_dtls` acompanham qual `mndt_sts` não é
  validado aqui. A regra está na planilha, mas verificá-la exigiria
  duplicar a lógica de negócio inteira do Pix Automático.

  ## Lote

  `UndrlygAccptncDtls` é ilimitado no schema. `encode/3` aceita uma
  mensagem ou uma lista, e `decode/1` devolve uma struct ou uma lista.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pain012.{V1_3, V1_4}

  @type version :: :v1_3 | :v1_4

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :created_at,
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
    :orgnl_cdtr_name,
    :orgnl_cdtr_cpf_cnpj,
    :orgnl_cdtr_agt_ispb,
    :orgnl_dbtr_twn_nm,
    :orgnl_dbtr_cpf_cnpj,
    :orgnl_dbtr_acct_id,
    :orgnl_dbtr_acct_issr,
    :orgnl_dbtr_agt_ispb,
    :orgnl_ultmt_dbtr_name,
    :orgnl_ultmt_dbtr_cpf_cnpj,
    :orgnl_mndt_ref,
    :orgnl_rfrd_doc_nb,
    :orgnl_rfrd_doc_cdtr_ref,
    :mndt_sts,
    mndt_prcg_dtls: []
  ]

  @type t :: %__MODULE__{}

  @required_fields [
    :msg_id,
    :created_at,
    :instg_agt_ispb,
    :accptd,
    :orgnl_mndt_id,
    :orgnl_mndt_req_id,
    :orgnl_frqcy_tp,
    :orgnl_frst_colltn_dt,
    :orgnl_trckg_ind,
    :orgnl_cdtr_name,
    :orgnl_cdtr_cpf_cnpj,
    :orgnl_cdtr_agt_ispb,
    :orgnl_dbtr_cpf_cnpj,
    :orgnl_dbtr_acct_id,
    :orgnl_dbtr_agt_ispb,
    :orgnl_rfrd_doc_nb
  ]

  @module_by_version %{v1_3: V1_3, v1_4: V1_4}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista de mensagens (lote: vira vários
  `UndrlygAccptncDtls` na mesma `Document`).

  `msg_id`/`created_at`/`instg_agt_ispb` são de `GrpHdr` (uma vez por
  mensagem XML). Em lote, têm que ser iguais em todos os itens da
  lista.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v1_3, :v1_4] do
    with :ok <- validate_all_required(messages),
         :ok <- validate_all_acceptance_consistency(messages),
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
  Decodifica um XML de pain.012 de volta para a struct, ou
  para uma lista de structs quando a
  mensagem traz mais de um `UndrlygAccptncDtls` (lote), para uma lista
  de structs.
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
      :error -> {:error, {:not_pain012, module.msg_def_idr()}}
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

  defp validate_all_acceptance_consistency(messages) do
    Enum.reduce_while(messages, :ok, fn message, :ok ->
      case validate_acceptance_consistency(message) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  # Planilha do catálogo, confirmada pelos 12 exemplos oficiais do BCB
  # sem exceção: accptd "false" nunca leva mndt_sts/mndt_prcg_dtls (só
  # rjct_rsn_prtry); accptd "true" nunca leva rjct_rsn_prtry, e sempre
  # leva mndt_sts. O XSD não força nada disso (RjctRsn/MndtSts/
  # MndtPrcgDtls são todos opcionais pro schema, sem vínculo entre si
  # declarado). Sem esta checagem, uma resposta de aceite sem
  # mndt_sts, ou uma rejeição carregando mndt_sts, passava sem erro
  # nenhum.
  defp validate_acceptance_consistency(%{accptd: "false"} = m) do
    cond do
      m.rjct_rsn_prtry == nil ->
        {:error, "rjct_rsn_prtry é obrigatório quando accptd é \"false\""}

      m.mndt_sts != nil or m.mndt_prcg_dtls != [] ->
        {:error, "mndt_sts/mndt_prcg_dtls não devem ser informados quando accptd é \"false\""}

      true ->
        :ok
    end
  end

  defp validate_acceptance_consistency(%{accptd: "true"} = m) do
    cond do
      m.rjct_rsn_prtry != nil ->
        {:error, "rjct_rsn_prtry não deve ser informado quando accptd é \"true\""}

      m.mndt_sts == nil ->
        {:error, "mndt_sts é obrigatório quando accptd é \"true\""}

      true ->
        :ok
    end
  end

  defp validate_acceptance_consistency(_message), do: :ok

  defp validate_shared_header([_single]), do: :ok

  defp validate_shared_header([first | rest]) do
    %{msg_id: msg_id, created_at: created_at, instg_agt_ispb: instg_agt_ispb} = first

    same? =
      Enum.all?(rest, fn m ->
        m.msg_id == msg_id and m.created_at == created_at and m.instg_agt_ispb == instg_agt_ispb
      end)

    if same? do
      :ok
    else
      {:error,
       "msg_id/created_at/instg_agt_ispb precisam ser iguais em todas as mensagens do lote"}
    end
  end

  defp document_term(first, messages) do
    %{
      "MndtAccptncRpt" => %{
        "GrpHdr" => %{
          "MsgId" => first.msg_id,
          "CreDtTm" => format_datetime(first.created_at),
          "InstgAgt" => agent_term(first.instg_agt_ispb)
        },
        "UndrlygAccptncDtls" => Enum.map(messages, &detail_term/1)
      }
    }
  end

  defp detail_term(m) do
    %{
      "AccptncRslt" =>
        %{"Accptd" => to_string(m.accptd)}
        |> maybe_put("RjctRsn", if(m.rjct_rsn_prtry, do: %{"Prtry" => m.rjct_rsn_prtry})),
      "OrgnlMndt" => %{"OrgnlMndt" => original_mandate_term(m)}
    }
    |> maybe_put("SplmtryData", splmtry_term(m))
  end

  defp original_mandate_term(m) do
    %{
      "MndtId" => m.orgnl_mndt_id,
      "MndtReqId" => m.orgnl_mndt_req_id,
      "Ocrncs" =>
        %{
          "SeqTp" => "RCUR",
          "Frqcy" => %{"Tp" => m.orgnl_frqcy_tp},
          "FrstColltnDt" => Date.to_iso8601(m.orgnl_frst_colltn_dt)
        }
        |> maybe_put(
          "FnlColltnDt",
          if(m.orgnl_fnl_colltn_dt, do: Date.to_iso8601(m.orgnl_fnl_colltn_dt))
        ),
      "TrckgInd" => to_string(m.orgnl_trckg_ind),
      "Cdtr" => %{
        "Nm" => m.orgnl_cdtr_name,
        "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_cdtr_cpf_cnpj}}}
      },
      "CdtrAgt" => agent_term(m.orgnl_cdtr_agt_ispb),
      "Dbtr" =>
        %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_dbtr_cpf_cnpj}}}}
        |> maybe_put("PstlAdr", if(m.orgnl_dbtr_twn_nm, do: %{"TwnNm" => m.orgnl_dbtr_twn_nm})),
      "DbtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.orgnl_dbtr_acct_id, "Issr" => m.orgnl_dbtr_acct_issr}}
      },
      "DbtrAgt" => agent_term(m.orgnl_dbtr_agt_ispb),
      "RfrdDoc" => %{"Nb" => m.orgnl_rfrd_doc_nb, "CdtrRef" => m.orgnl_rfrd_doc_cdtr_ref}
    }
    |> maybe_put(
      "ColltnAmt",
      if(m.orgnl_colltn_amt,
        do: %{value: to_string(m.orgnl_colltn_amt), attributes: %{"Ccy" => "BRL"}}
      )
    )
    |> maybe_put("UltmtDbtr", ultmt_dbtr_term(m))
    |> maybe_put("MndtRef", m.orgnl_mndt_ref)
  end

  defp ultmt_dbtr_term(%{orgnl_ultmt_dbtr_name: nil}), do: nil

  defp ultmt_dbtr_term(m) do
    %{
      "Nm" => m.orgnl_ultmt_dbtr_name,
      "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.orgnl_ultmt_dbtr_cpf_cnpj}}}
    }
  end

  defp splmtry_term(%{mndt_prcg_dtls: [], mndt_sts: nil}), do: nil

  defp splmtry_term(m) do
    %{}
    |> maybe_put(
      "MndtPrcgDtls",
      if(m.mndt_prcg_dtls != [], do: Enum.map(m.mndt_prcg_dtls, &prcg_term/1))
    )
    |> maybe_put("MndtSts", m.mndt_sts)
    |> then(&%{"Envlp" => &1})
  end

  defp prcg_term(p), do: %{"MndtPrcgTp" => p.tp, "PrcgDtTm" => format_datetime(p.dt_tm)}

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "MndtAccptncRpt"])
    grp = doc["GrpHdr"]

    case doc["UndrlygAccptncDtls"] do
      [detalhe] -> {:ok, detalhe_from_term(grp, detalhe)}
      detalhes -> {:ok, Enum.map(detalhes, &detalhe_from_term(grp, &1))}
    end
  end

  defp detalhe_from_term(grp, detalhe) do
    mndt = get_in(detalhe, ["OrgnlMndt", "OrgnlMndt"])
    ocrncs = mndt["Ocrncs"]
    ultmt_dbtr = mndt["UltmtDbtr"] || %{}
    dbtr_acct = mndt["DbtrAcct"]
    envlp = get_in(detalhe, ["SplmtryData", "Envlp"]) || %{}

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      instg_agt_ispb: get_in(grp, ["InstgAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      accptd: get_in(detalhe, ["AccptncRslt", "Accptd"]),
      rjct_rsn_prtry: get_in(detalhe, ["AccptncRslt", "RjctRsn", "Prtry"]),
      orgnl_mndt_id: mndt["MndtId"],
      orgnl_mndt_req_id: mndt["MndtReqId"],
      orgnl_frqcy_tp: get_in(ocrncs, ["Frqcy", "Tp"]),
      orgnl_frst_colltn_dt: ocrncs["FrstColltnDt"] |> parse_date(),
      orgnl_fnl_colltn_dt: ocrncs["FnlColltnDt"] |> parse_date(),
      orgnl_trckg_ind: mndt["TrckgInd"],
      orgnl_colltn_amt: get_in(mndt, ["ColltnAmt", :value]),
      orgnl_cdtr_name: get_in(mndt, ["Cdtr", "Nm"]),
      orgnl_cdtr_cpf_cnpj: get_in(mndt, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      orgnl_cdtr_agt_ispb: get_in(mndt, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_dbtr_twn_nm: get_in(mndt, ["Dbtr", "PstlAdr", "TwnNm"]),
      orgnl_dbtr_cpf_cnpj: get_in(mndt, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      orgnl_dbtr_acct_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      orgnl_dbtr_acct_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      orgnl_dbtr_agt_ispb: get_in(mndt, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      orgnl_ultmt_dbtr_name: ultmt_dbtr["Nm"],
      orgnl_ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      orgnl_mndt_ref: mndt["MndtRef"],
      orgnl_rfrd_doc_nb: get_in(mndt, ["RfrdDoc", "Nb"]),
      orgnl_rfrd_doc_cdtr_ref: get_in(mndt, ["RfrdDoc", "CdtrRef"]),
      mndt_sts: envlp["MndtSts"],
      mndt_prcg_dtls: envlp |> Map.get("MndtPrcgDtls", []) |> Enum.map(&prcg_from_term/1)
    }
  end

  defp prcg_from_term(t), do: %{tp: t["MndtPrcgTp"], dt_tm: parse_datetime(t["PrcgDtTm"])}

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
