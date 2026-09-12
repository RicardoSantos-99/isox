# PixSpiCatalog

Codec das mensagens do catálogo do SPI (Pix): `parse`, `build` e, para as
mensagens que o [`bacex`](https://github.com/RicardoSantos-99/bacex) já
implementa de ponta a ponta, `template`. Schema gerado a partir dos XSDs
publicados pelo BCB — ver ADR 0003 e ADR 0004 do `bacex`.

Os XSDs não são redistribuídos aqui. Para regerar os schemas:

```bash
mix catalog.gen --xsd-dir /caminho/para/docs/bacen/catalogo_spi/v5.13.1/xsd \
                --out lib/pix_spi_catalog/generated
```

## Uso

```elixir
{:ok, mensagem} = PixSpiCatalog.parse(xml_binario)
{:ok, xml_iodata} = PixSpiCatalog.build(mensagem)
```

Durante o desenvolvimento do `bacex`, esta lib entra como dependência de
caminho local (`{:pix_spi_catalog, path: "../pix_spi_catalog"}`), migrando
para o Hex quando a API estabilizar.

## Assinatura digital (`PixSpiCatalog.Xmldsig`)

Perfil de assinatura XMLDSig do Pix (Manual de Segurança do SFN Vol. II
§3) — canonicalização XML exclusiva, RSA-SHA256 e o perfil SPI de três
`<ds:Reference>` (KeyInfo, AppHdr enveloped, Document sem `URI`). Módulo
apartado do resto do codec — não conhece mensagens ISO 20022 — pensado
pra também servir o perfil do DICT (2 `<ds:Reference>`) quando existir
simulador para ele; ver ADR 0003 do `bacex`.

```elixir
# app_hdr_xml e document_xml precisam já vir em forma canônica — é o
# caminho de template do codec quem garante isso; sign/4 não canonicaliza.
signature_xml =
  PixSpiCatalog.Xmldsig.Signer.sign(app_hdr_xml, document_xml, private_key_der, certificate_der)

:ok = PixSpiCatalog.Xmldsig.Verifier.verify(envelope_xml, certificate_der)
```

Medir o throughput de assinar/verificar (ADR 0007 do `bacex`, gate da Fase 4):

```bash
MIX_ENV=test mix xmldsig.spike
```

Usa a CA de teste em `test/support/xmldsig_test_ca.ex` — stand-in mínimo,
não a versão completa com CERTPIA/CERTPIC (issue #34 do roadmap do `bacex`).
