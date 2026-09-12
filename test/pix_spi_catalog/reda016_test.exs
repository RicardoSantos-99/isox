defmodule PixSpiCatalog.Reda016Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Reda016}

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @mensagem %Reda016{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
    orgnl_msg_id: "M123456780123456789abcdefghijklo",
    sts: "COMP"
  }

  test "sucesso: só sts + correlação, sem motivo nem SysPtyId" do
    assert {:ok, xml} = Reda016.build(@mensagem, @cabecalho, :v1_5)
    assert {:ok, de_volta, :v1_5} = Reda016.parse(xml)

    assert de_volta.sts == "COMP"
    assert de_volta.rsn_prtry == nil
    assert de_volta.sys_pty_ispb == nil
    refute xml =~ "StsRsn"
    refute xml =~ "SysPtyId"
  end

  test "rejeição: motivo presente" do
    mensagem = %{@mensagem | sts: "REJT", rsn_prtry: "IND2"}

    assert {:ok, xml} = Reda016.build(mensagem, @cabecalho, :v1_5)
    assert {:ok, de_volta, :v1_5} = Reda016.parse(xml)
    assert de_volta.rsn_prtry == "IND2"
  end

  test "sucesso com participante responsável (indireto sob direto)" do
    mensagem = %{@mensagem | sys_pty_ispb: "22222222", rspnsbl_pty_ispb: "11111111"}

    assert {:ok, xml} = Reda016.build(mensagem, @cabecalho, :v1_5)
    assert {:ok, de_volta, :v1_5} = Reda016.parse(xml)
    assert de_volta.sys_pty_ispb == "22222222"
    assert de_volta.rspnsbl_pty_ispb == "11111111"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.016/1.5"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Reda016.parse(outro_xml)
  end
end
