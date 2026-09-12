defmodule PixSpiCatalog.RegistryTest do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.Registry

  @xml_pibr001 """
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <Envelope xmlns="https://www.bcb.gov.br/pi/pibr.001/1.3">
      <AppHdr>
          <Fr><FIId><FinInstnId><Othr><Id>99999010</Id></Othr></FinInstnId></FIId></Fr>
          <To><FIId><FinInstnId><Othr><Id>00038166</Id></Othr></FinInstnId></FIId></To>
          <BizMsgIdr>M99999010bfefffd6533b49708ba8101</BizMsgIdr>
          <MsgDefIdr>pibr.001.spi.1.3</MsgDefIdr>
          <CreDt>2020-04-07T13:47:22.580Z</CreDt>
          <Sgntr/>
      </AppHdr>
      <Document>
          <EchoReq>
              <GrpHdr>
                  <MsgId>M99999010bfefffd6533b49708ba8101</MsgId>
                  <CreDtTm>2020-04-07T13:47:22.580Z</CreDtTm>
              </GrpHdr>
              <EchoTxInf><Data>Campo livre</Data></EchoTxInf>
          </EchoReq>
      </Document>
  </Envelope>
  """

  test "generated_modules encontra os módulos reais já carregados" do
    modules = Registry.generated_modules()
    assert PixSpiCatalog.Generated.Pibr001.V1_3 in modules
    assert PixSpiCatalog.Generated.Pacs008.V1_16 in modules
    refute PixSpiCatalog.Generated.Head001 in modules
  end

  test "xml_namespace extrai o xmlns do Envelope" do
    assert Registry.xml_namespace(@xml_pibr001) == "https://www.bcb.gov.br/pi/pibr.001/1.3"
  end

  test "parse despacha para o módulo certo pelo namespace" do
    assert {:ok, PixSpiCatalog.Generated.Pibr001.V1_3, term} = Registry.parse(@xml_pibr001)
    assert get_in(term, ["Document", "EchoReq", "EchoTxInf", "Data"]) == "Campo livre"
  end

  test "namespace desconhecido dá erro claro" do
    xml = String.replace(@xml_pibr001, "pibr.001/1.3", "algo-inexistente/9.9")

    assert {:error, {:unknown_namespace, "https://www.bcb.gov.br/pi/algo-inexistente/9.9"}} =
             Registry.parse(xml)
  end

  test "MsgDefIdr divergente do namespace é erro (ADR 0002)" do
    xml =
      String.replace(
        @xml_pibr001,
        "<MsgDefIdr>pibr.001.spi.1.3</MsgDefIdr>",
        "<MsgDefIdr>pibr.002.spi.1.3</MsgDefIdr>"
      )

    assert {:error,
            {:msg_def_idr_mismatch, expected: "pibr.001.spi.1.3", received: "pibr.002.spi.1.3"}} =
             Registry.parse(xml)
  end
end
