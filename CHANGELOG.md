# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
este projeto segue [versionamento semântico](https://semver.org/lang/pt-BR/).

## [0.1.0] - Não lançado

Primeira versão pública.

### Adicionado

- Suporte real a lote (`encode/3` aceita 1 mensagem ou uma lista;
  `decode/1` devolve 1 struct ou uma lista, dependendo de quantos itens
  o XML traz) nas 11 mensagens cujo elemento de transação é
  `max: ilimitado` no XSD: `Pacs002`, `Pacs004`, `Pacs008`, `Camt052`,
  `Camt053`, `Camt054`, `Pain009`, `Pain012`, `Pain013`, `Pain014`,
  `Trck002`. Antes, mais de 1 transação virava
  `{:error, {:unsupported_batch, n}}` (issue #47) — agora é suportado de
  verdade, dos dois lados (enviar e receber), sem API paralela: a mesma
  `encode/3`/`decode/1`, só que polimórfica.
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

### Corrigido

- Validação de valor decimal (`fractionDigits`/`totalDigits`/`minInclusive`/
  `maxInclusive` do XSD, ex.: `ActiveCurrencyAndAmount_SimpleType`): não
  existia — um valor monetário negativo, com casas decimais a mais, com
  mais dígitos que o permitido, ou nem sequer numérico (`"abc"`) passava
  reto pelo `encode/3` de qualquer mensagem com campo de valor (`Pacs008`,
  `Pacs004`, `Camt053`, `Camt054`, `Pain009/011/012/013`, `Trck002`, entre
  outras). Achado no deep dive de validação do catálogo (issue #49).
- `xs:date` sem `pattern` no XSD (ex.: `OrgnlTxRef/IntrBkSttlmDt` do
  `Pacs002`): um valor não-data crashava (`ArgumentError`) em vez de
  devolver erro — o motor não validava `xs:date` de jeito nenhum quando
  o XSD não declarava pattern, e o crash acontecia fora da zona
  protegida do `parse/2`, direto em quem chama `decode/1`.
- Elemento repetido (`max: ilimitado`) que o modelo assume como exatamente
  1 (`TxInfAndSts` do `Pacs002`, `TxInf` do `Pacs004`, `CdtTrfTxInf` do
  `Pacs008`, e outros 8: `Camt052/053/054`, `Pain009/012/013/014`,
  `Trck002`): uma mensagem com mais de um item crashava (`MatchError`) em
  vez de devolver erro — confirmado com exemplos oficiais do BCB que vêm
  em lote (`pacs.002_SPI_10_msg.xml`, `pacs.004_SPI_10_msg.xml`,
  `pacs.008_CONTA_10_msg.xml`, entre outros). `decode/1` agora devolve
  `{:error, {:unsupported_batch, contagem}}` nesses 11 módulos — não
  passou a suportar lote, só parou de crashar por causa dele. Achado no
  deep dive de validação do catálogo (issue #47, pacs.002).

[0.1.0]: https://github.com/RicardoSantos-99/isox/releases/tag/v0.1.0
