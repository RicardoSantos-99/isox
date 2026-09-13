defmodule Isox.Reda016Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Reda016}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @message %Reda016{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
    orgnl_msg_id: "M123456780123456789abcdefghijklo",
    sts: "COMP"
  }

  test "sucesso: sts COMP com SysPtyId obrigatório, sem motivo" do
    message = %{@message | sys_pty_ispb: "22222222"}

    assert {:ok, xml} = Reda016.encode(message, @header, :v1_5)
    assert {:ok, de_volta, :v1_5} = Reda016.decode(xml)

    assert de_volta.sts == "COMP"
    assert de_volta.rsn_prtry == nil
    assert de_volta.sys_pty_ispb == "22222222"
    refute xml =~ "StsRsn"
  end

  test "rejeição: motivo presente" do
    message = %{@message | sts: "REJT", rsn_prtry: "IND2"}

    assert {:ok, xml} = Reda016.encode(message, @header, :v1_5)
    assert {:ok, de_volta, :v1_5} = Reda016.decode(xml)
    assert de_volta.rsn_prtry == "IND2"
  end

  test "sucesso com participante responsável (indireto sob direto)" do
    message = %{@message | sys_pty_ispb: "22222222", rspnsbl_pty_ispb: "11111111"}

    assert {:ok, xml} = Reda016.encode(message, @header, :v1_5)
    assert {:ok, de_volta, :v1_5} = Reda016.decode(xml)
    assert de_volta.sys_pty_ispb == "22222222"
    assert de_volta.rspnsbl_pty_ispb == "11111111"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.016/1.5"><Nada/></Envelope>
    """

    assert {:error, _reason} = Reda016.decode(outro_xml)
  end

  test "fila (QUED): motivo presente, igual à rejeição" do
    message = %{@message | sts: "QUED", rsn_prtry: "EXP5"}

    assert {:ok, xml} = Reda016.encode(message, @header, :v1_5)
    assert {:ok, de_volta, :v1_5} = Reda016.decode(xml)
    assert de_volta.sts == "QUED"
    assert de_volta.rsn_prtry == "EXP5"
  end

  test "COMP com rsn_prtry preenchido é rejeitado" do
    message = %{@message | sys_pty_ispb: "22222222", rsn_prtry: "IND2"}

    assert {:error, reason} = Reda016.encode(message, @header, :v1_5)
    assert reason =~ "rsn_prtry"
  end

  test "COMP sem sys_pty_ispb é rejeitado" do
    assert {:error, reason} = Reda016.encode(@message, @header, :v1_5)
    assert reason =~ "sys_pty_ispb"
  end

  test "REJT/QUED sem rsn_prtry é rejeitado" do
    message = %{@message | sts: "REJT", rsn_prtry: nil}
    assert {:error, reason} = Reda016.encode(message, @header, :v1_5)
    assert reason =~ "rsn_prtry"

    message = %{@message | sts: "QUED", rsn_prtry: nil}
    assert {:error, _reason} = Reda016.encode(message, @header, :v1_5)
  end

  test "REJT/QUED com sys_pty_ispb preenchido é rejeitado" do
    message = %{@message | sts: "REJT", rsn_prtry: "IND2", sys_pty_ispb: "22222222"}
    assert {:error, reason} = Reda016.encode(message, @header, :v1_5)
    assert reason =~ "sys_pty_ispb"
  end

  test "rspnsbl_pty_ispb sem sys_pty_ispb é rejeitado" do
    message = %{@message | sts: "REJT", rsn_prtry: "IND2", rspnsbl_pty_ispb: "11111111"}
    assert {:error, reason} = Reda016.encode(message, @header, :v1_5)
    assert reason =~ "rspnsbl_pty_ispb"
  end
end
