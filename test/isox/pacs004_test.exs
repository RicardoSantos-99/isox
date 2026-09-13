defmodule Isox.Pacs004Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Pacs004}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "22222222",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Pacs004{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    rtr_id: "D12345678202609121030abcdefghijk",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    value: "150.00",
    rtr_rsn_cd: "MD06",
    dbtr_agt_ispb: "11111111",
    cdtr_agt_ispb: "22222222"
  }

  test "monta e volta pra struct, só com o obrigatório" do
    assert {:ok, xml} = Pacs004.encode(@message, @header, :v1_5)
    assert {:ok, message, :v1_5} = Pacs004.decode(xml)

    assert message.orgnl_end_to_end_id == @message.orgnl_end_to_end_id
    assert message.rtr_rsn_cd == "MD06"
    assert message.sttlm_prty == "NORM"
    assert message.rtr_rsn_addtl_inf == nil
    assert message.rmt_inf_ustrd == nil
  end

  test "reason com informação adicional e remessa de text vão e voltam quando presentes" do
    message = %{
      @message
      | rtr_rsn_addtl_inf: "devolução solicitada pelo pagador",
        rmt_inf_ustrd: "devolução de pagamento indevido",
        sttlm_prty: "HIGH"
    }

    assert {:ok, xml} = Pacs004.encode(message, @header, :v1_5)
    assert {:ok, de_volta, :v1_5} = Pacs004.decode(xml)

    assert de_volta.rtr_rsn_addtl_inf == "devolução solicitada pelo pagador"
    assert de_volta.rmt_inf_ustrd == "devolução de pagamento indevido"
    assert de_volta.sttlm_prty == "HIGH"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | orgnl_end_to_end_id: nil}

    assert {:error, reason} = Pacs004.encode(message, @header, :v1_5)
    assert reason =~ "orgnl_end_to_end_id"
  end

  test "código de motivo fora do enum é rejeitado" do
    message = %{@message | rtr_rsn_cd: "XX99"}

    assert {:error, _reason} = Pacs004.encode(message, @header, :v1_5)
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pacs.004/1.5"><Nada/></Envelope>
    """

    assert {:error, _reason} = Pacs004.decode(outro_xml)
  end

  # TxInf é `max: ilimitado` no XSD (confirmado com exemplo oficial do
  # BCB: pacs.004_SPI_10_msg.xml vem com 10 transações numa mensagem só)
  # — o modelo assume 1, mas decode/1 tem que errar limpo nesse caso, não
  # crashar (MatchError), já que é uma forma de mensagem que o catálogo
  # permite.
  test "mensagem com mais de uma transação (lote) erra limpo, não crasha" do
    {:ok, xml} = Pacs004.encode(@message, @header, :v1_5)
    duplicada = String.replace(xml, ~r{(<TxInf>.*</TxInf>)}s, "\\1\\1")

    assert {:error, {:unsupported_batch, 2}} = Pacs004.decode(duplicada)
  end
end
