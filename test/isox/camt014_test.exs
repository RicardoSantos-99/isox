defmodule Isox.Camt014Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Camt014}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @message %Camt014{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
    mmb_id_ispb: "11111111",
    mmb_nm: "Banco Exemplo S.A.",
    mmb_rtr_adr: "12345678000199",
    mmb_tp_cd: "DRCT",
    mmb_sts_cd: "ENBL",
    full_lgl_nm: "Banco Exemplo Sociedade Anônima",
    role_plyr_prtry: "ITUS"
  }

  test "monta e volta pra struct" do
    assert {:ok, xml} = Camt014.encode(@message, @header, :v1_6)
    assert {:ok, de_volta, :v1_6} = Camt014.decode(xml)
    assert de_volta == @message
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | mmb_nm: nil}
    assert {:error, reason} = Camt014.encode(message, @header, :v1_6)
    assert reason =~ "mmb_nm"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.014/1.6"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt014.decode(outro_xml)
  end
end
