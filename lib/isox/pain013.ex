defmodule Isox.Pain013 do
  @moduledoc """
  Instrução de pagamento agendada, vinculada a uma recorrência ativa do
  Pix Automático.

  Versão 2.2. Na data marcada, esta instrução vira uma `Isox.Pacs008`
  real, que repete o `end_to_end_id` gerado aqui. A resposta imediata é
  uma `Isox.Pain014`, dizendo se o participante do pagador aceitou.

  O valor vai em `Amt/InstdAmt`, não em `IntrBkSttlmAmt`, porque ainda não
  houve liquidação. `Purp` aqui é `Prtry`, com enum próprio, não `Cd` como
  na pacs.008.

  ## Campos fixos que não viram campo

  `InitgPty` é `[0]{14}` no schema real, quatorze zeros literais, então
  não é variável. O mesmo vale para `PmtMtd` (`"TRF"`), `InstrPrty`
  (`"NORM"`), `SvcLvl.Prtry` (`"PAGAGD"`), `LclInstrm.Prtry` (`"AUTO"`) e
  `ChrgBr` (`"SLEV"`).

  ## Regras que o XSD não expressa

  `reqd_exctn_dt` é opcional no schema, mas na prática é obrigatório
  quando `purp_prtry` é `"AGND"` e proibido nos outros casos.

  `tax_records` é o bloco de Split Payment, a divisão de IBS e CBS da
  reforma tributária. Só é permitido quando `dbtr_cpf_cnpj` é CNPJ. Cada
  tipo de tributo precisa de um registro com `ctgy` igual a `"INF"`, o
  valor informado, e pode ter outro com `"COR"`, o valor corrigido pela
  Plataforma Pública, que prevalece quando existe. A soma dos valores
  efetivos não pode passar de `value`. `encode/3` valida tudo isso.

  ## Lote

  `PmtInf` é ilimitado no schema. `encode/3` aceita uma mensagem ou uma
  lista, com `NbOfTxs` ajustado, e `decode/1` devolve uma struct ou uma
  lista.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pain013.V2_2

  @type version :: :v2_2

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :created_at,
    :pmt_inf_id,
    :reqd_exctn_dt,
    :xpry_dt,
    :dbtr_cpf_cnpj,
    :dbtr_agt_ispb,
    :ultmt_dbtr_name,
    :ultmt_dbtr_cpf_cnpj,
    :end_to_end_id,
    :value,
    :mndt_id,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_issr,
    :cdtr_acct_type,
    :purp_prtry,
    :rmt_inf,
    :tax_ref_nb,
    tax_records: []
  ]

  @type tax_record :: %{tp: String.t(), ctgy: String.t(), ttl_amt: String.t()}
  @type t :: %__MODULE__{}

  @required_fields [
    :msg_id,
    :created_at,
    :pmt_inf_id,
    :xpry_dt,
    :dbtr_cpf_cnpj,
    :dbtr_agt_ispb,
    :end_to_end_id,
    :value,
    :mndt_id,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_acct_id,
    :cdtr_acct_type,
    :purp_prtry
  ]

  @module_by_version %{v2_2: V2_2}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc """
  Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão
  dada. Aceita 1 mensagem ou uma lista de mensagens (lote: vira vários
  `PmtInf` na mesma `Document`, com `NbOfTxs` ajustado à quantidade).

  `msg_id`/`created_at` são de `GrpHdr` (uma vez por mensagem XML). Em
  lote, têm que ser iguais em todos os itens da lista.
  """
  @spec encode(t() | [t(), ...], AppHdr.t(), version()) ::
          {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) do
    encode([message], header, version)
  end

  def encode([%__MODULE__{} | _] = messages, %AppHdr{} = header, version)
      when version in [:v2_2] do
    with :ok <- validate_all_required(messages),
         :ok <- validate_all_business_rules(messages),
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
  Decodifica um XML de pain.013 de volta para a struct, ou
  para uma lista de structs quando a
  mensagem traz mais de um `PmtInf` (lote), para uma lista de structs.
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
      :error -> {:error, {:not_pain013, module.msg_def_idr()}}
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

  defp validate_all_business_rules(messages) do
    Enum.reduce_while(messages, :ok, fn message, :ok ->
      case validate_business_rules(message) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_business_rules(message) do
    with :ok <- validate_reqd_exctn_dt(message) do
      validate_tax(message)
    end
  end

  defp validate_reqd_exctn_dt(%{purp_prtry: "AGND", reqd_exctn_dt: nil}) do
    {:error, "reqd_exctn_dt é obrigatório quando purp_prtry = \"AGND\""}
  end

  defp validate_reqd_exctn_dt(%{purp_prtry: purp, reqd_exctn_dt: dt})
       when purp in ["NTAG", "RIFL"] and not is_nil(dt) do
    {:error, "reqd_exctn_dt não deve ser preenchido quando purp_prtry = #{inspect(purp)}"}
  end

  defp validate_reqd_exctn_dt(_message), do: :ok

  defp validate_tax(%{tax_records: []}), do: :ok

  defp validate_tax(message) do
    with :ok <- validate_tax_requires_cnpj(message),
         :ok <- validate_tax_inf_per_type(message) do
      validate_tax_sum(message)
    end
  end

  defp validate_tax_requires_cnpj(%{dbtr_cpf_cnpj: cpf_cnpj}) do
    if is_binary(cpf_cnpj) and String.length(cpf_cnpj) == 14 do
      :ok
    else
      {:error,
       "tax_records (Split Payment) só é permitido quando dbtr_cpf_cnpj é CNPJ (14 caracteres)"}
    end
  end

  defp validate_tax_inf_per_type(%{tax_records: tax_records}) do
    missing =
      tax_records
      |> Enum.map(& &1.tp)
      |> Enum.uniq()
      |> Enum.reject(fn tp -> Enum.any?(tax_records, &(&1.tp == tp and &1.ctgy == "INF")) end)

    if missing == [] do
      :ok
    else
      {:error, "tax_records: falta Record com ctgy \"INF\" para o(s) tipo(s) #{inspect(missing)}"}
    end
  end

  defp validate_tax_sum(%{tax_records: tax_records, value: value}) do
    types = tax_records |> Enum.map(& &1.tp) |> Enum.uniq()

    with {:ok, total_cents} <- sum_effective_cents(tax_records, types),
         {:ok, value_cents} <- cents(value) do
      if total_cents <= value_cents do
        :ok
      else
        {:error, "tax_records: soma dos tributos excede o valor da transação (#{value})"}
      end
    else
      :error -> {:error, "tax_records: valor decimal inválido em TtlAmt ou value"}
    end
  end

  defp sum_effective_cents(tax_records, types) do
    Enum.reduce_while(types, {:ok, 0}, fn tp, {:ok, acc} ->
      record =
        Enum.find(tax_records, &(&1.tp == tp and &1.ctgy == "COR")) ||
          Enum.find(tax_records, &(&1.tp == tp and &1.ctgy == "INF"))

      case record && cents(record.ttl_amt) do
        {:ok, value} -> {:cont, {:ok, acc + value}}
        _ -> {:halt, :error}
      end
    end)
  end

  defp cents(str) when is_binary(str) do
    case Regex.run(~r/^(-?\d+)(?:\.(\d{1,2}))?$/, str) do
      [_, int] ->
        {:ok, String.to_integer(int) * 100}

      [_, int, frac] ->
        {:ok, String.to_integer(int) * 100 + String.to_integer(String.pad_trailing(frac, 2, "0"))}

      nil ->
        :error
    end
  end

  defp cents(_str), do: :error

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
      "CdtrPmtActvtnReq" => %{
        "GrpHdr" => %{
          "MsgId" => first.msg_id,
          "CreDtTm" => format_datetime(first.created_at),
          "NbOfTxs" => messages |> length() |> to_string(),
          "InitgPty" => %{"Id" => %{"OrgId" => %{"Othr" => %{"Id" => String.duplicate("0", 14)}}}}
        },
        "PmtInf" => Enum.map(messages, &pmt_inf_term/1)
      }
    }
  end

  defp pmt_inf_term(m) do
    %{
      "PmtInfId" => m.pmt_inf_id,
      "PmtMtd" => "TRF",
      "XpryDt" => %{"Dt" => Date.to_iso8601(m.xpry_dt)},
      "Dbtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}},
      "DbtrAgt" => agent_term(m.dbtr_agt_ispb),
      "CdtTrfTx" => cdt_trf_tx_term(m)
    }
    |> maybe_put(
      "ReqdExctnDt",
      if(m.reqd_exctn_dt, do: %{"DtTm" => format_datetime(m.reqd_exctn_dt)})
    )
    |> maybe_put("UltmtDbtr", ultmt_dbtr_term(m))
  end

  defp cdt_trf_tx_term(m) do
    %{
      "PmtId" => %{"EndToEndId" => m.end_to_end_id},
      "PmtTpInf" => %{
        "InstrPrty" => "NORM",
        "SvcLvl" => %{"Prtry" => "PAGAGD"},
        "LclInstrm" => %{"Prtry" => "AUTO"}
      },
      "Amt" => %{"InstdAmt" => %{value: to_string(m.value), attributes: %{"Ccy" => "BRL"}}},
      "ChrgBr" => "SLEV",
      "MndtRltdInf" => %{"MndtId" => m.mndt_id},
      "CdtrAgt" => agent_term(m.cdtr_agt_ispb),
      "Cdtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}},
      "CdtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.cdtr_acct_id, "Issr" => m.cdtr_acct_issr}},
        "Tp" => %{"Cd" => m.cdtr_acct_type}
      },
      "Purp" => %{"Prtry" => m.purp_prtry}
    }
    |> maybe_put("RmtInf", if(m.rmt_inf, do: %{"Ustrd" => m.rmt_inf}))
    |> maybe_put("Tax", tax_term(m))
  end

  defp tax_term(%{tax_records: []}), do: nil

  defp tax_term(m) do
    %{"Rcrd" => Enum.map(m.tax_records, &tax_record_term/1)}
    |> maybe_put("RefNb", m.tax_ref_nb)
  end

  defp tax_record_term(%{tp: tp, ctgy: ctgy, ttl_amt: ttl_amt}) do
    %{
      "Tp" => tp,
      "Ctgy" => ctgy,
      "TaxAmt" => %{"TtlAmt" => %{value: to_string(ttl_amt), attributes: %{"Ccy" => "BRL"}}}
    }
  end

  defp ultmt_dbtr_term(%{ultmt_dbtr_name: nil}), do: nil

  defp ultmt_dbtr_term(m) do
    %{
      "Nm" => m.ultmt_dbtr_name,
      "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.ultmt_dbtr_cpf_cnpj}}}
    }
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "CdtrPmtActvtnReq"])
    grp = doc["GrpHdr"]

    case doc["PmtInf"] do
      [pmt_inf] -> {:ok, pmt_inf_from_term(grp, pmt_inf)}
      pmt_infs -> {:ok, Enum.map(pmt_infs, &pmt_inf_from_term(grp, &1))}
    end
  end

  defp pmt_inf_from_term(grp, pmt_inf) do
    ultmt_dbtr = pmt_inf["UltmtDbtr"] || %{}
    tx = pmt_inf["CdtTrfTx"]
    cdtr_acct = tx["CdtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      pmt_inf_id: pmt_inf["PmtInfId"],
      reqd_exctn_dt: get_in(pmt_inf, ["ReqdExctnDt", "DtTm"]) |> parse_datetime(),
      xpry_dt: get_in(pmt_inf, ["XpryDt", "Dt"]) |> parse_date(),
      dbtr_cpf_cnpj: get_in(pmt_inf, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_agt_ispb: get_in(pmt_inf, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      ultmt_dbtr_name: ultmt_dbtr["Nm"],
      ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      end_to_end_id: get_in(tx, ["PmtId", "EndToEndId"]),
      value: get_in(tx, ["Amt", "InstdAmt", :value]),
      mndt_id: get_in(tx, ["MndtRltdInf", "MndtId"]),
      cdtr_agt_ispb: get_in(tx, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_acct_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_acct_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_acct_type: get_in(cdtr_acct, ["Tp", "Cd"]),
      purp_prtry: get_in(tx, ["Purp", "Prtry"]),
      rmt_inf: get_in(tx, ["RmtInf", "Ustrd"]),
      tax_ref_nb: get_in(tx, ["Tax", "RefNb"]),
      tax_records:
        tx |> get_in(["Tax", "Rcrd"]) |> List.wrap() |> Enum.map(&tax_record_from_term/1)
    }
  end

  defp tax_record_from_term(%{
         "Tp" => tp,
         "Ctgy" => ctgy,
         "TaxAmt" => %{"TtlAmt" => %{value: value}}
       }) do
    %{tp: tp, ctgy: ctgy, ttl_amt: value}
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
