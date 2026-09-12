defmodule PixSpiCatalog.Reda022Test do
  use ExUnit.Case, async: true

  alias PixSpiCatalog.{AppHdr, Reda022}

  @cabecalho %AppHdr{
    ispb_origem: "00000000",
    ispb_destino: "11111111",
    biz_msg_idr: "M123456780123456789abcdefghijklm",
    criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond)
  }

  @contato %{
    tipo: :contato,
    phne_nb: "+55-1133333333",
    mob_nb: "+55-1166666666",
    fax_nb: "+55-1177777777",
    email_adr: "monitoramento@example.com",
    rspnsblty: "CONTATOPSP"
  }

  @diretor %{
    tipo: :diretor,
    nm: "Fulano Diretor de Tal",
    phne_nb: "+55-1144444444",
    mob_nb: "+55-1155555555",
    email_adr: "fulano@example.com",
    rspnsblty: "DIRETORPSP"
  }

  @tech_adr %{tipo: :tech_adr, tech_adr: "ABCD1234"}
  @mkt_spcfc_attr %{tipo: :mkt_spcfc_attr, val: "12345678901"}

  # o schema real exige ao menos 4 entradas em Mod (achado pela própria
  # validação de round-trip, não documentado no dump da árvore) — todo
  # teste usa os 4 tipos juntos, como o exemplo oficial faz.
  defp mensagem(mod) do
    %Reda022{
      msg_id: "M123456780123456789abcdefghijklm",
      criado_em: DateTime.utc_now() |> DateTime.truncate(:millisecond),
      ispb: "11111111",
      mod: mod
    }
  end

  test "as 4 modificações, monta e volta pra struct sem perder nenhum campo" do
    mod = [@contato, @diretor, @tech_adr, @mkt_spcfc_attr]

    assert {:ok, xml} = Reda022.build(mensagem(mod), @cabecalho, :v1_4)
    assert {:ok, de_volta, :v1_4} = Reda022.parse(xml)

    assert de_volta.mod == mod
    assert xml =~ "<Nm>Fulano Diretor de Tal</Nm>"
    assert xml =~ "<Nm>CPFDIRETOR</Nm>"
  end

  test "menos de 4 modificações é rejeitado (Mod exige ao menos 4 no schema real)" do
    assert {:error, motivo} = Reda022.build(mensagem([@contato]), @cabecalho, :v1_4)
    assert motivo =~ "Mod"
  end

  test "parse rejeita XML de outra mensagem" do
    outro_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Envelope xmlns="https://www.bcb.gov.br/pi/reda.022/1.4"><Nada/></Envelope>
    """

    assert {:error, _motivo} = Reda022.parse(outro_xml)
  end

  @caminho_exemplo Path.expand(
                     "../../../bacex/docs/bacen/catalogo_spi/v5.13.1/exemplos/reda022/reda.022_msg.xml",
                     __DIR__
                   )

  if File.exists?(@caminho_exemplo) do
    test "parseia o exemplo oficial real, com os dois ramos ambíguos de CtctDtls" do
      assert {:ok, mensagem, :v1_4} = Reda022.parse(File.read!(@caminho_exemplo))

      assert [contato, diretor, tech_adr, cpf] = mensagem.mod
      assert contato.tipo == :contato
      assert diretor.tipo == :diretor
      assert diretor.nm == "Fulano Diretor de Tal"
      assert tech_adr.tipo == :tech_adr
      assert cpf.tipo == :mkt_spcfc_attr
    end
  end
end
