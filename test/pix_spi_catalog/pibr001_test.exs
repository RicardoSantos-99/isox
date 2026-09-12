defmodule PixSpiCatalog.Pibr001Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pibr001}

  @cabecalho %AppHdr{
    ispb_origem: "11111111",
    ispb_destino: "22222222",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct" do
    mensagem = %Pibr001{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      data: "ping-123"
    }

    assert {:ok, xml} = Pibr001.build(mensagem, @cabecalho, :v1_3)
    assert {:ok, de_volta, :v1_3} = Pibr001.parse(xml)
    assert de_volta.data == "ping-123"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pibr.001/1.3"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pibr001.parse(outro_xml)
  end
end
