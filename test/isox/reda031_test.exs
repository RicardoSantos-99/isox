defmodule Isox.Reda031Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Reda031}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct" do
    message = %Reda031{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111"
    }

    assert {:ok, xml} = Reda031.encode(message, @header, :v1_2)
    assert {:ok, de_volta, :v1_2} = Reda031.decode(xml)
    assert de_volta.ispb == "11111111"
    assert xml =~ "<Issr>BCB</Issr>"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.031/1.2"><Nada/></Envelope>
    """

    assert {:error, _reason} = Reda031.decode(outro_xml)
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %Reda031{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: nil
    }

    assert {:error, reason} = Reda031.encode(message, @header, :v1_2)
    assert reason =~ "ispb"
  end
end
