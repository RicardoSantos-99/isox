defmodule PixSpiCatalog.Reda031Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Reda031}

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct" do
    mensagem = %Reda031{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111"
    }

    assert {:ok, xml} = Reda031.build(mensagem, @cabecalho, :v1_2)
    assert {:ok, de_volta, :v1_2} = Reda031.parse(xml)
    assert de_volta.ispb == "11111111"
    assert xml =~ "<Issr>BCB</Issr>"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.031/1.2"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Reda031.parse(outro_xml)
  end
end
