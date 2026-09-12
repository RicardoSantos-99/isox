defmodule PixSpiCatalog.Admi004Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{Admi004, AppHdr}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct" do
    message = %Admi004{description: "mudança da data contábil às 20h"}

    assert {:ok, xml} = Admi004.build(message, @header, :v1_2)
    assert {:ok, de_volta, :v1_2} = Admi004.parse(xml)
    assert de_volta.description == message.description
    assert xml =~ "<EvtCd>SPI</EvtCd>"
  end

  test "descrição ausente é rejeitada antes de montar XML" do
    assert {:error, reason} = Admi004.build(%Admi004{}, @header, :v1_2)
    assert reason =~ "description"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/admi.004/1.2"><Nada/></Envelope>
    """

    assert {:error, _reason} = Admi004.parse(outro_xml)
  end
end
