defmodule PixSpiCatalog.GeradorTest do
  use ExUnit.Case, async: false

  alias PixSpiCatalog.Gerador
  alias PixSpiCatalog.Xsd.{Compilador, Leitor}

  @xsd_mensagem """
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="https://exemplo/teste.001/1.0">
    <xs:element name="Envelope" type="SPIEnvelopeMessage"/>
    <xs:complexType name="SPIEnvelopeMessage">
      <xs:sequence>
        <xs:element name="AppHdr" type="SPI.head.001.001.01"/>
        <xs:element name="Document" type="SPI.teste.001.001.01"/>
      </xs:sequence>
    </xs:complexType>
    <xs:complexType name="SPI.head.001.001.01">
      <xs:sequence>
        <xs:element name="BizMsgIdr" type="xs:string"/>
        <xs:element name="Sgntr" type="SignatureEnvelope"/>
      </xs:sequence>
    </xs:complexType>
    <xs:complexType name="SignatureEnvelope">
      <xs:sequence><xs:any namespace="http://www.w3.org/2000/09/xmldsig#"/></xs:sequence>
    </xs:complexType>
    <xs:complexType name="SPI.teste.001.001.01">
      <xs:sequence>
        <xs:element name="Valor" type="xs:string"/>
      </xs:sequence>
    </xs:complexType>
  </xs:schema>
  """

  test "nomes deriva módulo e caminho do nome do arquivo" do
    assert Gerador.nomes("pacs.008.spi.1.16") ==
             {"PixSpiCatalog.Gerado.Pacs008.V1_16", "pacs008/v1_16.ex"}

    assert Gerador.nomes("admi.002.spi.1.5") ==
             {"PixSpiCatalog.Gerado.Admi002.V1_5", "admi002/v1_5.ex"}

    assert Gerador.nomes("pain.013.spi.2.2") ==
             {"PixSpiCatalog.Gerado.Pain013.V2_2", "pain013/v2_2.ex"}
  end

  test "fonte_head001 gera um módulo que expõe o tipo dado" do
    tipo = %PixSpiCatalog.Schema.TipoSimples{base: "string"}
    modulo = PixSpiCatalog.Gerado.HeadDeTeste

    Code.eval_string(Gerador.fonte_head001(inspect(modulo), tipo))

    assert modulo.tipo() == tipo
  end

  test "o código gerado compila e faz parse/build de ponta a ponta" do
    # o AppHdr do módulo gerado referencia sempre o PixSpiCatalog.Gerado.Head001
    # de verdade (já compilado, a partir dos XSDs reais) — não um substituto
    # de teste, para não depender de redefinir um módulo global.
    lido = Leitor.ler_conteudo(@xsd_mensagem)
    raiz = Compilador.resolver_raiz(lido)

    modulo = PixSpiCatalog.Gerado.TesteGerado
    fonte = Gerador.fonte_mensagem(inspect(modulo), raiz, lido.namespace, "teste.spi.1.0")
    Code.eval_string(fonte)

    xml = """
    <Envelope xmlns="#{lido.namespace}">
      <AppHdr>
        <Fr><FIId><FinInstnId><Othr><Id>11111111</Id></Othr></FinInstnId></FIId></Fr>
        <To><FIId><FinInstnId><Othr><Id>22222222</Id></Othr></FinInstnId></FIId></To>
        <BizMsgIdr>M1111111112345678901234567890123</BizMsgIdr>
        <MsgDefIdr>teste.spi.1.0</MsgDefIdr>
        <CreDt>2020-01-01T08:30:12.000Z</CreDt>
        <Sgntr/>
      </AppHdr>
      <Document><Valor>abc</Valor></Document>
    </Envelope>
    """

    assert {:ok, termo} = modulo.parse(xml)
    assert get_in(termo, ["Document", "Valor"]) == "abc"
    assert get_in(termo, ["AppHdr", "MsgDefIdr"]) == "teste.spi.1.0"

    assert {:ok, xml_construido} = modulo.build(termo)
    assert {:ok, ^termo} = modulo.parse(xml_construido)
    assert modulo.namespace() == lido.namespace
    assert modulo.msg_def_idr() == "teste.spi.1.0"
  end
end
