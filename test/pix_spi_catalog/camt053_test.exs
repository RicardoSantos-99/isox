defmodule PixSpiCatalog.Camt053Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Camt053}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: @agora
  }

  test "sem saldo nenhum é rejeitado (Bal exige ao menos 1 no schema real)" do
    mensagem = %Camt053{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: @agora,
      stmt_id: "M123456780123456789abcdefghijkln",
      acct_ispb: "11111111"
    }

    assert {:error, motivo} = Camt053.build(mensagem, @cabecalho, :v1_4)
    assert motivo =~ "Bal"
  end

  test "com múltiplos tipos de saldo" do
    mensagem = %Camt053{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: @agora,
      stmt_id: "M123456780123456789abcdefghijkln",
      acct_ispb: "11111111",
      saldos: [
        %{tp_prtry: "SADP", valor: "1000.00", dt_tm: @agora},
        %{tp_prtry: "VSME", valor: "50.00", dt_tm: @agora}
      ]
    }

    assert {:ok, xml} = Camt053.build(mensagem, @cabecalho, :v1_4)
    assert {:ok, de_volta, :v1_4} = Camt053.parse(xml)
    assert length(de_volta.saldos) == 2
    assert de_volta.saldos == mensagem.saldos
    assert xml =~ "<CdtDbtInd>CRDT</CdtDbtInd>"
  end

  test "Stmt.Id aceita o sentinela de 32 zeros, além do formato normal" do
    mensagem = %Camt053{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: @agora,
      stmt_id: String.duplicate("0", 32),
      acct_ispb: "11111111",
      saldos: [%{tp_prtry: "SADP", valor: "0.00", dt_tm: @agora}]
    }

    assert {:ok, xml} = Camt053.build(mensagem, @cabecalho, :v1_4)
    assert {:ok, de_volta, :v1_4} = Camt053.parse(xml)
    assert de_volta.stmt_id == String.duplicate("0", 32)
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.053/1.4"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Camt053.parse(outro_xml)
  end
end
