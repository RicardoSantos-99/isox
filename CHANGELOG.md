# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
este projeto segue [versionamento semântico](https://semver.org/lang/pt-BR/).

## [0.1.0] - Não lançado

Primeira versão pública.

### Adicionado

- Codec `parse`/`build` tipado para as mensagens do catálogo do SPI:
  `Admi002`, `Admi004`, `Camt014`, `Camt025`, `Camt029`, `Camt052`,
  `Camt053`, `Camt054`, `Camt055`, `Camt060`, `Pacs002`, `Pacs004`,
  `Pacs008`, `Pain009`, `Pain011`, `Pain012`, `Pain013`, `Pain014`,
  `Pibr001`, `Pibr002`, `Reda014`, `Reda016`, `Reda017`, `Reda022`,
  `Reda031`, `Reda041`, `Trck002`.
- `PixSpiCatalog.Registry` para descobrir o módulo certo a partir do
  namespace de um XML de entrada, quando o tipo da mensagem não é
  conhecido de antemão.
- `mix catalog.gen`: gera o codec de cada mensagem a partir dos XSDs
  publicados pelo Banco Central (não redistribuídos neste pacote).
- `PixSpiCatalog.Xmldsig`: canonicalização XML exclusiva
  (`xml-exc-c14n#`), assinatura e verificação RSA-SHA256 no perfil do
  Manual de Segurança do SFN Vol. II (três `<ds:Reference>` — `KeyInfo`,
  `AppHdr`, `Document`), com `KeyInfo` por `X509IssuerSerial`.
  `PixSpiCatalog.Xmldsig.TestCA` para gerar certificados de teste em
  memória.
- `mix xmldsig.spike`: mede o throughput local de assinar/verificar.

[0.1.0]: https://github.com/RicardoSantos-99/pix_spi_catalog/releases/tag/v0.1.0
