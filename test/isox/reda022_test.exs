defmodule Isox.Reda022Test do
  use ExUnit.Case, async: true

  alias Isox.{AppHdr, Reda022}

  @header %AppHdr{
    from_ispb: "00000000",
    to_ispb: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @contact %{
    type: :contact,
    phne_nb: "+55-1133333333",
    mob_nb: "+55-1166666666",
    fax_nb: "+55-1177777777",
    email_adr: "monitoramento@example.com",
    rspnsblty: "CONTATOPSP"
  }

  @director %{
    type: :director,
    nm: "Fulano Diretor de Tal",
    phne_nb: "+55-1144444444",
    mob_nb: "+55-1155555555",
    email_adr: "fulano@example.com",
    rspnsblty: "DIRETORPSP"
  }

  @tech_adr %{type: :tech_adr, tech_adr: "ABCD1234"}
  @mkt_spcfc_attr %{type: :mkt_spcfc_attr, val: "12345678901"}

  # o schema real exige ao menos 4 entradas em Mod (achado pela própria
  # validação de round-trip, não documentado no dump da árvore) — todo
  # teste usa os 4 tipos juntos, como o exemplo oficial faz.
  defp message(mod) do
    %Reda022{
      msg_id: "M123456780123456789abcdefghijklm",
      created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      mod: mod
    }
  end

  test "as 4 modificações, monta e volta pra struct sem perder nenhum campo" do
    mod = [@contact, @director, @tech_adr, @mkt_spcfc_attr]

    assert {:ok, xml} = Reda022.encode(message(mod), @header, :v1_4)
    assert {:ok, de_volta, :v1_4} = Reda022.decode(xml)

    assert de_volta.mod == mod
    assert xml =~ "<Nm>Fulano Diretor de Tal</Nm>"
    assert xml =~ "<Nm>CPFDIRETOR</Nm>"
  end

  test "menos de 4 modificações é rejeitado (Mod exige ao menos 4 no schema real)" do
    assert {:error, reason} = Reda022.encode(message([@contact]), @header, :v1_4)
    assert reason =~ "Mod"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.022/1.4"><Nada/></Envelope>
    """

    assert {:error, _reason} = Reda022.decode(outro_xml)
  end

  @example_path (case System.get_env("CATALOGO_SPI_DIR") do
                   nil -> nil
                   dir -> Path.join(dir, "v5.13.1/exemplos/reda022/reda.022_msg.xml")
                 end)

  if @example_path && File.exists?(@example_path) do
    test "parseia o exemplo oficial real, com os dois ramos ambíguos de CtctDtls" do
      assert {:ok, message, :v1_4} = Reda022.decode(File.read!(@example_path))

      assert [contact, director, tech_adr, cpf] = message.mod
      assert contact.type == :contact
      assert director.type == :director
      assert director.nm == "Fulano Diretor de Tal"
      assert tech_adr.type == :tech_adr
      assert cpf.type == :mkt_spcfc_attr
    end
  end
end
