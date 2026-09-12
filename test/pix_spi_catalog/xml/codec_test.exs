defmodule PixSpiCatalog.Xml.CodecTest do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.Schema.{Atributo, Elemento, Escolha, TipoComplexo, TipoSimples}
  alias PixSpiCatalog.Xml.Codec

  test "parse e build de um elemento simples aninhado" do
    schema = %Elemento{
      tag: "Envelope",
      tipo: %TipoComplexo{conteudo: [%Elemento{tag: "Nome", tipo: %TipoSimples{}}]}
    }

    assert {:ok, termo} = Codec.parse(schema, "<Envelope><Nome>Fulano</Nome></Envelope>")
    assert termo == %{"Nome" => "Fulano"}

    assert {:ok, xml} = Codec.build(schema, termo)
    assert xml =~ ~s(<?xml version="1.0" encoding="UTF-8"?>)
    assert {:ok, ^termo} = Codec.parse(schema, xml)
  end

  test "elemento opcional ausente não aparece no termo, e build tolera a ausência" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [
          %Elemento{tag: "Obrigatorio", tipo: %TipoSimples{}},
          %Elemento{tag: "Opcional", tipo: %TipoSimples{}, min: 0}
        ]
      }
    }

    assert {:ok, %{"Obrigatorio" => "x"}} =
             Codec.parse(schema, "<E><Obrigatorio>x</Obrigatorio></E>")

    assert {:ok, xml} = Codec.build(schema, %{"Obrigatorio" => "x"})
    refute xml =~ "Opcional"
  end

  test "elemento obrigatório ausente é erro" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{conteudo: [%Elemento{tag: "X", tipo: %TipoSimples{}}]}
    }

    assert {:error, mensagem} = Codec.parse(schema, "<E></E>")
    assert mensagem =~ "X"
  end

  test "elemento repetido (maxOccurs ilimitado) vira lista, na ordem" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [%Elemento{tag: "Item", tipo: %TipoSimples{}, max: :ilimitado}]
      }
    }

    assert {:ok, %{"Item" => ["a", "b", "c"]}} =
             Codec.parse(schema, "<E><Item>a</Item><Item>b</Item><Item>c</Item></E>")

    assert {:ok, xml} = Codec.build(schema, %{"Item" => ["a", "b", "c"]})
    assert {:ok, %{"Item" => ["a", "b", "c"]}} = Codec.parse(schema, xml)
  end

  test "choice: usa a opção presente, ignora as demais" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [
          %Escolha{
            opcoes: [
              %Elemento{tag: "A", tipo: %TipoSimples{}},
              %Elemento{tag: "B", tipo: %TipoSimples{}}
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

  test "simpleContent + atributo (valor com moeda)" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [
          %Elemento{
            tag: "Valor",
            tipo: %TipoComplexo{
              texto: %TipoSimples{base: "decimal"},
              atributos: [%Atributo{tag: "Ccy", tipo: %TipoSimples{}}]
            }
          }
        ]
      }
    }

    assert {:ok, termo} = Codec.parse(schema, ~s(<E><Valor Ccy="BRL">1000.00</Valor></E>))
    assert termo == %{"Valor" => %{valor: "1000.00", atributos: %{"Ccy" => "BRL"}}}

    assert {:ok, xml} = Codec.build(schema, termo)
    assert xml =~ ~s(Ccy="BRL")
    assert xml =~ "1000.00"
    assert {:ok, ^termo} = Codec.parse(schema, xml)
  end

  test "opaco (Sgntr) captura o XML interno sem interpretar, vazio ou não" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{conteudo: [%Elemento{tag: "Sgntr", tipo: :opaco}]}
    }

    assert {:ok, %{"Sgntr" => ""}} = Codec.parse(schema, "<E><Sgntr/></E>")

    assert {:ok, %{"Sgntr" => interno}} =
             Codec.parse(schema, "<E><Sgntr><ds:Signature>xyz</ds:Signature></Sgntr></E>")

    assert interno =~ "xyz"
    assert {:ok, xml} = Codec.build(schema, %{"Sgntr" => interno})
    assert {:ok, %{"Sgntr" => ^interno}} = Codec.parse(schema, xml)
  end

  test "validação: pattern" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [%Elemento{tag: "Cod", tipo: %TipoSimples{pattern: "[A-Z]{4}"}}]
      }
    }

    assert {:ok, _} = Codec.parse(schema, "<E><Cod>ACCC</Cod></E>")
    assert {:error, mensagem} = Codec.parse(schema, "<E><Cod>abcd</Cod></E>")
    assert mensagem =~ "padrão"
  end

  test "validação: pattern casa o valor inteiro, não uma substring no meio" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [%Elemento{tag: "Cod", tipo: %TipoSimples{pattern: "[A-Z]{4}"}}]
      }
    }

    assert {:error, _} = Codec.parse(schema, "<E><Cod>XACCCX</Cod></E>")
  end

  test "validação: enum" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [%Elemento{tag: "Sts", tipo: %TipoSimples{enum: ["ACCC", "RJCT"]}}]
      }
    }

    assert {:ok, _} = Codec.parse(schema, "<E><Sts>RJCT</Sts></E>")
    assert {:error, _} = Codec.parse(schema, "<E><Sts>OUTRO</Sts></E>")
  end

  test "validação: max_length e min_length" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{
        conteudo: [%Elemento{tag: "X", tipo: %TipoSimples{max_length: 3, min_length: 2}}]
      }
    }

    assert {:ok, _} = Codec.parse(schema, "<E><X>ab</X></E>")
    assert {:error, _} = Codec.parse(schema, "<E><X>a</X></E>")
    assert {:error, _} = Codec.parse(schema, "<E><X>abcd</X></E>")
  end

  test "escapa e desescapa caracteres especiais em texto e atributo" do
    schema = %Elemento{
      tag: "E",
      tipo: %TipoComplexo{conteudo: [%Elemento{tag: "Nome", tipo: %TipoSimples{}}]}
    }

    termo = %{"Nome" => "Tom & Jerry <company>"}

    assert {:ok, xml} = Codec.build(schema, termo)
    assert {:ok, ^termo} = Codec.parse(schema, xml)
  end
end
