# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
este projeto segue [versionamento semântico](https://semver.org/lang/pt-BR/).

## [0.1.0] - Não lançado

Primeira versão pública.

### Adicionado

- `Isox.encode/2` e `Isox.decode/1`: API genérica por `Isox.Envelope`
  (cabeçalho + modelo da mensagem), que despacha pelo tipo do modelo
  (`encode/2`) ou pelo namespace do XML (`decode/1`) — não precisa mais
  saber de antemão qual mensagem está sendo codificada ou decodificada.
- Codec `encode/3`/`decode/1` tipado por mensagem, de baixo nível, para
  as mensagens do catálogo do SPI: `Admi002`, `Admi004`, `Camt014`,
  `Camt025`, `Camt029`, `Camt052`, `Camt053`, `Camt054`, `Camt055`,
  `Camt060`, `Pacs002`, `Pacs004`, `Pacs008`, `Pain009`, `Pain011`,
  `Pain012`, `Pain013`, `Pain014`, `Pibr001`, `Pibr002`, `Reda014`,
  `Reda016`, `Reda017`, `Reda022`, `Reda031`, `Reda041`, `Trck002`.
- `Isox.Registry` para descobrir o módulo certo a partir do
  namespace de um XML de entrada, quando o tipo da mensagem não é
  conhecido de antemão (usado por `Isox.decode/1` por baixo).
- `mix catalog.gen`: gera o codec de cada mensagem a partir dos XSDs
  publicados pelo Banco Central (não redistribuídos neste pacote).
- `Isox.Xmldsig`: canonicalização XML exclusiva
  (`xml-exc-c14n#`), assinatura e verificação RSA-SHA256 no perfil do
  Manual de Segurança do SFN Vol. II (três `<ds:Reference>` — `KeyInfo`,
  `AppHdr`, `Document`), com `KeyInfo` por `X509IssuerSerial`.
  `Isox.Xmldsig.TestCA` para gerar certificados de teste em
  memória.
- `mix xmldsig.spike`: mede o throughput local de assinar/verificar.

[0.1.0]: https://github.com/RicardoSantos-99/isox/releases/tag/v0.1.0
