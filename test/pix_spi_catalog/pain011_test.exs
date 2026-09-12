defmodule PixSpiCatalog.Pain011Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pain011}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "22222222",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Pain011{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    instg_agt_ispb: "22222222",
    cxl_orgtr_cpf_cnpj: "12345678901",
    cxl_rsn_prtry: "ACCL",
    orgnl_mndt_id: "RR1234567820260912abcdefghijk",
    orgnl_mndt_req_id: "IC1234567820260912abcdefghijk",
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

  test "sem SplmtryData (opcional aqui), monta e volta pra struct" do
    assert {:ok, xml} = Pain011.build(@mensagem, @cabecalho, :v1_3)
    assert {:ok, de_volta, :v1_3} = Pain011.parse(xml)

    assert de_volta.orgnl_mndt_id == @mensagem.orgnl_mndt_id
    assert de_volta.cxl_rsn_prtry == "ACCL"
    assert de_volta.mndt_prcg_dtls == []
    refute xml =~ "SplmtryData"
  end

  test "com histórico de processamento" do
    mensagem = %{
      @mensagem
      | mndt_prcg_dtls: [%{tp: "CRTN", dt_tm: @agora}, %{tp: "CLTN", dt_tm: @agora}]
    }

    assert {:ok, xml} = Pain011.build(mensagem, @cabecalho, :v1_3)
    assert {:ok, de_volta, :v1_3} = Pain011.parse(xml)
    assert de_volta.mndt_prcg_dtls == mensagem.mndt_prcg_dtls
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | orgnl_mndt_id: nil}
    assert {:error, motivo} = Pain011.build(mensagem, @cabecalho, :v1_3)
    assert motivo =~ "orgnl_mndt_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pain.011/1.3"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pain011.parse(outro_xml)
  end
end
