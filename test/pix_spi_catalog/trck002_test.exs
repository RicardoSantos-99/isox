defmodule PixSpiCatalog.Trck002Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Trck002}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "11111111",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Trck002{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    end_to_end_id: "E12345678202609121030abcdefghijk",
    lcl_instrm: "MANU",
    pmt_scnro_prtry: "BOK1",
    valor: "150.00",
    reqd_exctn_dt: @agora,
    dbtr_cpf_cnpj: "12345678901",
    dbtr_conta_id: "00012345",
    dbtr_conta_tipo: "CACC",
    dbtr_agt_ispb: "11111111",
    cdtr_agt_ispb: "11111111",
    cdtr_cpf_cnpj: "12345678901",
    cdtr_conta_id: "00098765",
    cdtr_conta_tipo: "SVGS"
  }

  test "monta e volta pra struct, só com o obrigatório" do
    assert {:ok, xml} = Trck002.build(@mensagem, @cabecalho, :v1_1)
    assert {:ok, de_volta, :v1_1} = Trck002.parse(xml)

    assert de_volta.end_to_end_id == @mensagem.end_to_end_id
    assert de_volta.pmt_scnro_prtry == "BOK1"
    assert de_volta.instr_id == nil
    assert xml =~ "<Sts>ACCC</Sts>"
  end

  test "com InstrId e chave do recebedor, opcionais" do
    mensagem = %{
      @mensagem
      | instr_id: "D12345678202609121030abcdefghijk",
        cdtr_conta_chave: "fulano@example.com"
    }

    assert {:ok, xml} = Trck002.build(mensagem, @cabecalho, :v1_1)
    assert {:ok, de_volta, :v1_1} = Trck002.parse(xml)
    assert de_volta.instr_id == mensagem.instr_id
    assert de_volta.cdtr_conta_chave == "fulano@example.com"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | dbtr_cpf_cnpj: nil}
    assert {:error, motivo} = Trck002.build(mensagem, @cabecalho, :v1_1)
    assert motivo =~ "dbtr_cpf_cnpj"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/trck.002/1.1"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Trck002.parse(outro_xml)
  end
end
