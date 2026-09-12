defmodule PixSpiCatalog.Pain014Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pain014}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "11111111",
    to_ispb: "22222222",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Pain014{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    orgnl_pmt_inf_id: "PMTINF001",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    tx_sts: "ACSP",
    dbtr_dcsn_dt_tm: @agora,
    cdtr_agt_ispb: "22222222",
    cdtr_cpf_cnpj: "98765432100"
  }

  test "aceite, sem reason, monta e volta pra struct" do
    assert {:ok, xml} = Pain014.build(@message, @header, :v2_4)
    assert {:ok, de_volta, :v2_4} = Pain014.parse(xml)

    assert de_volta.orgnl_end_to_end_id == @message.orgnl_end_to_end_id
    assert de_volta.tx_sts == "ACSP"
    assert de_volta.rsn_prtry == nil
    assert xml =~ ~s(<OrgnlMsgId>#{String.duplicate("0", 32)}</OrgnlMsgId>)
    refute xml =~ "StsRsnInf"
  end

  test "rejeição com reason, e 2.3 também funciona" do
    message = %{@message | tx_sts: "RJCT", rsn_prtry: "AC05"}

    assert {:ok, xml} = Pain014.build(message, @header, :v2_3)
    assert {:ok, de_volta, :v2_3} = Pain014.parse(xml)
    assert de_volta.tx_sts == "RJCT"
    assert de_volta.rsn_prtry == "AC05"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | dbtr_dcsn_dt_tm: nil}
    assert {:error, reason} = Pain014.build(message, @header, :v2_4)
    assert reason =~ "dbtr_dcsn_dt_tm"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pain.014/2.4"><Nada/></Envelope>
    """

    assert {:error, _reason} = Pain014.parse(outro_xml)
  end
end
