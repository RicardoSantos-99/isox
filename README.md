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
