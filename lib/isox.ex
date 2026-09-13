defmodule Isox do
  @moduledoc """
  Codec das mensagens ISO 20022 do catálogo do SPI (Pix): `encode/2` e
  `decode/1` genéricos, que despacham pelo tipo do modelo (`encode/2`) ou
  pelo namespace do XML (`decode/1`) para o módulo certo — o schema é
  gerado a partir dos XSDs publicados pelo Banco Central (não
  redistribuídos aqui — ver `mix catalog.gen`).

      envelope = %Isox.Envelope{
        header: %Isox.AppHdr{...},
        message: %Isox.Pacs008{...}
      }

      {:ok, xml} = Isox.encode(envelope, :v1_16)
      {:ok, %Isox.Envelope{message: %Isox.Pacs008{}}, :v1_16} = Isox.decode(xml)

  `encode/2` recebe um `Isox.Envelope` (cabeçalho + modelo da mensagem) e
  a versão do schema, e devolve o XML pronto (`AppHdr` + `Document`) já
  validado contra o schema. `decode/1` faz o caminho inverso: identifica
  sozinho o tipo da mensagem e a versão a partir do namespace do XML, e
  devolve os dois de volta dentro de um `Isox.Envelope`.

  Cada mensagem do catálogo também tem seu próprio módulo, de baixo
  nível — mesma forma de API em todas, mas separada (cabeçalho e modelo
  como argumentos distintos, sem o envelope, e sem o despacho automático
  de tipo/versão). Útil se você já sabe de antemão qual mensagem está
  lidando e quer pular esse despacho — por exemplo, `Isox.Pacs008`:

      {:ok, xml} = Isox.Pacs008.encode(mensagem, cabecalho, :v1_16)
      {:ok, mensagem, :v1_16} = Isox.Pacs008.decode(xml)

  ## Assinatura digital

  `sign/4`, `verify/2` e `generate_test_certificate/0` cobrem o dia a dia
  de quem consome a lib — assinar o que sua aplicação envia, verificar o
  que ela recebe, gerar certificado descartável pra testar. Por baixo,
  isso é implementado em `Isox.Xmldsig` (um módulo à parte, que
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
      signature_xml = Isox.sign(app_hdr_xml, document_xml, minha_chave_privada_der, meu_certificado_der)
      :ok = Isox.verify(envelope_recebido_xml, certificado_de_quem_enviou_der)
  """

  alias Isox.{AppHdr, Envelope, Registry}
  alias Isox.Xmldsig.{Signer, TestCA, Verifier}

  @doc """
  Codifica um envelope (cabeçalho + modelo da mensagem) para XML, na
  versão de schema dada. Despacha pelo tipo do modelo em
  `envelope.message` para o módulo de baixo nível certo — por exemplo,
  `Isox.Pacs008.encode/3`, se `envelope.message` for um `Isox.Pacs008`.
  """
  @spec encode(Envelope.t(), atom()) :: {:ok, binary()} | {:error, term()}
  def encode(%Envelope{header: %AppHdr{} = header, message: %module{} = message}, version) do
    module.encode(message, header, version)
  end

  @doc """
  Decodifica um XML de qualquer mensagem do catálogo, identificando
  sozinho o tipo e a versão a partir do namespace — substitui
  `Isox.Registry.decode/1` como ponto de entrada principal para quem
  recebe XML sem saber de antemão que mensagem é.
  """
  @spec decode(binary()) :: {:ok, Envelope.t(), atom()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    with {:ok, generated_module, term} <- Registry.decode(xml),
         {:ok, wrapper} <- wrapper_module(generated_module),
         {:ok, message, version} <- wrapper.decode(xml) do
      {:ok, %Envelope{header: AppHdr.from_term(term["AppHdr"]), message: message}, version}
    end
  end

  # Isox.Generated.<Mensagem>.<Versao> -> Isox.<Mensagem> (ADR 0004): o
  # módulo de baixo nível achado pelo namespace e o módulo de mensagem que
  # sabe montar o modelo a partir dele têm sempre esses dois nomes, então
  # não precisa de mais uma tabela de despacho pra manter em dia.
  defp wrapper_module(generated_module) do
    case Module.split(generated_module) do
      ["Isox", "Generated", message_module, _version_module] ->
        {:ok, Module.concat(Isox, message_module)}

      _ ->
        {:error, {:unsupported_message, generated_module}}
    end
  end

  @doc """
  Assina `app_hdr_xml` + `document_xml` no perfil de três `<ds:Reference>`
  do Manual de Segurança do SFN. Ambos precisam já vir em forma canônica
  exclusiva — ver `Isox.Xmldsig.Signer.sign/4`, que esta função
  só encaminha.
  """
  @spec sign(binary(), binary(), binary(), binary()) :: binary()
  defdelegate sign(app_hdr_xml, document_xml, private_key_der, certificate_der), to: Signer

  @doc """
  Verifica a assinatura de `envelope_xml` contra `certificate_der` — o
  certificado que você confia para quem assinou. Encaminha para
  `Isox.Xmldsig.Verifier.verify/2`.
  """
  @spec verify(binary(), binary()) :: :ok | {:error, Verifier.error()}
  defdelegate verify(envelope_xml, certificate_der), to: Verifier

  @doc """
  Gera, em memória, um par de chave privada + certificado autoassinado
  para testes. **Nunca em produção** — ver `Isox.Xmldsig.TestCA`.
  """
  @spec generate_test_certificate() :: TestCA.ca()
  defdelegate generate_test_certificate, to: TestCA, as: :generate
end
