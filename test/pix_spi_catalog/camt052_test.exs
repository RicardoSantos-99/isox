defmodule PixSpiCatalog.Camt052Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Camt052}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @message %Camt052{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
    rpt_id: "M123456780123456789abcdefghijkln",
    acct_ispb: "11111111",
    nb_of_ntries: "42",
    addtl_rpt_inf: "42 lancamentos no periodo"
  }

  test "monta e volta pra struct" do
    assert {:ok, xml} = Camt052.build(@message, @header, :v1_3)
    assert {:ok, de_volta, :v1_3} = Camt052.parse(xml)
    assert de_volta == @message
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | acct_ispb: nil}
    assert {:error, reason} = Camt052.build(message, @header, :v1_3)
    assert reason =~ "acct_ispb"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.052/1.3"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt052.parse(outro_xml)
  end
end
