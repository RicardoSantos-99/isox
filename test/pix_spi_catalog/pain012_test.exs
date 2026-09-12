defmodule PixSpiCatalog.Pain012Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pain012}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "11111111",
    ispb_destino: "22222222",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Pain012{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    instg_agt_ispb: "11111111",
    accptd: "true",
    orgnl_mndt_id: "RR1234567820260912abcdefghijk",
    orgnl_mndt_req_id: "IS1234567820260912abcdefghijk",
    orgnl_frqcy_tp: "MNTH",
    orgnl_frst_colltn_dt: ~D[2026-09-12],
    orgnl_trckg_ind: "true",
    orgnl_cdtr_nome: "Fulano Recebedor",
    orgnl_cdtr_cpf_cnpj: "12345678901",
    orgnl_cdtr_agt_ispb: "11111111",
    orgnl_dbtr_cpf_cnpj: "98765432100",
    orgnl_dbtr_conta_id: "12345",
    orgnl_dbtr_agt_ispb: "22222222",
    orgnl_rfrd_doc_nb: "DOC001"
  }

  test "aceite, sem motivo nem SplmtryData" do
    assert {:ok, xml} = Pain012.build(@mensagem, @cabecalho, :v1_4)
    assert {:ok, de_volta, :v1_4} = Pain012.parse(xml)

    assert de_volta.accptd == "true"
    assert de_volta.rjct_rsn_prtry == nil
    refute xml =~ "SplmtryData"
  end

  test "rejeição com motivo" do
    mensagem = %{@mensagem | accptd: "false", rjct_rsn_prtry: "AC01"}

    assert {:ok, xml} = Pain012.build(mensagem, @cabecalho, :v1_3)
    assert {:ok, de_volta, :v1_3} = Pain012.parse(xml)
    assert de_volta.accptd == "false"
    assert de_volta.rjct_rsn_prtry == "AC01"
  end

  test "com endereço do devedor, referência do mandato, status e histórico" do
    mensagem = %{
      @mensagem
      | orgnl_dbtr_twn_nm: "1234567",
        orgnl_mndt_ref: "SC1234567820260912abcdefghijk",
        mndt_sts: "PDNG",
        mndt_prcg_dtls: [%{tp: "CRTN", dt_tm: @agora}]
    }

    assert {:ok, xml} = Pain012.build(mensagem, @cabecalho, :v1_4)
    assert {:ok, de_volta, :v1_4} = Pain012.parse(xml)

    assert de_volta.orgnl_dbtr_twn_nm == "1234567"
    assert de_volta.orgnl_mndt_ref == mensagem.orgnl_mndt_ref
    assert de_volta.mndt_sts == "PDNG"
    assert de_volta.mndt_prcg_dtls == [%{tp: "CRTN", dt_tm: @agora}]
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | orgnl_cdtr_nome: nil}
    assert {:error, motivo} = Pain012.build(mensagem, @cabecalho, :v1_4)
    assert motivo =~ "orgnl_cdtr_nome"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pain.012/1.4"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pain012.parse(outro_xml)
  end
end
