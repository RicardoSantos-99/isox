defmodule PixSpiCatalog.GeneratorTest do
  use ExUnit.Case, async: false

  alias PixSpiCatalog.Generator
  alias PixSpiCatalog.Xsd.{Compiler, Reader}

  @xsd_message """
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

  test "names deriva módulo e caminho do nome do arquivo" do
    assert Generator.names("pacs.008.spi.1.16") ==
             {"PixSpiCatalog.Generated.Pacs008.V1_16", "pacs008/v1_16.ex"}

    assert Generator.names("admi.002.spi.1.5") ==
             {"PixSpiCatalog.Generated.Admi002.V1_5", "admi002/v1_5.ex"}

    assert Generator.names("pain.013.spi.2.2") ==
             {"PixSpiCatalog.Generated.Pain013.V2_2", "pain013/v2_2.ex"}
  end

  test "head001_source gera um módulo que expõe o tipo dado" do
    type = %PixSpiCatalog.Schema.SimpleType{base: "string"}
    # Module.concat/2, não o alias direto — o módulo só passa a existir
    # depois do Code.eval_string/1 logo abaixo; um alias literal deixaria o
    # compilador avisar "função indefinida" sobre um módulo que ele vê (só
    # nesta análise estática) como gerado dinamicamente.
    module = Module.concat(PixSpiCatalog.Generated, TestHead)

    Code.eval_string(Generator.head001_source(inspect(module), type))

    assert module.type() == type
  end

  test "o código gerado compila e faz parse/build de ponta a ponta" do
    # o AppHdr do módulo gerado referencia sempre o PixSpiCatalog.Generated.Head001
    # de verdade (já compilado, a partir dos XSDs reais) — não um substituto
    # de teste, para não depender de redefinir um módulo global.
    read_result = Reader.read_content(@xsd_message)
    root = Compiler.resolve_root(read_result)

    module = Module.concat(PixSpiCatalog.Generated, TestGenerated)

    source =
      Generator.message_source(inspect(module), root, read_result.namespace, "teste.spi.1.0")

    Code.eval_string(source)

    xml = """
    <Envelope xmlns="#{read_result.namespace}">
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

    assert {:ok, term} = module.parse(xml)
    assert get_in(term, ["Document", "Valor"]) == "abc"
    assert get_in(term, ["AppHdr", "MsgDefIdr"]) == "teste.spi.1.0"

    assert {:ok, built_xml} = module.build(term)
    assert {:ok, ^term} = module.parse(built_xml)
    assert module.namespace() == read_result.namespace
    assert module.msg_def_idr() == "teste.spi.1.0"
  end
end
