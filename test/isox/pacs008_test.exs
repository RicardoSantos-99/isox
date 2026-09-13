defmodule Isox.Pacs008Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Pacs008}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "12345678",
    to_ispb: "87654321",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Pacs008{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    svc_lvl_prtry: "PAGPRI",
    end_to_end_id: "E12345678202609121030abcdefghijk",
    value: "150.00",
    accptnc_dt_tm: @agora,
    lcl_instrm: "MANU",
    dbtr_name: "Fulano de Tal",
    dbtr_cpf_cnpj: "12345678901",
    dbtr_acct_id: "00012345",
    dbtr_agt_ispb: "12345678",
    cdtr_cpf_cnpj: "12345678000199",
    cdtr_acct_id: "00098765",
    cdtr_agt_ispb: "87654321",
    purp_cd: "IPAY"
  }

  test "monta e volta pra struct em 1.15 (sem InstrId)" do
    assert {:ok, xml} = Pacs008.encode(@message, @header, :v1_15)
    assert {:ok, message, :v1_15} = Pacs008.decode(xml)

    assert message.instr_id == nil
    assert message.end_to_end_id == @message.end_to_end_id
    assert message.dbtr_name == @message.dbtr_name
    assert message.value == "150.00"
  end

  test "monta e volta pra struct em 1.16, com InstrId" do
    message = %{@message | instr_id: "E12345678202609121030abcdefghijl"}

    assert {:ok, xml} = Pacs008.encode(message, @header, :v1_16)
    assert {:ok, de_volta, :v1_16} = Pacs008.decode(xml)

    assert de_volta.instr_id == message.instr_id
  end

  test "InstrId só é aceito na versão 1.16" do
    message = %{@message | instr_id: "E12345678202609121030abcdefghijl"}

    assert {:error, reason} = Pacs008.encode(message, @header, :v1_15)
    assert reason =~ "1.16"
  end

  test "campos opcionais (InitgPty, TxId, RmtInf, chave do recebedor) vão e voltam quando presentes" do
    message = %{
      @message
      | tx_id: "TX0001",
        initg_pty_id: "98765432000111",
        cdtr_acct_proxy: "fulano@example.com",
        rmt_inf: "pagamento de teste"
    }

    assert {:ok, xml} = Pacs008.encode(message, @header, :v1_16)
    assert {:ok, de_volta, :v1_16} = Pacs008.decode(xml)

    assert de_volta.tx_id == "TX0001"
    assert de_volta.initg_pty_id == "98765432000111"
    assert de_volta.cdtr_acct_proxy == "fulano@example.com"
    assert de_volta.rmt_inf == "pagamento de teste"
  end

  test "campos opcionais ausentes não aparecem na volta" do
    assert {:ok, xml} = Pacs008.encode(@message, @header, :v1_16)
    assert {:ok, de_volta, :v1_16} = Pacs008.decode(xml)

    assert de_volta.tx_id == nil
    assert de_volta.initg_pty_id == nil
    assert de_volta.cdtr_acct_proxy == nil
    assert de_volta.rmt_inf == nil
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | dbtr_name: nil}

    assert {:error, reason} = Pacs008.encode(message, @header, :v1_16)
    assert reason =~ "dbtr_name"
  end

  test "valor que não bate com o padrão do campo é rejeitado" do
    message = %{@message | dbtr_cpf_cnpj: "não é um cpf"}

    assert {:error, _reason} = Pacs008.encode(message, @header, :v1_16)
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pacs.008/1.16"><Nada/></Envelope>
    """

    assert {:error, _reason} = Pacs008.decode(outro_xml)
  end
end
