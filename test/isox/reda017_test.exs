defmodule Isox.Reda017Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Reda017}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  test "monta e volta pra struct" do
    message = %Reda017{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: @agora,
      ispb: "11111111",
      confirmation_deadline: @agora
    }

    assert {:ok, xml} = Reda017.encode(message, @header, :v1_2)
    assert {:ok, de_volta, :v1_2} = Reda017.decode(xml)
    assert de_volta.ispb == "11111111"
    assert de_volta.confirmation_deadline == @agora
    assert xml =~ "<Nm>PRAZOCONFI</Nm>"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.017/1.2"><Nada/></Envelope>
    """

    assert {:error, _reason} = Reda017.decode(outro_xml)
  end
end
