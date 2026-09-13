defmodule Isox.Pibr002Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Pibr002}

  @header %AppHdr{
    from_ispb: "22222222",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct, ecoando o dado original" do
    message = %Pibr002{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      orgnl_data: "ping-123"
    }

    assert {:ok, xml} = Pibr002.encode(message, @header, :v1_3)
    assert {:ok, de_volta, :v1_3} = Pibr002.decode(xml)
    assert de_volta.orgnl_data == "ping-123"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pibr.002/1.3"><Nada/></Envelope>
    """

    assert {:error, _reason} = Pibr002.decode(outro_xml)
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %Pibr002{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      orgnl_data: nil
    }

    assert {:error, reason} = Pibr002.encode(message, @header, :v1_3)
    assert reason =~ "orgnl_data"
  end

  test "orgnl_data além do máximo de 35 caracteres é rejeitado" do
    message = %Pibr002{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      orgnl_data: String.duplicate("a", 36)
    }

    assert {:error, _reason} = Pibr002.encode(message, @header, :v1_3)
  end
end
