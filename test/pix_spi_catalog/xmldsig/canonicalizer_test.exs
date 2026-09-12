defmodule PixSpiCatalog.Xmldsig.CanonicalizerTest do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.Xmldsig.Canonicalizer

  test "elemento simples com namespace padrão, sem mudanças a fazer" do
    xml = ~s(<Envelope xmlns="urn:a"><Child>text</Child></Envelope>)
    assert Canonicalizer.canonicalize(xml) == xml
  end

  test "redeclaração redundante do mesmo namespace é removida" do
    xml = ~s(<a:Root xmlns:a="urn:a"><a:Child xmlns:a="urn:a">x</a:Child></a:Root>)

    assert Canonicalizer.canonicalize(xml) ==
             ~s(<a:Root xmlns:a="urn:a"><a:Child>x</a:Child></a:Root>)
  end

  test "namespace declarado mas nunca utilizado não aparece na saída (é 'exclusiva')" do
    xml = ~s(<a:Root xmlns:a="urn:a" xmlns:b="urn:b"><a:Child/></a:Root>)

    assert Canonicalizer.canonicalize(xml) ==
             ~s(<a:Root xmlns:a="urn:a"><a:Child></a:Child></a:Root>)
  end

  test "prefixo só é declarado no ponto em que passa a ser usado, não antes" do
    xml =
      ~s(<Envelope xmlns="urn:root"><AppHdr Id="hdr1"><Sgntr>) <>
        ~s(<ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">) <>
        ~s(<ds:SignedInfo><ds:Reference URI="#hdr1"/></ds:SignedInfo>) <>
        ~s(</ds:Signature></Sgntr></AppHdr></Envelope>)

    expected =
      ~s(<Envelope xmlns="urn:root"><AppHdr Id="hdr1"><Sgntr>) <>
        ~s(<ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">) <>
        ~s(<ds:SignedInfo><ds:Reference URI="#hdr1"></ds:Reference></ds:SignedInfo>) <>
        ~s(</ds:Signature></Sgntr></AppHdr></Envelope>)

    assert Canonicalizer.canonicalize(xml) == expected
  end

  test "atributos: declaração de namespace primeiro, depois ordenados por (uri, nome local)" do
    xml = ~s(<e z="1" a="2" xmlns:p="urn:p" p:b="3"></e>)

    assert Canonicalizer.canonicalize(xml) ==
             ~s(<e xmlns:p="urn:p" a="2" z="1" p:b="3"></e>)
  end

  test "elemento vazio vira <tag></tag>, nunca <tag/>" do
    assert Canonicalizer.canonicalize(~s(<e/>)) == ~s(<e></e>)
    assert Canonicalizer.canonicalize(~s(<e></e>)) == ~s(<e></e>)
  end

  test "texto: & < > viram entidade, aspas e apóstrofo não" do
    xml = ~s(<e>a &amp; b &lt; c &gt; d "aspas" 'apostrofo'</e>)

    assert Canonicalizer.canonicalize(xml) ==
             ~s(<e>a &amp; b &lt; c &gt; d "aspas" 'apostrofo'</e>)
  end

  test "atributo: & < aspas viram entidade, > não precisa" do
    xml = ~s(<e a="x &amp; y &lt; z &gt; w"></e>)

    assert Canonicalizer.canonicalize(xml) ==
             ~s(<e a="x &amp; y &lt; z > w"></e>)
  end

  test "atributo sem namespace nunca herda o namespace padrão do elemento" do
    xml = ~s(<Envelope xmlns="urn:a" Id="x1"><Child/></Envelope>)

    assert Canonicalizer.canonicalize(xml) ==
             ~s(<Envelope xmlns="urn:a" Id="x1"><Child></Child></Envelope>)
  end

  test "canonicalize_element aceita namespace já renderizado por fora (sub-árvore)" do
    xml =
      ~s(<Envelope xmlns="urn:root"><AppHdr Id="hdr1"><Fr>1</Fr></AppHdr></Envelope>)

    {root, _rest} = :xmerl_scan.string(String.to_charlist(xml), quiet: true)
    [app_hdr] = :xmerl_xpath.string(~c"//AppHdr", root)

    assert Canonicalizer.canonicalize_element(app_hdr, %{default: "urn:root"}) ==
             ~s(<AppHdr Id="hdr1"><Fr>1</Fr></AppHdr>)

    assert Canonicalizer.canonicalize_element(app_hdr, %{}) ==
             ~s(<AppHdr xmlns="urn:root" Id="hdr1"><Fr>1</Fr></AppHdr>)
  end
end
