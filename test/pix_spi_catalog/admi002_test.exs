defmodule PixSpiCatalog.Admi002Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{Admi002, AppHdr}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "12345678",
    ispb_destino: "87654321",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  @mensagem %Admi002{
    ref: 24 |> :crypto.strong_rand_bytes() |> Base.encode64(),
    rjctg_pty_rsn: "XML malformado"
  }

  test "monta e volta pra struct, só com o obrigatório" do
    assert {:ok, xml} = Admi002.build(@mensagem, @cabecalho, :v1_5)
    assert {:ok, mensagem, :v1_5} = Admi002.parse(xml)

    assert mensagem.ref == @mensagem.ref
    assert mensagem.rjctg_pty_rsn == @mensagem.rjctg_pty_rsn
    assert mensagem.rjctn_dt_tm == nil
    assert mensagem.err_lctn == nil
  end

  test "ref referencia o PI-ResourceId da mensagem recusada" do
    resource_id = 24 |> :crypto.strong_rand_bytes() |> Base.encode64()
    mensagem = %{@mensagem | ref: resource_id}

    assert {:ok, xml} = Admi002.build(mensagem, @cabecalho, :v1_5)
    assert {:ok, de_volta, :v1_5} = Admi002.parse(xml)
    assert de_volta.ref == resource_id
  end

  test "campos opcionais de motivo vão e voltam quando presentes" do
    mensagem = %{
      @mensagem
      | rjctn_dt_tm: @agora,
        err_lctn: "Document/CdtTrfTxInf[1]/IntrBkSttlmAmt",
        rsn_desc: "valor não bate com o padrão esperado",
        addtl_data: "detalhe extra pra depuração"
    }

    assert {:ok, xml} = Admi002.build(mensagem, @cabecalho, :v1_5)
    assert {:ok, de_volta, :v1_5} = Admi002.parse(xml)

    assert de_volta.rjctn_dt_tm == @agora
    assert de_volta.err_lctn == mensagem.err_lctn
    assert de_volta.rsn_desc == mensagem.rsn_desc
    assert de_volta.addtl_data == mensagem.addtl_data
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    mensagem = %{@mensagem | rjctg_pty_rsn: nil}

    assert {:error, motivo} = Admi002.build(mensagem, @cabecalho, :v1_5)
    assert motivo =~ "rjctg_pty_rsn"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/admi.002/1.5"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Admi002.parse(outro_xml)
  end
end
