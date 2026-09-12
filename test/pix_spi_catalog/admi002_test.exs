defmodule PixSpiCatalog.Admi002Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{Admi002, AppHdr}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "12345678",
    to_ispb: "87654321",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Admi002{
    ref: 24 |> :crypto.strong_rand_bytes() |> Base.encode64(),
    rjctg_pty_rsn: "XML malformado"
  }

  test "monta e volta pra struct, só com o obrigatório" do
    assert {:ok, xml} = Admi002.build(@message, @header, :v1_5)
    assert {:ok, message, :v1_5} = Admi002.parse(xml)

    assert message.ref == @message.ref
    assert message.rjctg_pty_rsn == @message.rjctg_pty_rsn
    assert message.rjctn_dt_tm == nil
    assert message.err_lctn == nil
  end

  test "ref referencia o PI-ResourceId da mensagem recusada" do
    resource_id = 24 |> :crypto.strong_rand_bytes() |> Base.encode64()
    message = %{@message | ref: resource_id}

    assert {:ok, xml} = Admi002.build(message, @header, :v1_5)
    assert {:ok, de_volta, :v1_5} = Admi002.parse(xml)
    assert de_volta.ref == resource_id
  end

  test "campos opcionais de motivo vão e voltam quando presentes" do
    message = %{
      @message
      | rjctn_dt_tm: @agora,
        err_lctn: "Document/CdtTrfTxInf[1]/IntrBkSttlmAmt",
        rsn_desc: "valor não bate com o padrão esperado",
        addtl_data: "detalhe extra pra depuração"
    }

    assert {:ok, xml} = Admi002.build(message, @header, :v1_5)
    assert {:ok, de_volta, :v1_5} = Admi002.parse(xml)

    assert de_volta.rjctn_dt_tm == @agora
    assert de_volta.err_lctn == message.err_lctn
    assert de_volta.rsn_desc == message.rsn_desc
    assert de_volta.addtl_data == message.addtl_data
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | rjctg_pty_rsn: nil}

    assert {:error, reason} = Admi002.build(message, @header, :v1_5)
    assert reason =~ "rjctg_pty_rsn"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/admi.002/1.5"><Nada/></Envelope>
    """

    assert {:error, _reason} = Admi002.parse(outro_xml)
  end
end
