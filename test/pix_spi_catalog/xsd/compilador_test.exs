defmodule PixSpiCatalog.Xsd.CompiladorTest do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.Schema.{Atributo, Elemento, Escolha, TipoComplexo, TipoSimples}
  alias PixSpiCatalog.Xsd.{Compilador, Leitor}

  defp raiz(xsd) do
    xsd |> Leitor.ler_conteudo() |> Compilador.resolver_raiz()
  end

  test "sequência simples com elemento xs:string" do
    assert %Elemento{tag: "Envelope", tipo: %TipoComplexo{conteudo: [campo]}} =
             raiz("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence>
                   <xs:element name="Nome" type="xs:string"/>
                 </xs:sequence>
               </xs:complexType>
             </xs:schema>
             """)

    assert campo == %Elemento{tag: "Nome", tipo: %TipoSimples{base: "string"}, min: 1, max: 1}
  end

  test "minOccurs/maxOccurs, incluindo unbounded" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [a, b]}} =
             raiz("""
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
    assert b.max == :ilimitado
  end

  test "simpleType com pattern, maxLength e enum" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [%Elemento{tipo: tipo}]}} =
             raiz("""
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

    assert tipo == %TipoSimples{base: "string", pattern: "[A-Z]{4}", max_length: 4}
  end

  test "enumeração com múltiplos valores" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [%Elemento{tipo: tipo}]}} =
             raiz("""
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

    assert tipo.enum == ["ACCC", "RJCT"]
  end

  test "choice como conteúdo do complexType" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [escolha]}} =
             raiz("""
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

    assert %Escolha{opcoes: [%Elemento{tag: "A"}, %Elemento{tag: "B"}]} = escolha
  end

  test "simpleContent + extension + attribute (valor com moeda)" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [%Elemento{tipo: tipo}]}} =
             raiz("""
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

    assert %TipoComplexo{texto: %TipoSimples{base: "decimal"}, atributos: [atributo]} = tipo
    assert atributo == %Atributo{tag: "Ccy", tipo: %TipoSimples{base: "string", max_length: 3}}
  end

  test "xs:any (Sgntr) vira :opaco" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [%Elemento{tag: "Sgntr", tipo: :opaco}]}} =
             raiz("""
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
    assert %Elemento{tipo: %TipoComplexo{conteudo: [%Elemento{tag: "X", tipo: interno}]}} =
             raiz("""
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

    assert %TipoComplexo{conteudo: [%Elemento{tag: "Y"}]} = interno
  end

  test "element ref= herda o tipo do elemento referenciado, mas usa a cardinalidade de quem referencia" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [ref]}} =
             raiz("""
             <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="ns">
               <xs:element name="Envelope" type="T"/>
               <xs:complexType name="T">
                 <xs:sequence><xs:element maxOccurs="unbounded" ref="Original"/></xs:sequence>
               </xs:complexType>
               <xs:element name="Original" type="xs:string"/>
             </xs:schema>
             """)

    assert ref == %Elemento{
             tag: "Original",
             tipo: %TipoSimples{base: "string"},
             min: 1,
             max: :ilimitado
           }
  end

  test "group ref= embutido numa sequência" do
    assert %Elemento{tipo: %TipoComplexo{conteudo: [%Elemento{tag: "A"}, %Elemento{tag: "B"}]}} =
             raiz("""
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
