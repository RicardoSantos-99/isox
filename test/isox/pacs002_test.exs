defmodule Isox.Pacs002Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Pacs002}

  @agora DateTime.utc_now() |> DateTime.truncate(:millisecond)

  @header %AppHdr{
    from_ispb: "87654321",
    to_ispb: "12345678",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: @agora
  }

  @message %Pacs002{
    msg_id: "M123456780123456789abcdefghijklm",
    created_at: @agora,
    orgnl_instr_id: "E12345678202609121030abcdefghijl",
    orgnl_end_to_end_id: "E12345678202609121030abcdefghijk",
    tx_sts: "ACSC"
  }

  test "monta e volta pra struct em 1.16, status de aceite sem reason" do
    assert {:ok, xml} = Pacs002.encode(@message, @header, :v1_16)
    assert {:ok, message, :v1_16} = Pacs002.decode(xml)

    assert message.orgnl_end_to_end_id == @message.orgnl_end_to_end_id
    assert message.tx_sts == "ACSC"
    assert message.sts_rsn_cd == nil
    assert message.sts_rsn_addtl_inf == []
  end

  test "rejeição com motivo e informação adicional vai e volta" do
    message = %{
      @message
      | tx_sts: "RJCT",
        sts_rsn_cd: "AC03",
        sts_rsn_addtl_inf: ["conta encerrada", "tentar outra vez em 24h"]
    }

    assert {:ok, xml} = Pacs002.encode(message, @header, :v1_17)
    assert {:ok, de_volta, :v1_17} = Pacs002.decode(xml)

    assert de_volta.tx_sts == "RJCT"
    assert de_volta.sts_rsn_cd == "AC03"
    assert de_volta.sts_rsn_addtl_inf == ["conta encerrada", "tentar outra vez em 24h"]
  end

  test "data/hora efetiva de liquidação e data original vão e voltam" do
    message = %{
      @message
      | fctv_intr_bk_sttlm_dt: @agora,
        orgnl_intr_bk_sttlm_dt: ~D[2026-09-12]
    }

    assert {:ok, xml} = Pacs002.encode(message, @header, :v1_16)
    assert {:ok, de_volta, :v1_16} = Pacs002.decode(xml)

    assert de_volta.fctv_intr_bk_sttlm_dt == @agora
    assert de_volta.orgnl_intr_bk_sttlm_dt == ~D[2026-09-12]
  end

  test "código de motivo novo em 1.17 (DS02) é rejeitado em 1.16" do
    message = %{@message | tx_sts: "RJCT", sts_rsn_cd: "DS02"}

    assert {:error, _reason} = Pacs002.encode(message, @header, :v1_16)
    assert {:ok, _xml} = Pacs002.encode(message, @header, :v1_17)
  end

  test "campo obrigatório ausente é rejeitado antes de montar XML" do
    message = %{@message | tx_sts: nil}

    assert {:error, reason} = Pacs002.encode(message, @header, :v1_16)
    assert reason =~ "tx_sts"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/pacs.002/1.17"><Nada/></Envelope>
    """

    assert {:error, _reason} = Pacs002.decode(outro_xml)
  end
end
