defmodule Isox.Camt060Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Camt060}

  @header %AppHdr{
    from_ispb: "11111111",
    to_ispb: "00000000",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @message %Camt060{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
    reqd_msg_nm_id: "camt.053",
    acct_ownr_ispb: "11111111"
  }

  test "sem período nem tipo de saldo, monta e volta pra struct" do
    assert {:ok, xml} = Camt060.encode(@message, @header, :v1_9)
    assert {:ok, de_volta, :v1_9} = Camt060.decode(xml)
    assert de_volta.reqd_msg_nm_id == "camt.053"
    assert de_volta.rptg_prd_fr_dt == nil
    refute xml =~ "RptgPrd"
  end

  test "com período completo e tipo de saldo" do
    message = %{
      @message
      | rptg_prd_fr_dt: ~D[2026-09-01],
        rptg_prd_to_dt: ~D[2026-09-12],
        rptg_prd_fr_tm: ~T[00:00:00.000],
        rptg_prd_to_tm: ~T[23:59:59.000],
        reqd_bal_tp_prtry: "CSA"
    }

    assert {:ok, xml} = Camt060.encode(message, @header, :v1_9)
    assert {:ok, de_volta, :v1_9} = Camt060.decode(xml)

    assert de_volta.rptg_prd_fr_dt == ~D[2026-09-01]
    assert de_volta.rptg_prd_to_dt == ~D[2026-09-12]
    assert de_volta.rptg_prd_fr_tm == ~T[00:00:00.000]
    assert de_volta.rptg_prd_to_tm == ~T[23:59:59.000]
    assert de_volta.reqd_bal_tp_prtry == "CSA"
    assert xml =~ "<Tp>ALLL</Tp>"
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | reqd_msg_nm_id: nil}
    assert {:error, reason} = Camt060.encode(message, @header, :v1_9)
    assert reason =~ "reqd_msg_nm_id"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/camt.060/1.9"><Nada/></Envelope>
    """

    assert {:error, _reason} = Camt060.decode(outro_xml)
  end
end
