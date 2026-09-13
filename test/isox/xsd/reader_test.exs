defmodule Isox.Xsd.ReaderTest do
  use ExUnit.Case, async: true

  alias Isox.Xsd.Reader

  @xsd """
  <?xml version="1.0"?>
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
             targetNamespace="https://exemplo/1.0">
      <xs:element name="Envelope" type="EnvelopeType"/>
      <xs:complexType name="EnvelopeType">
          <xs:sequence>
              <xs:element name="Nome" type="xs:string"/>
          </xs:sequence>
      </xs:complexType>
      <xs:simpleType name="CodigoCurto">
          <xs:restriction base="xs:string">
              <xs:maxLength value="4"/>
          </xs:restriction>
      </xs:simpleType>
      <xs:group name="GrupoX">
          <xs:sequence>
              <xs:element name="A" type="xs:string"/>
          </xs:sequence>
      </xs:group>
  </xs:schema>
  """

  test "extrai namespace e o elemento raiz" do
    result = Reader.read_content(@xsd)
    assert result.namespace == "https://exemplo/1.0"
    assert result.root_name == "Envelope"
    assert result.root_type == "EnvelopeType"
  end

  test "indexa complexType, simpleType e group por nome" do
    result = Reader.read_content(@xsd)
    assert {:complex_type, _} = result.definitions["EnvelopeType"]
    assert {:simple_type, _} = result.definitions["CodigoCurto"]
    assert {:group, _} = result.definitions["GrupoX"]
  end

  test "elementos de nível raiz também são indexados, para resolver ref=" do
    result = Reader.read_content(@xsd)
    assert {:element, _} = result.definitions["Envelope"]
  end

  test "local_tag remove o prefixo xs:" do
    result = Reader.read_content(@xsd)
    {:complex_type, node} = result.definitions["EnvelopeType"]
    assert Reader.local_tag(node) == "complexType"
  end

  test "attribute devolve nil quando o atributo não existe" do
    result = Reader.read_content(@xsd)
    {:complex_type, node} = result.definitions["EnvelopeType"]
    assert Reader.attribute(node, "abstract") == nil
  end
end
