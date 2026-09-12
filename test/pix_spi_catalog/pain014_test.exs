defmodule PixSpiCatalog.Pain014Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pain014}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "11111111",
    ispb_destino: "22222222",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Pain014{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    orgnl_pmt_inf_id: "PMTINF001",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    tx_sts: "ACSP",
    dbtr_dcsn_dt_tm: @agora,
    cdtr_agt_ispb: "22222222",
    cdtr_cpf_cnpj: "98765432100"
  }

  test "aceite, sem motivo, monta e volta pra struct" do
    assert {:ok, xml} = Pain014.build(@mensagem, @cabecalho, :v2_4)
    assert {:ok, de_volta, :v2_4} = Pain014.parse(xml)

    assert de_volta.orgnl_end_to_end_id == @mensagem.orgnl_end_to_end_id
    assert de_volta.tx_sts == "ACSP"
    assert de_volta.rsn_prtry == nil
    assert xml =~ ~s(<OrgnlMsgId>#{String.duplicate("0", 32)}</OrgnlMsgId>)
    refute xml =~ "StsRsnInf"
  end

  test "rejeição com motivo, e 2.3 também funciona" do
    mensagem = %{@mensagem | tx_sts: "RJCT", rsn_prtry: "AC05"}

    assert {:ok, xml} = Pain014.build(mensagem, @cabecalho, :v2_3)
    assert {:ok, de_volta, :v2_3} = Pain014.parse(xml)
    assert de_volta.tx_sts == "RJCT"
    assert de_volta.rsn_prtry == "AC05"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | dbtr_dcsn_dt_tm: nil}
    assert {:error, motivo} = Pain014.build(mensagem, @cabecalho, :v2_4)
    assert motivo =~ "dbtr_dcsn_dt_tm"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pain.014/2.4"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pain014.parse(outro_xml)
  end
end
