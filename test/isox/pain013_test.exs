defmodule Isox.Pain013Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Pain013}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "22222222",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Pain013{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    pmt_inf_id: "PMTINF001",
    xpry_dt: ~D[2026-12-31],
    dbtr_cpf_cnpj: "12345678901",
    dbtr_agt_ispb: "11111111",
    end_to_end_id: "E12345678202609121030abcdefghijk",
    value: "100.00",
    mndt_id: "RR1234567820260912abcdefghijk",
    cdtr_agt_ispb: "22222222",
    cdtr_cpf_cnpj: "98765432100",
    cdtr_acct_id: "54321",
    cdtr_acct_type: "CACC",
    purp_prtry: "NTAG"
  }

  test "só com o obrigatório, monta e volta pra struct" do
    assert {:ok, xml} = Pain013.encode(@message, @header, :v2_2)
    assert {:ok, de_volta, :v2_2} = Pain013.decode(xml)

    assert de_volta.end_to_end_id == @message.end_to_end_id
    assert de_volta.value == "100.00"
    assert de_volta.mndt_id == @message.mndt_id
    assert xml =~ "<PmtMtd>TRF</PmtMtd>"
    assert xml =~ "<InstrPrty>NORM</InstrPrty>"
    assert xml =~ "<Prtry>PAGAGD</Prtry>"
    assert xml =~ ~s(<Othr><Id>00000000000000</Id></Othr>)
    refute xml =~ "ReqdExctnDt"
    refute xml =~ "UltmtDbtr"
  end

  test "com data de execução, devedor final e remessa opcionais" do
    message = %{
      @message
      | purp_prtry: "AGND",
        reqd_exctn_dt: @agora,
        ultmt_dbtr_name: "Empresa Final Ltda",
        ultmt_dbtr_cpf_cnpj: "12345678000199",
        rmt_inf: "pagamento agendado"
    }

    assert {:ok, xml} = Pain013.encode(message, @header, :v2_2)
    assert {:ok, de_volta, :v2_2} = Pain013.decode(xml)

    assert de_volta.reqd_exctn_dt == @agora
    assert de_volta.ultmt_dbtr_name == "Empresa Final Ltda"
    assert de_volta.rmt_inf == "pagamento agendado"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | mndt_id: nil}
    assert {:error, reason} = Pain013.encode(message, @header, :v2_2)
    assert reason =~ "mndt_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pain.013/2.2"><Nada/></Envelope>
    """

    assert {:error, _reason} = Pain013.decode(outro_xml)
  end

  test "purp_prtry AGND sem reqd_exctn_dt é rejeitado" do
    message = %{@message | purp_prtry: "AGND", reqd_exctn_dt: nil}

    assert {:error, reason} = Pain013.encode(message, @header, :v2_2)
    assert reason =~ "reqd_exctn_dt"
  end

  test "purp_prtry NTAG/RIFL com reqd_exctn_dt é rejeitado" do
    message = %{@message | purp_prtry: "NTAG", reqd_exctn_dt: @agora}

    assert {:error, reason} = Pain013.encode(message, @header, :v2_2)
    assert reason =~ "reqd_exctn_dt"

    message = %{@message | purp_prtry: "RIFL", reqd_exctn_dt: @agora}
    assert {:error, _reason} = Pain013.encode(message, @header, :v2_2)
  end

  test "Split Payment: Tax vai e volta com CNPJ do devedor" do
    message = %{
      @message
      | dbtr_cpf_cnpj: "12345678000199",
        tax_ref_nb: "NFE12345678901234567890",
        tax_records: [
          %{tp: "IBSSPLIT", ctgy: "INF", ttl_amt: "10.00"},
          %{tp: "IBSSPLIT", ctgy: "COR", ttl_amt: "12.00"},
          %{tp: "CBSSPLIT", ctgy: "INF", ttl_amt: "5.00"}
        ]
    }

    assert {:ok, xml} = Pain013.encode(message, @header, :v2_2)
    assert {:ok, de_volta, :v2_2} = Pain013.decode(xml)

    assert de_volta.tax_ref_nb == "NFE12345678901234567890"
    assert de_volta.tax_records == message.tax_records
  end

  test "Split Payment: bloco Tax exige CNPJ do devedor (rejeita CPF)" do
    message = %{
      @message
      | dbtr_cpf_cnpj: "12345678901",
        tax_records: [%{tp: "IBSSPLIT", ctgy: "INF", ttl_amt: "10.00"}]
    }

    assert {:error, reason} = Pain013.encode(message, @header, :v2_2)
    assert reason =~ "CNPJ"
  end

  test "Split Payment: cada tipo de tributo precisa de Record com ctgy INF" do
    message = %{
      @message
      | dbtr_cpf_cnpj: "12345678000199",
        tax_records: [%{tp: "IBSSPLIT", ctgy: "COR", ttl_amt: "10.00"}]
    }

    assert {:error, reason} = Pain013.encode(message, @header, :v2_2)
    assert reason =~ "INF"
  end

  test "Split Payment: soma dos tributos não pode exceder o valor da transação" do
    message = %{
      @message
      | dbtr_cpf_cnpj: "12345678000199",
        value: "100.00",
        tax_records: [%{tp: "IBSSPLIT", ctgy: "INF", ttl_amt: "999.00"}]
    }

    assert {:error, reason} = Pain013.encode(message, @header, :v2_2)
    assert reason =~ "tax_records"
  end
end
