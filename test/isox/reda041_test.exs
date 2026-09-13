defmodule Isox.Reda041Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Reda041}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  test "monta e volta pra struct, com uma alteração" do
    message = %Reda041{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      changes: [%{fld_nm: "NOME", od_fld_val: "Nome Antigo", new_fld_val: "Nome Novo"}]
    }

    assert {:ok, xml} = Reda041.encode(message, @header, :v1_7)
    assert {:ok, de_volta, :v1_7} = Reda041.decode(xml)
    assert de_volta.changes == message.changes
  end

  test "monta e volta pra struct, com múltiplas alterações" do
    message = %Reda041{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      changes: [
        %{fld_nm: "NOME", od_fld_val: "A", new_fld_val: "B"},
        %{fld_nm: "MODP", od_fld_val: "C", new_fld_val: "D"}
      ]
    }

    assert {:ok, xml} = Reda041.encode(message, @header, :v1_7)
    assert {:ok, de_volta, :v1_7} = Reda041.decode(xml)
    assert length(de_volta.changes) == 2
    assert de_volta.changes == message.changes
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.041/1.7"><Nada/></Envelope>
    """

    assert {:error, _reason} = Reda041.decode(outro_xml)
  end

  test "sem nenhuma alteração é rejeitado (Rcrd.Othr exige ao menos 1)" do
    message = %Reda041{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      changes: []
    }

    assert {:error, _reason} = Reda041.encode(message, @header, :v1_7)
  end

  test "mais de 3 alterações é rejeitado (Rcrd.Othr aceita no máximo 3)" do
    message = %Reda041{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      changes: [
        %{fld_nm: "NOME", od_fld_val: "A", new_fld_val: "B"},
        %{fld_nm: "MODP", od_fld_val: "C", new_fld_val: "D"},
        %{fld_nm: "NOMR", od_fld_val: "E", new_fld_val: "F"},
        %{fld_nm: "NOME", od_fld_val: "G", new_fld_val: "H"}
      ]
    }

    assert {:error, _reason} = Reda041.encode(message, @header, :v1_7)
  end
end
