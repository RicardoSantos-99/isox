# PixSpiCatalog

[![CI](https://github.com/RicardoSantos-99/pix_spi_catalog/actions/workflows/ci.yml/badge.svg)](https://github.com/RicardoSantos-99/pix_spi_catalog/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/pix_spi_catalog.svg)](https://hex.pm/packages/pix_spi_catalog)
[![Documentation](https://img.shields.io/badge/hexdocs-online-purple.svg)](https://hexdocs.pm/pix_spi_catalog)
[![License](https://img.shields.io/hexpm/l/pix_spi_catalog.svg)](LICENSE)

Codec ISO 20022 do catálogo de mensagens do SPI (Pix, Banco Central do
Brasil): `build/3` e `parse/1` tipados por mensagem e versão, mais um
módulo apartado de assinatura digital XMLDSig no perfil do Manual de
Segurança do SFN.

Esta lib não conhece transporte, nem qualquer regra de negócio de quem a
usa — só o formato das mensagens do catálogo.

## Instalação

Adicione `pix_spi_catalog` às dependências no `mix.exs`:

```elixir
def deps do
  [
    {:pix_spi_catalog, "~> 0.1.0"}
  ]
end
```

## Uso

Cada mensagem do catálogo tem seu próprio módulo — mesma forma de API em
todas: `build/3` (struct de domínio + cabeçalho + versão → XML) e
`parse/1` (XML → struct de domínio + versão). Exemplo com uma ordem de
crédito (pacs.008):

```elixir
# truncado pra milissegundo porque é essa a precisão que o XML carrega de
# volta — sem truncar, o valor que volta do parse/1 não é `==` ao original
header = %PixSpiCatalog.AppHdr{
  from_ispb: "11111111",
  to_ispb: "22222222",
  biz_msg_idr: "M123456780123456789abcdefghijklm",
  created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
}

mensagem = %PixSpiCatalog.Pacs008{
  msg_id: "M123456780123456789abcdefghijklm",
  created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond),
  svc_lvl_prtry: "PAGPRI",
  end_to_end_id: "E11111111202609121030abcdefghijk",
  value: "150.00",
  accptnc_dt_tm: DateTime.utc_now() |> DateTime.truncate(:millisecond),
  lcl_instrm: "MANU",
  dbtr_name: "Fulano de Tal",
  dbtr_cpf_cnpj: "12345678901",
  dbtr_acct_id: "00012345",
  dbtr_agt_ispb: "11111111",
  cdtr_cpf_cnpj: "12345678000199",
  cdtr_acct_id: "00098765",
  cdtr_agt_ispb: "22222222",
  purp_cd: "IPAY"
}

{:ok, xml} = PixSpiCatalog.Pacs008.build(mensagem, header, :v1_16)
{:ok, ^mensagem, :v1_16} = PixSpiCatalog.Pacs008.parse(xml)
```

Quando o tipo da mensagem de entrada não é conhecido de antemão (por
exemplo, ao receber XML de um canal de ingestão), use
`PixSpiCatalog.Registry.parse/1` para descobrir o módulo gerado certo a
partir do namespace do XML.

Mensagens cobertas: `Admi002`, `Admi004`, `Camt014`, `Camt025`, `Camt029`,
`Camt052`, `Camt053`, `Camt054`, `Camt055`, `Camt060`, `Pacs002`,
`Pacs004`, `Pacs008`, `Pain009`, `Pain011`, `Pain012`, `Pain013`,
`Pain014`, `Pibr001`, `Pibr002`, `Reda014`, `Reda016`, `Reda017`,
`Reda022`, `Reda031`, `Reda041`, `Trck002`.

## Assinatura digital (`PixSpiCatalog.Xmldsig`)

Perfil de assinatura XMLDSig do Manual de Segurança do SFN Vol. II §3:
canonicalização XML exclusiva, RSA-SHA256, e o perfil de três
`<ds:Reference>` (`KeyInfo`, `AppHdr` com transformação
enveloped-signature, `Document` sem atributo `URI`). Módulo apartado do
resto do codec — não conhece estrutura de mensagem alguma.

```elixir
# app_hdr_xml e document_xml precisam já vir em forma canônica exclusiva
# — sign/4 não canonicaliza; a responsabilidade é de quem chama.
signature_xml =
  PixSpiCatalog.Xmldsig.Signer.sign(app_hdr_xml, document_xml, private_key_der, certificate_der)

:ok = PixSpiCatalog.Xmldsig.Verifier.verify(envelope_xml, certificate_der)
```

`PixSpiCatalog.Xmldsig.TestCA.generate/0` gera, em memória, um par de
chave e certificado autoassinado para testes — nunca use em produção.

Para medir o throughput local de assinar/verificar:

```bash
MIX_ENV=test mix xmldsig.spike
```

## Gerando o schema a partir dos XSDs

Os XSDs publicados pelo Banco Central não são redistribuídos neste
pacote. Para gerar (ou regenerar) o codec a partir deles:

```bash
mix catalog.gen --xsd-dir /caminho/para/xsd --out lib/pix_spi_catalog/generated
```

## Desenvolvimento

```bash
mix deps.get
mix precommit   # compila com warnings como erro, formata, credo --strict, testes
mix dialyzer    # análise estática (mais lento; não faz parte do precommit)
mix docs        # gera a documentação em doc/
```

Os testes de round-trip contra os exemplos oficiais do catálogo
precisam da variável `CATALOGO_SPI_DIR` apontando para um diretório local
com os XSDs e exemplos; sem ela, essa suíte é pulada.

## Licença

[MIT](LICENSE).
