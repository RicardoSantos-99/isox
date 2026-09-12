defmodule PixSpiCatalog.Camt014Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Camt014}

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @mensagem %Camt014{
    msg_id: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
    mmb_id_ispb: "11111111",
    mmb_nm: "Banco Exemplo S.A.",
    mmb_rtr_adr: "12345678000199",
    mmb_tp_cd: "DRCT",
    mmb_sts_cd: "ENBL",
    full_lgl_nm: "Banco Exemplo Sociedade Anônima",
    role_plyr_prtry: "ITUS"
  }

  test "monta e volta pra struct" do
    assert {:ok, xml} = Camt014.build(@mensagem, @cabecalho, :v1_6)
    assert {:ok, de_volta, :v1_6} = Camt014.parse(xml)
    assert de_volta == @mensagem
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | mmb_nm: nil}
    assert {:error, motivo} = Camt014.build(mensagem, @cabecalho, :v1_6)
    assert motivo =~ "mmb_nm"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.014/1.6"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Camt014.parse(outro_xml)
  end
end
