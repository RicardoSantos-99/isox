defmodule PixSpiCatalog.Reda017Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Reda017}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  test "monta e volta pra struct" do
    mensagem = %Reda017{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: @agora,
      ispb: "11111111",
      prazo_confi: @agora
    }

    assert {:ok, xml} = Reda017.build(mensagem, @cabecalho, :v1_2)
    assert {:ok, de_volta, :v1_2} = Reda017.parse(xml)
    assert de_volta.ispb == "11111111"
    assert de_volta.prazo_confi == @agora
    assert xml =~ "<Nm>PRAZOCONFI</Nm>"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.017/1.2"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Reda017.parse(outro_xml)
  end
end
