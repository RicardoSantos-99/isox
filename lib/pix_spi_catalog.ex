defmodule PixSpiCatalog do
  @moduledoc """
  Codec das mensagens do catálogo do SPI: `parse`/`build`/`template` por
  mensagem e versão, com o schema gerado a partir dos XSDs do BCB (não
  redistribuídos aqui — ver `mix catalog.gen`).

  Trata `<Sgntr>` como opaco: assinatura é responsabilidade de outra
  biblioteca (`pix_xmldsig`).
  """
end
