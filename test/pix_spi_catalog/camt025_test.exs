defmodule PixSpiCatalog.Camt025Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Camt025}

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "sem confirmação nenhuma é rejeitado (RctDtls exige ao menos 1 no schema real)" do
    mensagem = %Camt025{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
    }

    assert {:error, motivo} = Camt025.build(mensagem, @cabecalho, :v1_0)
    assert motivo =~ "RctDtls"
  end

  test "confirmação de aceite, sem informar motivo" do
    mensagem = %Camt025{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      confirmacoes: [
        %{
          orgnl_msg_id: "M123456780123456789abcdefghijklo",
          orgnl_pmt_id: "D12345678202609121030abcdefghijk",
          sts: "ACPT"
        }
      ]
    }

    assert {:ok, xml} = Camt025.build(mensagem, @cabecalho, :v1_0)
    assert {:ok, de_volta, :v1_0} = Camt025.parse(xml)
    assert [confirmacao] = de_volta.confirmacoes
    assert confirmacao.sts == "ACPT"
    assert confirmacao.rsn_prtry == nil
    refute xml =~ "StsRsn"
  end

  test "várias confirmações, uma rejeitada com motivo e informação adicional" do
    mensagem = %Camt025{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      confirmacoes: [
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

    assert {:ok, xml} = Camt025.build(mensagem, @cabecalho, :v1_0)
    assert {:ok, de_volta, :v1_0} = Camt025.parse(xml)
    assert length(de_volta.confirmacoes) == 2
    [_, rejeitada] = de_volta.confirmacoes
    assert rejeitada.sts == "RJCT"
    assert rejeitada.rsn_prtry == "AM01"
    assert rejeitada.addtl_inf == "fora do prazo de recência"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.025/1.0"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Camt025.parse(outro_xml)
  end
end
