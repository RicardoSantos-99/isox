defmodule Isox.Camt029Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Camt029}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "22222222",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Camt029{
    assgnmt_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    assgnr_ispb: "22222222",
    assgne_ispb: "11111111",
    orgnl_pmt_inf_cxl_id: "CA1234567820260912abcdefghijk",
    orgnl_pmt_inf_id: "PMTINFO001",
    pmt_inf_cxl_sts: "ACCR",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    cxl_prcg_tp: "DHAC",
    prcg_dt_tm: @agora
  }

  test "aceite, sem reason, monta e volta pra struct" do
    assert {:ok, xml} = Camt029.encode(@message, @header, :v1_1)
    assert {:ok, de_volta, :v1_1} = Camt029.decode(xml)
    assert de_volta == @message
    refute xml =~ "CxlStsRsnInf"
  end

  test "rejeição com reason" do
    message = %{@message | pmt_inf_cxl_sts: "RJCR", rsn_prtry: "CH16"}

    assert {:ok, xml} = Camt029.encode(message, @header, :v1_2)
    assert {:ok, de_volta, :v1_2} = Camt029.decode(xml)
    assert de_volta.rsn_prtry == "CH16"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | orgnl_pmt_inf_cxl_id: nil}
    assert {:error, reason} = Camt029.encode(message, @header, :v1_1)
    assert reason =~ "orgnl_pmt_inf_cxl_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.029/1.2"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt029.decode(outro_xml)
  end
end
