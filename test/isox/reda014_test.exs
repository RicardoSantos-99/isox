defmodule Isox.Reda014Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Reda014}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct" do
    message = %Reda014{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      cnpj: "12345678000199"
    }

    assert {:ok, xml} = Reda014.encode(message, @header, :v1_3)
    assert {:ok, de_volta, :v1_3} = Reda014.decode(xml)
    assert de_volta.ispb == "11111111"
    assert de_volta.cnpj == "12345678000199"
    assert xml =~ "<Prtry>IDRT</Prtry>"
    assert xml =~ "<Nm>CNPJIDRT</Nm>"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.014/1.3"><Nada/></Envelope>
    """

    assert {:error, _reason} = Reda014.decode(outro_xml)
  end
end
