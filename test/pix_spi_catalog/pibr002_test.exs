defmodule PixSpiCatalog.Pibr002Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pibr002}

  @cabecalho %AppHdr{
    ispb_origem: "22222222",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct, ecoando o dado original" do
    mensagem = %Pibr002{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      orgnl_data: "ping-123"
    }

    assert {:ok, xml} = Pibr002.build(mensagem, @cabecalho, :v1_3)
    assert {:ok, de_volta, :v1_3} = Pibr002.parse(xml)
    assert de_volta.orgnl_data == "ping-123"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pibr.002/1.3"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pibr002.parse(outro_xml)
  end
end
