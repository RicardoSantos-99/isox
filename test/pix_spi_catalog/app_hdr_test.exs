defmodule PixSpiCatalog.AppHdrTest do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.AppHdr

  test "termo/2 e de_termo/1 são inversos nos campos que de_termo conhece" do
    cabecalho = %AppHdr{
      ispb_origem: "12345678",
      ispb_destino: "87654321",
      biz_msg_idr: "M00000001abcdefghijklmnopqrstuv",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
    }

    termo = AppHdr.termo(cabecalho, "pacs.008.spi.1.16")

    assert termo["MsgDefIdr"] == "pacs.008.spi.1.16"
    assert termo["Sgntr"] == ""

    assert AppHdr.de_termo(termo) == %{cabecalho | criado_em: cabecalho.criado_em}
  end
end
