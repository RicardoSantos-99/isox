defmodule PixSpiCatalog.Camt052Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Camt052}

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @mensagem %Camt052{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
    rpt_id: "M123456780123456789abcdefghijkln",
    acct_ispb: "11111111",
    nb_of_ntries: "42",
    addtl_rpt_inf: "42 lancamentos no periodo"
  }

  test "monta e volta pra struct" do
    assert {:ok, xml} = Camt052.build(@mensagem, @cabecalho, :v1_3)
    assert {:ok, de_volta, :v1_3} = Camt052.parse(xml)
    assert de_volta == @mensagem
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | acct_ispb: nil}
    assert {:error, motivo} = Camt052.build(mensagem, @cabecalho, :v1_3)
    assert motivo =~ "acct_ispb"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.052/1.3"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Camt052.parse(outro_xml)
  end
end
