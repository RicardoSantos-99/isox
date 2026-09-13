defmodule Isox.Trck002Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Trck002}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "11111111",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Trck002{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    end_to_end_id: "E12345678202609121030abcdefghijk",
    lcl_instrm: "MANU",
    pmt_scnro_prtry: "BOK1",
    value: "150.00",
    reqd_exctn_dt: @agora,
    dbtr_cpf_cnpj: "12345678901",
    dbtr_acct_id: "00012345",
    dbtr_acct_type: "CACC",
    dbtr_agt_ispb: "11111111",
    cdtr_agt_ispb: "11111111",
    cdtr_cpf_cnpj: "12345678901",
    cdtr_acct_id: "00098765",
    cdtr_acct_type: "SVGS"
  }

  test "monta e volta pra struct, só com o obrigatório" do
    assert {:ok, xml} = Trck002.encode(@message, @header, :v1_1)
    assert {:ok, de_volta, :v1_1} = Trck002.decode(xml)

    assert de_volta.end_to_end_id == @message.end_to_end_id
    assert de_volta.pmt_scnro_prtry == "BOK1"
    assert de_volta.instr_id == nil
    assert xml =~ "<Sts>ACCC</Sts>"
  end

  test "com InstrId e chave do recebedor, opcionais" do
    message = %{
      @message
      | instr_id: "D12345678202609121030abcdefghijk",
        cdtr_acct_proxy: "fulano@example.com"
    }

    assert {:ok, xml} = Trck002.encode(message, @header, :v1_1)
    assert {:ok, de_volta, :v1_1} = Trck002.decode(xml)
    assert de_volta.instr_id == message.instr_id
    assert de_volta.cdtr_acct_proxy == "fulano@example.com"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | dbtr_cpf_cnpj: nil}
    assert {:error, reason} = Trck002.encode(message, @header, :v1_1)
    assert reason =~ "dbtr_cpf_cnpj"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/trck.002/1.1"><Nada/></Envelope>
    """

    assert {:error, _reason} = Trck002.decode(outro_xml)
  end
end
