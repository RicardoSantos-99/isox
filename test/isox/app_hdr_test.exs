defmodule Isox.AppHdrTest do
  use ExUnit.Case, async: true

  alias Isox.AppHdr

  test "term/2 e from_term/1 são inversos nos campos que from_term conhece" do
    header = %AppHdr{
      from_ispb: "12345678",
      to_ispb: "87654321",
      biz_msg_idr: "M00000001abcdefghijklmnopqrstuv",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
    }

    term = AppHdr.term(header, "pacs.008.spi.1.16")

    assert term["MsgDefIdr"] == "pacs.008.spi.1.16"
    assert term["Sgntr"] == ""

    assert AppHdr.from_term(term) == %{header | created_at: header.created_at}
  end
end
