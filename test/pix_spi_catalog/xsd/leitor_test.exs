defmodule PixSpiCatalog.Xsd.LeitorTest do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.Xsd.Leitor

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
    lido = Leitor.ler_conteudo(@xsd)
    assert lido.namespace == "https://exemplo/1.0"
    assert lido.raiz_nome == "Envelope"
    assert lido.raiz_tipo == "EnvelopeType"
  end

  test "indexa complexType, simpleType e group por nome" do
    lido = Leitor.ler_conteudo(@xsd)
    assert {:complexo, _} = lido.definicoes["EnvelopeType"]
    assert {:simples, _} = lido.definicoes["CodigoCurto"]
    assert {:grupo, _} = lido.definicoes["GrupoX"]
  end

  test "elementos de nível raiz também são indexados, para resolver ref=" do
    lido = Leitor.ler_conteudo(@xsd)
    assert {:elemento, _} = lido.definicoes["Envelope"]
  end

  test "tag_local remove o prefixo xs:" do
    lido = Leitor.ler_conteudo(@xsd)
    {:complexo, no} = lido.definicoes["EnvelopeType"]
    assert Leitor.tag_local(no) == "complexType"
  end

  test "atributo devolve nil quando o atributo não existe" do
    lido = Leitor.ler_conteudo(@xsd)
    {:complexo, no} = lido.definicoes["EnvelopeType"]
    assert Leitor.atributo(no, "abstract") == nil
  end
end
