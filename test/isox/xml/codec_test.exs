defmodule Isox.Xml.CodecTest do
  use ExUnit.Case, async: true

  alias Isox.Schema.{Attribute, Choice, ComplexType, Element, SimpleType}
  alias Isox.Xml.Codec

  test "parse e build de um elemento simples aninhado" do
    schema = %Element{
      tag: "Envelope",
      type: %ComplexType{content: [%Element{tag: "Name", type: %SimpleType{}}]}
    }

    assert {:ok, term} = Codec.parse(schema, "<Envelope><Name>Fulano</Name></Envelope>")
    assert term == %{"Name" => "Fulano"}

    assert {:ok, xml} = Codec.build(schema, term)
    assert xml =~ ~s(<?xml version="1.0" encoding="UTF-8"?>)
    assert {:ok, ^term} = Codec.parse(schema, xml)
  end

  test "elemento opcional ausente não aparece no termo, e build tolera a ausência" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [
          %Element{tag: "Required", type: %SimpleType{}},
          %Element{tag: "Optional", type: %SimpleType{}, min: 0}
        ]
      }
    }

    assert {:ok, %{"Required" => "x"}} =
             Codec.parse(schema, "<E><Required>x</Required></E>")

    assert {:ok, xml} = Codec.build(schema, %{"Required" => "x"})
    refute xml =~ "Optional"
  end

  test "elemento obrigatório ausente é erro" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{content: [%Element{tag: "X", type: %SimpleType{}}]}
    }

    assert {:error, message} = Codec.parse(schema, "<E></E>")
    assert message =~ "X"
  end

  test "elemento repetido (maxOccurs ilimitado) vira lista, na ordem" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [%Element{tag: "Item", type: %SimpleType{}, max: :unbounded}]
      }
    }

    assert {:ok, %{"Item" => ["a", "b", "c"]}} =
             Codec.parse(schema, "<E><Item>a</Item><Item>b</Item><Item>c</Item></E>")

    assert {:ok, xml} = Codec.build(schema, %{"Item" => ["a", "b", "c"]})
    assert {:ok, %{"Item" => ["a", "b", "c"]}} = Codec.parse(schema, xml)
  end

  test "choice: usa a opção presente, ignora as demais" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [
          %Choice{
            options: [
              %Element{tag: "A", type: %SimpleType{}},
              %Element{tag: "B", type: %SimpleType{}}
            ]
          }
        ]
      }
    }

    assert {:ok, %{"B" => "valor"}} = Codec.parse(schema, "<E><B>valor</B></E>")
    assert {:ok, xml} = Codec.build(schema, %{"B" => "valor"})
    refute xml =~ "<A>"
    assert xml =~ "<B>valor</B>"
  end

  describe "choice com xs:group ref= (opção = grupo de vários elementos)" do
    # Mesmo formato do reda.022 real (ReqdModContatoChoice): duas opções de
    # grupo com tags em comum — só um campo distingue qual ramo é.
    @schema %Element{
      tag: "CtctDtls",
      type: %ComplexType{
        content: [
          %Choice{
            options: [
              [
                %Element{tag: "PhneNb", type: %SimpleType{}},
                %Element{tag: "FaxNb", type: %SimpleType{}, min: 0},
                %Element{tag: "EmailAdr", type: %SimpleType{}}
              ],
              [
                %Element{tag: "Nm", type: %SimpleType{}},
                %Element{tag: "PhneNb", type: %SimpleType{}},
                %Element{tag: "EmailAdr", type: %SimpleType{}}
              ]
            ]
          }
        ]
      }
    }

    test "ramo sem o campo distintivo: todos os campos do grupo saem no parse" do
      xml = "<CtctDtls><PhneNb>1</PhneNb><FaxNb>2</FaxNb><EmailAdr>a@a.com</EmailAdr></CtctDtls>"

      assert {:ok, term} = Codec.parse(@schema, xml)
      assert term == %{"PhneNb" => "1", "FaxNb" => "2", "EmailAdr" => "a@a.com"}
    end

    test "ramos com tags em comum: o campo distintivo (Nm) escolhe o ramo certo, não se perde" do
      xml = "<CtctDtls><Nm>Fulano</Nm><PhneNb>1</PhneNb><EmailAdr>a@a.com</EmailAdr></CtctDtls>"

      assert {:ok, term} = Codec.parse(@schema, xml)
      assert term == %{"Nm" => "Fulano", "PhneNb" => "1", "EmailAdr" => "a@a.com"}

      assert {:ok, rebuilt_xml} = Codec.build(@schema, term)
      assert rebuilt_xml =~ "<Nm>Fulano</Nm>"
      assert {:ok, ^term} = Codec.parse(@schema, rebuilt_xml)
    end

    test "build também escolhe o ramo pelo maior número de campos batendo" do
      term = %{"Nm" => "Fulano", "PhneNb" => "1", "EmailAdr" => "a@a.com"}

      assert {:ok, xml} = Codec.build(@schema, term)
      assert xml =~ "<Nm>Fulano</Nm>"
      refute xml =~ "<FaxNb>"
    end
  end

  test "simpleContent + atributo (valor com moeda)" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [
          %Element{
            tag: "Valor",
            type: %ComplexType{
              text: %SimpleType{base: "decimal"},
              attributes: [%Attribute{tag: "Ccy", type: %SimpleType{}}]
            }
          }
        ]
      }
    }

    assert {:ok, term} = Codec.parse(schema, ~s(<E><Valor Ccy="BRL">1000.00</Valor></E>))
    assert term == %{"Valor" => %{value: "1000.00", attributes: %{"Ccy" => "BRL"}}}

    assert {:ok, xml} = Codec.build(schema, term)
    assert xml =~ ~s(Ccy="BRL")
    assert xml =~ "1000.00"
    assert {:ok, ^term} = Codec.parse(schema, xml)
  end

  test "opaco (Sgntr) captura o XML interno sem interpretar, vazio ou não" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{content: [%Element{tag: "Sgntr", type: :opaque}]}
    }

    assert {:ok, %{"Sgntr" => ""}} = Codec.parse(schema, "<E><Sgntr/></E>")

    assert {:ok, %{"Sgntr" => inner}} =
             Codec.parse(schema, "<E><Sgntr><ds:Signature>xyz</ds:Signature></Sgntr></E>")

    assert inner =~ "xyz"
    assert {:ok, xml} = Codec.build(schema, %{"Sgntr" => inner})
    assert {:ok, %{"Sgntr" => ^inner}} = Codec.parse(schema, xml)
  end

  test "validação: pattern" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [%Element{tag: "Cod", type: %SimpleType{pattern: "[A-Z]{4}"}}]
      }
    }

    assert {:ok, _} = Codec.parse(schema, "<E><Cod>ACCC</Cod></E>")
    assert {:error, message} = Codec.parse(schema, "<E><Cod>abcd</Cod></E>")
    assert message =~ "padrão"
  end

  test "validação: pattern casa o valor inteiro, não uma substring no meio" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [%Element{tag: "Cod", type: %SimpleType{pattern: "[A-Z]{4}"}}]
      }
    }

    assert {:error, _} = Codec.parse(schema, "<E><Cod>XACCCX</Cod></E>")
  end

  test "validação: enum" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [%Element{tag: "Sts", type: %SimpleType{enum: ["ACCC", "RJCT"]}}]
      }
    }

    assert {:ok, _} = Codec.parse(schema, "<E><Sts>RJCT</Sts></E>")
    assert {:error, _} = Codec.parse(schema, "<E><Sts>OUTRO</Sts></E>")
  end

  test "validação: max_length e min_length" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{
        content: [%Element{tag: "X", type: %SimpleType{max_length: 3, min_length: 2}}]
      }
    }

    assert {:ok, _} = Codec.parse(schema, "<E><X>ab</X></E>")
    assert {:error, _} = Codec.parse(schema, "<E><X>a</X></E>")
    assert {:error, _} = Codec.parse(schema, "<E><X>abcd</X></E>")
  end

  # ActiveCurrencyAndAmount_SimpleType do catálogo (fractionDigits 2,
  # totalDigits 18, minInclusive 0) — antes desses 4 campos existirem no
  # SimpleType, um valor monetário negativo, com casas decimais demais, ou
  # nem sequer numérico passava reto pelo parse: pattern/enum/tamanho não
  # cobrem faixa numérica.
  describe "validação: decimal (fraction_digits/total_digits/min_inclusive/max_inclusive)" do
    setup do
      schema = %Element{
        tag: "E",
        type: %ComplexType{
          content: [
            %Element{
              tag: "Valor",
              type: %SimpleType{
                base: "decimal",
                fraction_digits: 2,
                total_digits: 18,
                min_inclusive: "0"
              }
            }
          ]
        }
      }

      %{schema: schema}
    end

    test "valor dentro da faixa passa", %{schema: schema} do
      assert {:ok, %{"Valor" => "150.00"}} = Codec.parse(schema, "<E><Valor>150.00</Valor></E>")
      assert {:ok, %{"Valor" => "0"}} = Codec.parse(schema, "<E><Valor>0</Valor></E>")
    end

    test "negativo viola min_inclusive", %{schema: schema} do
      assert {:error, message} = Codec.parse(schema, "<E><Valor>-50.00</Valor></E>")
      assert message =~ "mínimo"
    end

    test "casas decimais a mais violam fraction_digits", %{schema: schema} do
      assert {:error, message} = Codec.parse(schema, "<E><Valor>10.999</Valor></E>")
      assert message =~ "casas decimais"
    end

    test "dígitos totais a mais violam total_digits", %{schema: schema} do
      assert {:error, message} =
               Codec.parse(schema, "<E><Valor>123456789012345678.00</Valor></E>")

      assert message =~ "total de dígitos"

      assert {:ok, _} = Codec.parse(schema, "<E><Valor>1234567890123456.78</Valor></E>")
    end

    test "valor não numérico é erro, não passa reto como string", %{schema: schema} do
      assert {:error, message} = Codec.parse(schema, "<E><Valor>abc</Valor></E>")
      assert message =~ "decimal válido"
    end

    test "max_inclusive, quando presente, também é respeitado" do
      schema = %Element{
        tag: "E",
        type: %ComplexType{
          content: [%Element{tag: "X", type: %SimpleType{base: "decimal", max_inclusive: "10"}}]
        }
      }

      assert {:ok, _} = Codec.parse(schema, "<E><X>10</X></E>")
      assert {:error, message} = Codec.parse(schema, "<E><X>10.01</X></E>")
      assert message =~ "máximo"
    end
  end

  test "escapa e desescapa caracteres especiais em texto e atributo" do
    schema = %Element{
      tag: "E",
      type: %ComplexType{content: [%Element{tag: "Name", type: %SimpleType{}}]}
    }

    term = %{"Name" => "Tom & Jerry <company>"}

    assert {:ok, xml} = Codec.build(schema, term)
    assert {:ok, ^term} = Codec.parse(schema, xml)
  end

  describe "template" do
    @schema %Element{
      tag: "E",
      type: %ComplexType{
        content: [
          %Element{tag: "Fixed", type: %SimpleType{}},
          %Element{tag: "Variable", type: %SimpleType{}}
        ]
      }
    }

    test "compila com lacunas e renderiza preenchendo só o que varia" do
      term = %{"Fixed" => "sempre igual", "Variable" => Codec.gap(:variable)}

      assert {:ok, template} = Codec.compile_template(@schema, term)
      assert xml1 = Codec.render(template, %{variable: "um"})
      assert xml2 = Codec.render(template, %{variable: "outro"})

      assert {:ok, %{"Fixed" => "sempre igual", "Variable" => "um"}} = Codec.parse(@schema, xml1)

      assert {:ok, %{"Fixed" => "sempre igual", "Variable" => "outro"}} =
               Codec.parse(@schema, xml2)
    end

    test "sem lacuna nenhuma, o template é só o XML fixo" do
      term = %{"Fixed" => "a", "Variable" => "b"}

      assert {:ok, template} = Codec.compile_template(@schema, term)
      assert Codec.render(template, %{}) == Codec.render(template, %{extra: 1})
    end

    test "escapa o valor da lacuna no momento de renderizar" do
      term = %{"Fixed" => "x", "Variable" => Codec.gap(:variable)}
      assert {:ok, template} = Codec.compile_template(@schema, term)

      xml = Codec.render(template, %{variable: "Tom & Jerry"})
      assert {:ok, %{"Variable" => "Tom & Jerry"}} = Codec.parse(@schema, xml)
    end
  end
end
