defmodule PixSpiCatalog.Pain013Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pain013}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "22222222",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Pain013{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    pmt_inf_id: "PMTINF001",
    xpry_dt: ~D[2026-12-31],
    dbtr_cpf_cnpj: "12345678901",
    dbtr_agt_ispb: "11111111",
    end_to_end_id: "E12345678202609121030abcdefghijk",
    valor: "100.00",
    mndt_id: "RR1234567820260912abcdefghijk",
    cdtr_agt_ispb: "22222222",
    cdtr_cpf_cnpj: "98765432100",
    cdtr_conta_id: "54321",
    cdtr_conta_tipo: "CACC",
    purp_prtry: "AGND"
  }

  test "só com o obrigatório, monta e volta pra struct" do
    assert {:ok, xml} = Pain013.build(@mensagem, @cabecalho, :v2_2)
    assert {:ok, de_volta, :v2_2} = Pain013.parse(xml)

    assert de_volta.end_to_end_id == @mensagem.end_to_end_id
    assert de_volta.valor == "100.00"
    assert de_volta.mndt_id == @mensagem.mndt_id
    assert xml =~ "<PmtMtd>TRF</PmtMtd>"
    assert xml =~ "<InstrPrty>NORM</InstrPrty>"
    assert xml =~ "<Prtry>PAGAGD</Prtry>"
    assert xml =~ ~s(<Othr><Id>00000000000000</Id></Othr>)
    refute xml =~ "ReqdExctnDt"
    refute xml =~ "UltmtDbtr"
  end

  test "com data de execução, devedor final e remessa opcionais" do
    mensagem = %{
      @mensagem
      | reqd_exctn_dt: @agora,
        ultmt_dbtr_nome: "Empresa Final Ltda",
        ultmt_dbtr_cpf_cnpj: "12345678000199",
        info_pagamento: "pagamento agendado"
    }

    assert {:ok, xml} = Pain013.build(mensagem, @cabecalho, :v2_2)
    assert {:ok, de_volta, :v2_2} = Pain013.parse(xml)

    assert de_volta.reqd_exctn_dt == @agora
    assert de_volta.ultmt_dbtr_nome == "Empresa Final Ltda"
    assert de_volta.info_pagamento == "pagamento agendado"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | mndt_id: nil}
    assert {:error, motivo} = Pain013.build(mensagem, @cabecalho, :v2_2)
    assert motivo =~ "mndt_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pain.013/2.2"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pain013.parse(outro_xml)
  end
end
