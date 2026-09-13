defmodule Isox.Pibr001Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Pibr001}

  @header %AppHdr{
    from_ispb: "11111111",
    to_ispb: "22222222",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct" do
    message = %Pibr001{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      data: "ping-123"
    }

    assert {:ok, xml} = Pibr001.encode(message, @header, :v1_3)
    assert {:ok, de_volta, :v1_3} = Pibr001.decode(xml)
    assert de_volta.data == "ping-123"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pibr.001/1.3"><Nada/></Envelope>
    """

    assert {:error, _reason} = Pibr001.decode(outro_xml)
  end
end
