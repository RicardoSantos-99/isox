defmodule PixSpiCatalog.Camt029Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Camt029}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "22222222",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Camt029{
    assgnmt_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    assgnr_ispb: "22222222",
    assgne_ispb: "11111111",
    orgnl_pmt_inf_cxl_id: "CA1234567820260912abcdefghijk",
    orgnl_pmt_inf_id: "PMTINFO001",
    pmt_inf_cxl_sts: "ACCR",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    cxl_prcg_tp: "DHAC",
    prcg_dt_tm: @agora
  }

  test "aceite, sem motivo, monta e volta pra struct" do
    assert {:ok, xml} = Camt029.build(@mensagem, @cabecalho, :v1_1)
    assert {:ok, de_volta, :v1_1} = Camt029.parse(xml)
    assert de_volta == @mensagem
    refute xml =~ "CxlStsRsnInf"
  end

  test "rejeição com motivo" do
    mensagem = %{@mensagem | pmt_inf_cxl_sts: "RJCR", rsn_prtry: "CH16"}

    assert {:ok, xml} = Camt029.build(mensagem, @cabecalho, :v1_2)
    assert {:ok, de_volta, :v1_2} = Camt029.parse(xml)
    assert de_volta.rsn_prtry == "CH16"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | orgnl_pmt_inf_cxl_id: nil}
    assert {:error, motivo} = Camt029.build(mensagem, @cabecalho, :v1_1)
    assert motivo =~ "orgnl_pmt_inf_cxl_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.029/1.2"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Camt029.parse(outro_xml)
  end
end
