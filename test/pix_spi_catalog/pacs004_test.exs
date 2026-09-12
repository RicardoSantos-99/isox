defmodule PixSpiCatalog.Pacs004Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Pacs004}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "22222222",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Pacs004{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: @agora,
    rtr_id: "D12345678202609121030abcdefghijk",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    valor: "150.00",
    rtr_rsn_cd: "MD06",
    dbtr_agt_ispb: "11111111",
    cdtr_agt_ispb: "22222222"
  }

  test "monta e volta pra struct, só com o obrigatório" do
    assert {:ok, xml} = Pacs004.build(@mensagem, @cabecalho, :v1_5)
    assert {:ok, mensagem, :v1_5} = Pacs004.parse(xml)

    assert mensagem.orgnl_end_to_end_id == @mensagem.orgnl_end_to_end_id
    assert mensagem.rtr_rsn_cd == "MD06"
    assert mensagem.sttlm_prty == "NORM"
    assert mensagem.rtr_rsn_addtl_inf == nil
    assert mensagem.rmt_inf_ustrd == nil
  end

  test "motivo com informação adicional e remessa de texto vão e voltam quando presentes" do
    mensagem = %{
      @mensagem
      | rtr_rsn_addtl_inf: "devolução solicitada pelo pagador",
        rmt_inf_ustrd: "devolução de pagamento indevido",
        sttlm_prty: "HIGH"
    }

    assert {:ok, xml} = Pacs004.build(mensagem, @cabecalho, :v1_5)
    assert {:ok, de_volta, :v1_5} = Pacs004.parse(xml)

    assert de_volta.rtr_rsn_addtl_inf == "devolução solicitada pelo pagador"
    assert de_volta.rmt_inf_ustrd == "devolução de pagamento indevido"
    assert de_volta.sttlm_prty == "HIGH"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | orgnl_end_to_end_id: nil}

    assert {:error, motivo} = Pacs004.build(mensagem, @cabecalho, :v1_5)
    assert motivo =~ "orgnl_end_to_end_id"
  end

  test "código de motivo fora do enum é rejeitado" do
    mensagem = %{@mensagem | rtr_rsn_cd: "XX99"}

    assert {:error, _motivo} = Pacs004.build(mensagem, @cabecalho, :v1_5)
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pacs.004/1.5"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Pacs004.parse(outro_xml)
  end
end
