defmodule Isox.Camt054Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Camt054}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Camt054{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    ntfctn_id: "M123456780123456789abcdefghijkln",
    acct_ispb: "11111111",
    value: "150.00",
    cdt_dbt_ind: "CRDT",
    sts_cd: "BOOK",
    bktxcd_domn_cd: "PMNT",
    bktxcd_fmly_cd: "IRCT",
    bktxcd_sub_fmly_cd: "DMCT",
    msg_nm_id: "pacs.008.spi.1.16",
    end_to_end_id: "E12345678202609121030abcdefghijk"
  }

  test "só com o obrigatório, monta e volta pra struct" do
    assert {:ok, xml} = Camt054.encode(@message, @header, :v1_16)
    assert {:ok, de_volta, :v1_16} = Camt054.decode(xml)

    assert de_volta.end_to_end_id == @message.end_to_end_id
    assert de_volta.dbtr_name == nil
    refute xml =~ "RltdPties"
  end

  test "com pagador e recebedor completos (RltdPties)" do
    message = %{
      @message
      | dbtr_name: "Fulano de Tal",
        dbtr_cpf_cnpj: "12345678901",
        dbtr_acct_id: "00012345",
        dbtr_acct_type: "CACC",
        cdtr_cpf_cnpj: "12345678000199",
        cdtr_acct_id: "00098765",
        cdtr_acct_type: "CACC",
        dbtr_agt_ispb: "11111111",
        cdtr_agt_ispb: "22222222",
        purp_cd: "IPAY",
        rmt_inf: "pagamento de teste"
    }

    assert {:ok, xml} = Camt054.encode(message, @header, :v1_16)
    assert {:ok, de_volta, :v1_16} = Camt054.decode(xml)

    assert de_volta.dbtr_name == "Fulano de Tal"
    assert de_volta.dbtr_cpf_cnpj == "12345678901"
    assert de_volta.cdtr_cpf_cnpj == "12345678000199"
    assert de_volta.dbtr_agt_ispb == "11111111"
    assert de_volta.cdtr_agt_ispb == "22222222"
    assert de_volta.purp_cd == "IPAY"
    assert de_volta.rmt_inf == "pagamento de teste"
  end

  test "lançamento de devolução, com RtrInf" do
    message = %{
      @message
      | cdt_dbt_ind: "DBIT",
        rtr_rsn_cd: "MD06",
        rtr_rsn_addtl_inf: "devolução solicitada"
    }

    assert {:ok, xml} = Camt054.encode(message, @header, :v1_15)
    assert {:ok, de_volta, :v1_15} = Camt054.decode(xml)

    assert de_volta.cdt_dbt_ind == "DBIT"
    assert de_volta.rtr_rsn_cd == "MD06"
    assert de_volta.rtr_rsn_addtl_inf == "devolução solicitada"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | end_to_end_id: nil}
    assert {:error, reason} = Camt054.encode(message, @header, :v1_16)
    assert reason =~ "end_to_end_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.054/1.16"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt054.decode(outro_xml)
  end
end
