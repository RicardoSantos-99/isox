defmodule IsoxTest do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Envelope, Pacs008}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "12345678",
    to_ispb: "87654321",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Pacs008{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    svc_lvl_prtry: "PAGPRI",
    end_to_end_id: "E12345678202609121030abcdefghijk",
    value: "150.00",
    accptnc_dt_tm: @agora,
    lcl_instrm: "MANU",
    dbtr_name: "Fulano de Tal",
    dbtr_cpf_cnpj: "12345678901",
    dbtr_acct_id: "00012345",
    dbtr_agt_ispb: "12345678",
    cdtr_cpf_cnpj: "12345678000199",
    cdtr_acct_id: "00098765",
    cdtr_agt_ispb: "87654321",
    purp_cd: "IPAY"
  }

  test "encode/2 e decode/1 fazem o caminho de ida e volta via envelope" do
    envelope = %Envelope{header: @header, message: @message}

    assert {:ok, xml} = Isox.encode(envelope, :v1_16)
    assert {:ok, %Envelope{header: header, message: message}, :v1_16} = Isox.decode(xml)

    assert message == @message
    assert header == @header
  end

  test "decode/1 identifica sozinho o tipo da mensagem, sem quem chama precisar saber qual é" do
    {:ok, xml} = Pacs008.encode(@message, @header, :v1_15)

    assert {:ok, %Envelope{message: %Pacs008{} = message}, :v1_15} = Isox.decode(xml)
    assert message.end_to_end_id == @message.end_to_end_id
  end

  test "decode/1 erra claro pra XML de namespace desconhecido" do
    assert {:error, {:unknown_namespace, nil}} = Isox.decode("<Envelope></Envelope>")
  end

  test "sign/4, verify/2 e generate_test_certificate/0 fecham o ciclo de assinatura" do
    psp = Isox.generate_test_certificate()

    app_hdr_xml =
      ~s(<AppHdr xmlns="urn:pix"><Fr>11111111</Fr><To>22222222</To>) <>
        ~s(<BizMsgIdr>M12345678901234567890123456789</BizMsgIdr>) <>
        ~s(<MsgDefIdr>pacs.008.spi.1.16</MsgDefIdr><CreDt>2026-09-12T10:00:00.000Z</CreDt>) <>
        ~s(<Sgntr></Sgntr></AppHdr>)

    document_xml =
      ~s(<Document xmlns="urn:pix:pacs.008"><FIToFICstmrCdtTrf><GrpHdr><MsgId>x</MsgId></GrpHdr></FIToFICstmrCdtTrf></Document>)

    signature_xml =
      Isox.sign(app_hdr_xml, document_xml, psp.private_key_der, psp.certificate_der)

    envelope_xml =
      ~s(<Envelope xmlns="urn:envelope">) <>
        String.replace(app_hdr_xml, "<Sgntr></Sgntr>", "<Sgntr>#{signature_xml}</Sgntr>") <>
        document_xml <>
        ~s(</Envelope>)

    assert :ok = Isox.verify(envelope_xml, psp.certificate_der)
  end
end
