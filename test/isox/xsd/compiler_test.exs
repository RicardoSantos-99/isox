defmodule Isox.Xsd.CompilerTest do
  use ExUnit.Case, async: true

  alias Isox.Schema.{Attribute, Choice, ComplexType, Element, SimpleType}
  alias Isox.Xsd.{Compiler, Reader}

  defp root(xsd) do
    xsd |> Reader.read_content() |> Compiler.resolve_root()
  end

  test "sequência simples com elemento xs:string" do
    assert %Element{tag: "Envelope", type: %ComplexType{content: [field]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence>
                   <xs:element name="Nome" type="xs:string"/>
                 </xs:sequence>
               </xs:complexType>
             </xs:schema>
             """)

    assert field == %Element{tag: "Nome", type: %SimpleType{base: "string"}, min: 1, max: 1}
  end

  test "minOccurs/maxOccurs, incluindo unbounded" do
    assert %Element{type: %ComplexType{content: [a, b]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence>
                   <xs:element minOccurs="0" name="Opcional" type="xs:string"/>
                   <xs:element maxOccurs="unbounded" name="Repetido" type="xs:string"/>
                 </xs:sequence>
               </xs:complexType>
             </xs:schema>
             """)

    assert a.min == 0
    assert b.max == :unbounded
  end

  test "simpleType com pattern, maxLength e enum" do
    assert %Element{type: %ComplexType{content: [%Element{type: type}]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence>
                   <xs:element name="Codigo" type="CodigoType"/>
                 </xs:sequence>
               </xs:complexType>
               <xs:simpleType name="CodigoType">
                 <xs:restriction base="xs:string">
                   <xs:pattern value="[A-Z]{4}"/>
                   <xs:maxLength value="4"/>
                 </xs:restriction>
               </xs:simpleType>
             </xs:schema>
             """)

    assert type == %SimpleType{base: "string", pattern: "[A-Z]{4}", max_length: 4}
  end

  test "enumeração com múltiplos valores" do
    assert %Element{type: %ComplexType{content: [%Element{type: type}]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence><xs:element name="Sts" type="StsType"/></xs:sequence>
               </xs:complexType>
               <xs:simpleType name="StsType">
                 <xs:restriction base="xs:string">
                   <xs:enumeration value="ACCC"/>
                   <xs:enumeration value="RJCT"/>
                 </xs:restriction>
               </xs:simpleType>
             </xs:schema>
             """)

    assert type.enum == ["ACCC", "RJCT"]
  end

  test "choice como conteúdo do complexType" do
    assert %Element{type: %ComplexType{content: [choice]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:choice>
                   <xs:element name="A" type="xs:string"/>
                   <xs:element name="B" type="xs:string"/>
                 </xs:choice>
               </xs:complexType>
             </xs:schema>
             """)

    assert %Choice{options: [%Element{tag: "A"}, %Element{tag: "B"}]} = choice
  end

  test "simpleContent + extension + attribute (valor com moeda)" do
    assert %Element{type: %ComplexType{content: [%Element{type: type}]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence><xs:element name="Valor" type="Montante"/></xs:sequence>
               </xs:complexType>
               <xs:complexType name="Montante">
                 <xs:simpleContent>
                   <xs:extension base="xs:decimal">
                     <xs:attribute name="Ccy" type="CcyType" use="required"/>
                   </xs:extension>
                 </xs:simpleContent>
               </xs:complexType>
               <xs:simpleType name="CcyType">
                 <xs:restriction base="xs:string"><xs:maxLength value="3"/></xs:restriction>
               </xs:simpleType>
             </xs:schema>
             """)

    assert %ComplexType{text: %SimpleType{base: "decimal"}, attributes: [attribute]} = type
    assert attribute == %Attribute{tag: "Ccy", type: %SimpleType{base: "string", max_length: 3}}
  end

  test "xs:any (Sgntr) vira :opaque" do
    assert %Element{type: %ComplexType{content: [%Element{tag: "Sgntr", type: :opaque}]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence><xs:element name="Sgntr" type="SignatureEnvelope"/></xs:sequence>
               </xs:complexType>
               <xs:complexType name="SignatureEnvelope">
                 <xs:sequence><xs:any namespace="http://www.w3.org/2000/09/xmldsig#"/></xs:sequence>
               </xs:complexType>
             </xs:schema>
             """)
  end

  test "elemento com tipo anônimo (complexType direto, sem type=)" do
    assert %Element{type: %ComplexType{content: [%Element{tag: "X", type: inner}]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence>
                   <xs:element name="X">
                     <xs:complexType>
                       <xs:sequence><xs:element name="Y" type="xs:string"/></xs:sequence>
                     </xs:complexType>
                   </xs:element>
                 </xs:sequence>
               </xs:complexType>
             </xs:schema>
             """)

    assert %ComplexType{content: [%Element{tag: "Y"}]} = inner
  end

  test "element ref= herda o tipo do elemento referenciado, mas usa a cardinalidade de quem referencia" do
    assert %Element{type: %ComplexType{content: [ref]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence><xs:element maxOccurs="unbounded" ref="Original"/></xs:sequence>
               </xs:complexType>
               <xs:element name="Original" type="xs:string"/>
             </xs:schema>
             """)

    assert ref == %Element{
             tag: "Original",
             type: %SimpleType{base: "string"},
             min: 1,
             max: :unbounded
           }
  end

  test "group ref= embutido numa sequência" do
    assert %Element{type: %ComplexType{content: [%Element{tag: "A"}, %Element{tag: "B"}]}} =
             root("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence>
                   <xs:element name="A" type="xs:string"/>
                   <xs:group ref="G"/>
                 </xs:sequence>
               </xs:complexType>
               <xs:group name="G">
                 <xs:sequence><xs:element name="B" type="xs:string"/></xs:sequence>
               </xs:group>
             </xs:schema>
             """)
  end
end
