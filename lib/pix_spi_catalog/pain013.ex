defmodule PixSpiCatalog.Pain013 do
  @moduledoc """
  Representação de domínio do pain.013 (agendamento da instrução de
  pagamento vinculada a um mandato ativo), versão 2.2 — na data agendada,
  essa instrução vira o gatilho de uma pacs.008 real.

  Modela `PmtInf`/`CdtTrfTx` como exatamente 1 por mensagem. `InitgPty`
  no `GrpHdr` é sempre `[0]{14}` (14 zeros) no schema real — não é campo
  variável, fica fixo, assim como `PmtMtd` ("TRF"), `InstrPrty` ("NORM"),
  `SvcLvl.Prtry` ("PAGAGD"), `LclInstrm.Prtry` ("AUTO") e `ChrgBr`
  ("SLEV"). Valor vai em `Amt/InstdAmt`, não `IntrBkSttlmAmt` — ainda não
  liquidado. `Purp` aqui é `Prtry` (enum próprio), não `Cd` como no
  `Pacs008`. `Tax` fica de fora, mesma razão dos outros (ramo raro).
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pain013.V2_2

  @type versao :: :v2_2

  # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
  defstruct [
    :msg_id,
    :criado_em,
    :pmt_inf_id,
    :reqd_exctn_dt,
    :xpry_dt,
    :dbtr_cpf_cnpj,
    :dbtr_agt_ispb,
    :ultmt_dbtr_nome,
    :ultmt_dbtr_cpf_cnpj,
    :end_to_end_id,
    :valor,
    :mndt_id,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_conta_id,
    :cdtr_conta_issr,
    :cdtr_conta_tipo,
    :purp_prtry,
    :info_pagamento
  ]

  @type t :: %__MODULE__{}

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :pmt_inf_id,
    :xpry_dt,
    :dbtr_cpf_cnpj,
    :dbtr_agt_ispb,
    :end_to_end_id,
    :valor,
    :mndt_id,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_conta_id,
    :cdtr_conta_tipo,
    :purp_prtry
  ]

  @modulo_por_versao %{v2_2: V2_2}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v2_2] do
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

  @doc "Parseia um XML de pain.013 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_pain013, modulo.msg_def_idr()}}
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
      "CdtrPmtActvtnReq" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => formatar_data_hora(m.criado_em),
          "NbOfTxs" => "1",
          "InitgPty" => %{"Id" => %{"OrgId" => %{"Othr" => %{"Id" => String.duplicate("0", 14)}}}}
        },
        "PmtInf" => [termo_pmt_inf(m)]
      }
    }
  end

  defp termo_pmt_inf(m) do
    %{
      "PmtInfId" => m.pmt_inf_id,
      "PmtMtd" => "TRF",
      "XpryDt" => %{"Dt" => Date.to_iso8601(m.xpry_dt)},
      "Dbtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}},
      "DbtrAgt" => agente_termo(m.dbtr_agt_ispb),
      "CdtTrfTx" => termo_cdt_trf_tx(m)
    }
    |> talvez_por(
      "ReqdExctnDt",
      if(m.reqd_exctn_dt, do: %{"DtTm" => formatar_data_hora(m.reqd_exctn_dt)})
    )
    |> talvez_por("UltmtDbtr", ultmt_dbtr_termo(m))
  end

  defp termo_cdt_trf_tx(m) do
    %{
      "PmtId" => %{"EndToEndId" => m.end_to_end_id},
      "PmtTpInf" => %{
        "InstrPrty" => "NORM",
        "SvcLvl" => %{"Prtry" => "PAGAGD"},
        "LclInstrm" => %{"Prtry" => "AUTO"}
      },
      "Amt" => %{"InstdAmt" => %{valor: to_string(m.valor), atributos: %{"Ccy" => "BRL"}}},
      "ChrgBr" => "SLEV",
      "MndtRltdInf" => %{"MndtId" => m.mndt_id},
      "CdtrAgt" => agente_termo(m.cdtr_agt_ispb),
      "Cdtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}},
      "CdtrAcct" => %{
        "Id" => %{"Othr" => %{"Id" => m.cdtr_conta_id, "Issr" => m.cdtr_conta_issr}},
        "Tp" => %{"Cd" => m.cdtr_conta_tipo}
      },
      "Purp" => %{"Prtry" => m.purp_prtry}
    }
    |> talvez_por("RmtInf", if(m.info_pagamento, do: %{"Ustrd" => m.info_pagamento}))
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
    doc = get_in(termo, ["Document", "CdtrPmtActvtnReq"])
    grp = doc["GrpHdr"]
    [pmt_inf] = doc["PmtInf"]
    ultmt_dbtr = pmt_inf["UltmtDbtr"] || %{}
    tx = pmt_inf["CdtTrfTx"]
    cdtr_acct = tx["CdtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      pmt_inf_id: pmt_inf["PmtInfId"],
      reqd_exctn_dt: get_in(pmt_inf, ["ReqdExctnDt", "DtTm"]) |> parse_data_hora(),
      xpry_dt: get_in(pmt_inf, ["XpryDt", "Dt"]) |> parse_data(),
      dbtr_cpf_cnpj: get_in(pmt_inf, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_agt_ispb: get_in(pmt_inf, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      ultmt_dbtr_nome: ultmt_dbtr["Nm"],
      ultmt_dbtr_cpf_cnpj: get_in(ultmt_dbtr, ["Id", "PrvtId", "Othr", "Id"]),
      end_to_end_id: get_in(tx, ["PmtId", "EndToEndId"]),
      valor: get_in(tx, ["Amt", "InstdAmt", :valor]),
      mndt_id: get_in(tx, ["MndtRltdInf", "MndtId"]),
      cdtr_agt_ispb: get_in(tx, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_conta_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_conta_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_conta_tipo: get_in(cdtr_acct, ["Tp", "Cd"]),
      purp_prtry: get_in(tx, ["Purp", "Prtry"]),
      info_pagamento: get_in(tx, ["RmtInf", "Ustrd"])
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
