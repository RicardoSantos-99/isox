defmodule Isox.Camt055Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Camt055}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "11111111",
    to_ispb: "22222222",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Camt055{
    assgnmt_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    assgnr_ispb: "11111111",
    assgne_ispb: "22222222",
    pmt_cxl_id: "CA1234567820260912abcdefghijk",
    orgnl_pmt_inf_id: "PMTINFO001",
    orgtr_cpf_cnpj: "12345678901",
    rsn_prtry: "CCLD",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    cxl_prcg_tp: "DHIP",
    prcg_dt_tm: @agora
  }

  test "monta e volta pra struct" do
    assert {:ok, xml} = Camt055.encode(@message, @header, :v1_1)
    assert {:ok, de_volta, :v1_1} = Camt055.decode(xml)
    assert de_volta == @message
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | orgnl_end_to_end_id: nil}
    assert {:error, reason} = Camt055.encode(message, @header, :v1_1)
    assert reason =~ "orgnl_end_to_end_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.055/1.1"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt055.decode(outro_xml)
  end
end
