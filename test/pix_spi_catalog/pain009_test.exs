defmodule PixSpiCatalog.Pain009Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pain009}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "22222222",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Pain009{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    mndt_id: "RR1234567820260912abcdefghijk",
    mndt_req_id: "SC1234567820260912abcdefghijk",
    frqcy_tp: "MNTH",
    frst_colltn_dt: ~D[2026-09-12],
    trckg_ind: "true",
    cdtr_nome: "Fulano Recebedor",
    cdtr_cpf_cnpj: "12345678901",
    cdtr_agt_ispb: "11111111",
    dbtr_cpf_cnpj: "98765432100",
    dbtr_conta_id: "12345",
    dbtr_agt_ispb: "22222222",
    rfrd_doc_nb: "DOC001",
    mndt_prcg_dtls: [
      %{tp: "CRTN", dt_tm: @agora},
      %{tp: "CRAT", dt_tm: @agora},
      %{tp: "EXPR", dt_tm: @agora}
    ]
  }

  test "monta e volta pra struct, só com o obrigatório" do
    assert {:ok, xml} = Pain009.build(@mensagem, @cabecalho, :v1_1)
    assert {:ok, de_volta, :v1_1} = Pain009.parse(xml)

    assert de_volta.mndt_id == @mensagem.mndt_id
    assert de_volta.frqcy_tp == "MNTH"
    assert de_volta.frst_colltn_dt == ~D[2026-09-12]
    assert de_volta.mndt_prcg_dtls == @mensagem.mndt_prcg_dtls
    assert xml =~ "<SeqTp>RCUR</SeqTp>"
    refute xml =~ "ColltnAmt"
    refute xml =~ "Adjstmnt"
    refute xml =~ "UltmtDbtr"
  end

  test "com valor, ajuste e devedor final (UltmtDbtr) opcionais" do
    mensagem = %{
      @mensagem
      | colltn_amt: "100.00",
        adjstmnt_dt_ind: "false",
        adjstmnt_amt: "10.00",
        ultmt_dbtr_nome: "Empresa Final Ltda",
        ultmt_dbtr_cpf_cnpj: "12345678000199",
        fnl_colltn_dt: ~D[2027-09-12]
    }

    assert {:ok, xml} = Pain009.build(mensagem, @cabecalho, :v1_1)
    assert {:ok, de_volta, :v1_1} = Pain009.parse(xml)

    assert de_volta.colltn_amt == "100.00"
    assert de_volta.adjstmnt_amt == "10.00"
    assert de_volta.ultmt_dbtr_nome == "Empresa Final Ltda"
    assert de_volta.fnl_colltn_dt == ~D[2027-09-12]
  end

  test "sem MndtPrcgDtls é rejeitado (exige ao menos 1 no schema real)" do
    mensagem = %{@mensagem | mndt_prcg_dtls: []}
    assert {:error, motivo} = Pain009.build(mensagem, @cabecalho, :v1_1)
    assert motivo =~ "MndtPrcgDtls"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | cdtr_nome: nil}
    assert {:error, motivo} = Pain009.build(mensagem, @cabecalho, :v1_1)
    assert motivo =~ "cdtr_nome"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pain.009/1.1"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pain009.parse(outro_xml)
  end
end
