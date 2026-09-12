defmodule PixSpiCatalog.Camt053Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Camt053}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  test "sem saldo nenhum é rejeitado (Bal exige ao menos 1 no schema real)" do
    message = %Camt053{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: @agora,
      stmt_id: "M123456780123456789abcdefghijkln",
      acct_ispb: "11111111"
    }

    assert {:error, reason} = Camt053.build(message, @header, :v1_4)
    assert reason =~ "Bal"
  end

  test "com múltiplos tipos de saldo" do
    message = %Camt053{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: @agora,
      stmt_id: "M123456780123456789abcdefghijkln",
      acct_ispb: "11111111",
      balances: [
        %{tp_prtry: "SADP", value: "1000.00", dt_tm: @agora},
        %{tp_prtry: "VSME", value: "50.00", dt_tm: @agora}
      ]
    }

    assert {:ok, xml} = Camt053.build(message, @header, :v1_4)
    assert {:ok, de_volta, :v1_4} = Camt053.parse(xml)
    assert length(de_volta.balances) == 2
    assert de_volta.balances == message.balances
    assert xml =~ "<CdtDbtInd>CRDT</CdtDbtInd>"
  end

  test "Stmt.Id aceita o sentinela de 32 zeros, além do formato normal" do
    message = %Camt053{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: @agora,
      stmt_id: String.duplicate("0", 32),
      acct_ispb: "11111111",
      balances: [%{tp_prtry: "SADP", value: "0.00", dt_tm: @agora}]
    }

    assert {:ok, xml} = Camt053.build(message, @header, :v1_4)
    assert {:ok, de_volta, :v1_4} = Camt053.parse(xml)
    assert de_volta.stmt_id == String.duplicate("0", 32)
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.053/1.4"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt053.parse(outro_xml)
  end
end
