defmodule Isox.Camt025Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Camt025}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "sem confirmação nenhuma é rejeitado (RctDtls exige ao menos 1 no schema real)" do
    message = %Camt025{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
    }

    assert {:error, reason} = Camt025.encode(message, @header, :v1_0)
    assert reason =~ "RctDtls"
  end

  test "confirmação de aceite, sem informar motivo" do
    message = %Camt025{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      confirmations: [
        %{
          orgnl_msg_id: "M123456780123456789abcdefghijklo",
          orgnl_pmt_id: "D12345678202609121030abcdefghijk",
          sts: "ACPT"
        }
      ]
    }

    assert {:ok, xml} = Camt025.encode(message, @header, :v1_0)
    assert {:ok, de_volta, :v1_0} = Camt025.decode(xml)
    assert [confirmation] = de_volta.confirmations
    assert confirmation.sts == "ACPT"
    assert confirmation.rsn_prtry == nil
    refute xml =~ "StsRsn"
  end

  test "várias confirmações, uma rejeitada com motivo e informação adicional" do
    message = %Camt025{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      confirmations: [
        %{
          orgnl_msg_id: "M123456780123456789abcdefghijklo",
          orgnl_pmt_id: "D12345678202609121030abcdefghijk",
          sts: "ACPT"
        },
        %{
          orgnl_msg_id: "M123456780123456789abcdefghijklp",
          orgnl_pmt_id: "D12345678202609121031abcdefghijk",
          sts: "RJCT",
          rsn_prtry: "AM01",
          addtl_inf: "fora do prazo de recência"
        }
      ]
    }

    assert {:ok, xml} = Camt025.encode(message, @header, :v1_0)
    assert {:ok, de_volta, :v1_0} = Camt025.decode(xml)
    assert length(de_volta.confirmations) == 2
    [_, rejeitada] = de_volta.confirmations
    assert rejeitada.sts == "RJCT"
    assert rejeitada.rsn_prtry == "AM01"
    assert rejeitada.addtl_inf == "fora do prazo de recência"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.025/1.0"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt025.decode(outro_xml)
  end
end
