defmodule PixSpiCatalog.Pacs008 do
  @moduledoc """
  Representação de domínio do pacs.008 (ordem de crédito), versões 1.15 e
  1.16 (ADR 0002) — campos com nome amigável em vez do mapa genérico cru
  que `PixSpiCatalog.Xml.Codec` produz.

  Cobre o caminho comum de uma ordem de crédito do Pix: os campos sempre
  obrigatórios da árvore real do XSD, mais os opcionais realmente usados
  (`InstrId`, `TxId`, `InitgPty`, `Prxy`/chave, `RmtInf.Ustrd`). Fica de
  fora `Tax` e `RmtInf.Strd` — ramos raros fora do fluxo padrão do Pix;
  quem precisar deles usa o codec genérico direto (`Registro`/`Codec`).

  `build/3` valida antes de montar: `Codec.build/3` confia no termo que
  recebe (não valida pattern/enum/obrigatoriedade), então essa camada
  confere os campos obrigatórios do domínio e, depois de montar o XML,
  faz o caminho de volta (`parse` do próprio módulo gerado) pra reaproveitar
  a validação de pattern/enum/cardinalidade que o parser já faz — sem
  duplicar regra nenhuma.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Pacs008.{V1_15, V1_16}

  @type versao :: :v1_15 | :v1_16

  defstruct [
    :msg_id,
    :criado_em,
    instr_prty: "NORM",
    svc_lvl_prtry: nil,
    end_to_end_id: nil,
    tx_id: nil,
    instr_id: nil,
    valor: nil,
    accptnc_dt_tm: nil,
    lcl_instrm: nil,
    initg_pty_id: nil,
    dbtr_nome: nil,
    dbtr_cpf_cnpj: nil,
    dbtr_conta_id: nil,
    dbtr_conta_issr: nil,
    dbtr_conta_tipo: "CACC",
    dbtr_agt_ispb: nil,
    cdtr_cpf_cnpj: nil,
    cdtr_conta_id: nil,
    cdtr_conta_issr: nil,
    cdtr_conta_tipo: "CACC",
    cdtr_conta_chave: nil,
    cdtr_agt_ispb: nil,
    purp_cd: nil,
    info_pagamento: nil
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          instr_prty: String.t(),
          svc_lvl_prtry: String.t(),
          end_to_end_id: String.t(),
          tx_id: String.t() | nil,
          instr_id: String.t() | nil,
          valor: String.t() | number(),
          accptnc_dt_tm: DateTime.t(),
          lcl_instrm: String.t(),
          initg_pty_id: String.t() | nil,
          dbtr_nome: String.t(),
          dbtr_cpf_cnpj: String.t(),
          dbtr_conta_id: String.t(),
          dbtr_conta_issr: String.t() | nil,
          dbtr_conta_tipo: String.t(),
          dbtr_agt_ispb: String.t(),
          cdtr_cpf_cnpj: String.t(),
          cdtr_conta_id: String.t(),
          cdtr_conta_issr: String.t() | nil,
          cdtr_conta_tipo: String.t(),
          cdtr_conta_chave: String.t() | nil,
          cdtr_agt_ispb: String.t(),
          purp_cd: String.t(),
          info_pagamento: String.t() | nil
        }

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :instr_prty,
    :svc_lvl_prtry,
    :end_to_end_id,
    :valor,
    :accptnc_dt_tm,
    :lcl_instrm,
    :dbtr_nome,
    :dbtr_cpf_cnpj,
    :dbtr_conta_id,
    :dbtr_conta_tipo,
    :dbtr_agt_ispb,
    :cdtr_cpf_cnpj,
    :cdtr_conta_id,
    :cdtr_conta_tipo,
    :cdtr_agt_ispb,
    :purp_cd
  ]

  @modulo_por_versao %{v1_15: V1_15, v1_16: V1_16}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao)
      when versao in [:v1_15, :v1_16] do
    with :ok <- validar_obrigatorios(mensagem),
         :ok <- validar_instr_id(mensagem, versao) do
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

  @doc "Parseia um XML de pacs.008 (qualquer versão) de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_pacs008, modulo.msg_def_idr()}}
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

  defp validar_instr_id(%{instr_id: nil}, _versao), do: :ok
  defp validar_instr_id(_mensagem, :v1_16), do: :ok
  defp validar_instr_id(_mensagem, _versao), do: {:error, "InstrId só é aceito na versão 1.16"}

  defp termo_document(m) do
    %{
      "FIToFICstmrCdtTrf" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => formatar_data_hora(m.criado_em),
          "NbOfTxs" => "1",
          "SttlmInf" => %{"SttlmMtd" => "CLRG"},
          "PmtTpInf" => %{
            "InstrPrty" => m.instr_prty,
            "SvcLvl" => %{"Prtry" => m.svc_lvl_prtry}
          }
        },
        "CdtTrfTxInf" => [termo_transacao(m)]
      }
    }
  end

  defp termo_transacao(m) do
    %{
      "PmtId" => %{
        "InstrId" => m.instr_id,
        "EndToEndId" => m.end_to_end_id,
        "TxId" => m.tx_id
      },
      "IntrBkSttlmAmt" => %{valor: to_string(m.valor), atributos: %{"Ccy" => "BRL"}},
      "AccptncDtTm" => formatar_data_hora(m.accptnc_dt_tm),
      "ChrgBr" => "SLEV",
      "MndtRltdInf" => %{"Tp" => %{"LclInstrm" => %{"Prtry" => m.lcl_instrm}}},
      "Dbtr" => %{
        "Nm" => m.dbtr_nome,
        "Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.dbtr_cpf_cnpj}}}
      },
      "DbtrAcct" => conta_termo(m.dbtr_conta_id, m.dbtr_conta_issr, m.dbtr_conta_tipo),
      "DbtrAgt" => agente_termo(m.dbtr_agt_ispb),
      "CdtrAgt" => agente_termo(m.cdtr_agt_ispb),
      "Cdtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}},
      "CdtrAcct" =>
        conta_termo(m.cdtr_conta_id, m.cdtr_conta_issr, m.cdtr_conta_tipo, m.cdtr_conta_chave),
      "Purp" => %{"Cd" => m.purp_cd}
    }
    |> talvez_por("InitgPty", initg_pty_termo(m.initg_pty_id))
    |> talvez_por("RmtInf", rmt_inf_termo(m.info_pagamento))
  end

  defp conta_termo(id, issr, tipo, chave \\ nil) do
    base = %{"Id" => %{"Othr" => %{"Id" => id, "Issr" => issr}}, "Tp" => %{"Cd" => tipo}}
    if chave, do: Map.put(base, "Prxy", %{"Id" => chave}), else: base
  end

  defp agente_termo(ispb) do
    %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}
  end

  defp initg_pty_termo(nil), do: nil
  defp initg_pty_termo(id), do: %{"Id" => %{"OrgId" => %{"Othr" => %{"Id" => id}}}}

  defp rmt_inf_termo(nil), do: nil
  defp rmt_inf_termo(texto), do: %{"Ustrd" => texto}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "FIToFICstmrCdtTrf"])
    grp = doc["GrpHdr"]
    [tx] = doc["CdtTrfTxInf"]
    pmt_id = tx["PmtId"]
    dbtr_acct = tx["DbtrAcct"]
    cdtr_acct = tx["CdtrAcct"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      criado_em: parse_data_hora(grp["CreDtTm"]),
      instr_prty: get_in(grp, ["PmtTpInf", "InstrPrty"]),
      svc_lvl_prtry: get_in(grp, ["PmtTpInf", "SvcLvl", "Prtry"]),
      end_to_end_id: pmt_id["EndToEndId"],
      tx_id: pmt_id["TxId"],
      instr_id: pmt_id["InstrId"],
      valor: get_in(tx, ["IntrBkSttlmAmt", :valor]),
      accptnc_dt_tm: parse_data_hora(tx["AccptncDtTm"]),
      lcl_instrm: get_in(tx, ["MndtRltdInf", "Tp", "LclInstrm", "Prtry"]),
      initg_pty_id: get_in(tx, ["InitgPty", "Id", "OrgId", "Othr", "Id"]),
      dbtr_nome: get_in(tx, ["Dbtr", "Nm"]),
      dbtr_cpf_cnpj: get_in(tx, ["Dbtr", "Id", "PrvtId", "Othr", "Id"]),
      dbtr_conta_id: get_in(dbtr_acct, ["Id", "Othr", "Id"]),
      dbtr_conta_issr: get_in(dbtr_acct, ["Id", "Othr", "Issr"]),
      dbtr_conta_tipo: get_in(dbtr_acct, ["Tp", "Cd"]),
      dbtr_agt_ispb: get_in(tx, ["DbtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_agt_ispb: get_in(tx, ["CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["Cdtr", "Id", "PrvtId", "Othr", "Id"]),
      cdtr_conta_id: get_in(cdtr_acct, ["Id", "Othr", "Id"]),
      cdtr_conta_issr: get_in(cdtr_acct, ["Id", "Othr", "Issr"]),
      cdtr_conta_tipo: get_in(cdtr_acct, ["Tp", "Cd"]),
      cdtr_conta_chave: get_in(cdtr_acct, ["Prxy", "Id"]),
      purp_cd: get_in(tx, ["Purp", "Cd"]),
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
end
