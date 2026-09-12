defmodule PixSpiCatalog do
  @moduledoc """
  Codec das mensagens ISO 20022 do catálogo do SPI (Pix): `build/3` e
  `parse/1` por mensagem e versão, com o schema gerado a partir dos XSDs
  publicados pelo Banco Central (não redistribuídos aqui — ver
  `mix catalog.gen`).

  Não existe uma função genérica `build` ou `parse` direto neste módulo:
  cada mensagem tem seu próprio módulo, com uma struct de domínio e a
  mesma forma de API — por exemplo `PixSpiCatalog.Pacs008`:

      {:ok, xml} = PixSpiCatalog.Pacs008.build(mensagem, cabecalho, :v1_16)
      {:ok, mensagem, :v1_16} = PixSpiCatalog.Pacs008.parse(xml)

  `build/3` recebe a struct da mensagem, um `PixSpiCatalog.AppHdr` (o
  cabeçalho comum a toda mensagem do catálogo) e a versão do schema, e
  devolve o XML pronto (`AppHdr` + `Document`) já validado contra o
  schema. `parse/1` faz o caminho inverso e também devolve a versão
  detectada.

  Quando o tipo da mensagem não é conhecido de antemão (por exemplo, ao
  receber XML de um canal de entrada), use `PixSpiCatalog.Registry.parse/1`
  para descobrir o módulo gerado certo a partir do namespace do XML.

  Assinatura digital (perfil XMLDSig do SPI) é um módulo à parte,
  `PixSpiCatalog.Xmldsig`, que não conhece estrutura de mensagem alguma —
  `<Sgntr>` é sempre tratado como opaco por esta camada de codec.
  """
end
