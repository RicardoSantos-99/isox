defmodule PixSpiCatalog.Reda041Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Reda041}

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct, com uma alteração" do
    mensagem = %Reda041{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      alteracoes: [%{fld_nm: "NOME", od_fld_val: "Nome Antigo", new_fld_val: "Nome Novo"}]
    }

    assert {:ok, xml} = Reda041.build(mensagem, @cabecalho, :v1_7)
    assert {:ok, de_volta, :v1_7} = Reda041.parse(xml)
    assert de_volta.alteracoes == mensagem.alteracoes
  end

  test "monta e volta pra struct, com múltiplas alterações" do
    mensagem = %Reda041{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      alteracoes: [
        %{fld_nm: "NOME", od_fld_val: "A", new_fld_val: "B"},
        %{fld_nm: "MODP", od_fld_val: "C", new_fld_val: "D"}
      ]
    }

    assert {:ok, xml} = Reda041.build(mensagem, @cabecalho, :v1_7)
    assert {:ok, de_volta, :v1_7} = Reda041.parse(xml)
    assert length(de_volta.alteracoes) == 2
    assert de_volta.alteracoes == mensagem.alteracoes
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.041/1.7"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Reda041.parse(outro_xml)
  end
end
