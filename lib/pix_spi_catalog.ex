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

  ## Assinatura digital

  `sign/4`, `verify/2` e `generate_test_certificate/0` cobrem o dia a dia
  de quem consome a lib — assinar o que sua aplicação envia, verificar o
  que ela recebe, gerar certificado descartável pra testar. Por baixo,
  isso é implementado em `PixSpiCatalog.Xmldsig` (um módulo à parte, que
  não conhece estrutura de mensagem alguma — `<Sgntr>` é sempre tratado
  como opaco por esta camada de codec); vá direto lá só se precisar de
  controle mais fino (perfis com número de referência diferente, por
  exemplo).

      # certificate_der é o certificado de quem ASSINOU a mensagem — não
      # o seu: pra assinar o que você manda, é sua própria chave privada
      # e seu próprio certificado; pra verificar o que você recebe, é o
      # certificado de quem te mandou. Cada lado da conversa só precisa
      # da própria chave privada e do certificado público do outro lado
      # — nunca da chave privada alheia. Ver a seção de certificados no
      # README.
      signature_xml = PixSpiCatalog.sign(app_hdr_xml, document_xml, minha_chave_privada_der, meu_certificado_der)
      :ok = PixSpiCatalog.verify(envelope_recebido_xml, certificado_de_quem_enviou_der)
  """

  alias PixSpiCatalog.Xmldsig.{Signer, TestCA, Verifier}

  @doc """
  Assina `app_hdr_xml` + `document_xml` no perfil de três `<ds:Reference>`
  do Manual de Segurança do SFN. Ambos precisam já vir em forma canônica
  exclusiva — ver `PixSpiCatalog.Xmldsig.Signer.sign/4`, que esta função
  só encaminha.
  """
  @spec sign(binary(), binary(), binary(), binary()) :: binary()
  defdelegate sign(app_hdr_xml, document_xml, private_key_der, certificate_der), to: Signer

  @doc """
  Verifica a assinatura de `envelope_xml` contra `certificate_der` — o
  certificado que você confia para quem assinou. Encaminha para
  `PixSpiCatalog.Xmldsig.Verifier.verify/2`.
  """
  @spec verify(binary(), binary()) :: :ok | {:error, Verifier.error()}
  defdelegate verify(envelope_xml, certificate_der), to: Verifier

  @doc """
  Gera, em memória, um par de chave privada + certificado autoassinado
  para testes. **Nunca em produção** — ver `PixSpiCatalog.Xmldsig.TestCA`.
  """
  @spec generate_test_certificate() :: TestCA.ca()
  defdelegate generate_test_certificate, to: TestCA, as: :generate
end
