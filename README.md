# Isox

[![CI](https://github.com/RicardoSantos-99/isox/actions/workflows/ci.yml/badge.svg)](https://github.com/RicardoSantos-99/isox/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/isox.svg)](https://hex.pm/packages/isox)
[![Documentation](https://img.shields.io/badge/hexdocs-online-purple.svg)](https://hexdocs.pm/isox)
[![License](https://img.shields.io/hexpm/l/isox.svg)](LICENSE)

Codec ISO 20022 do catálogo de mensagens do SPI (Pix, Banco Central do
Brasil): `encode/2` e `decode/1` genéricos por envelope (cabeçalho +
mensagem), mais um módulo apartado de assinatura digital XMLDSig no
perfil do Manual de Segurança do SFN.

Esta lib não conhece transporte, nem qualquer regra de negócio de quem a
usa — só o formato das mensagens do catálogo.

## Instalação

Adicione `isox` às dependências no `mix.exs`:

```elixir
def deps do
  [
    {:isox, "~> 0.1.0"}
  ]
end
```

## Uso

Todo modelo do catálogo viaja com um cabeçalho comum (`Isox.AppHdr`) — os
dois juntos formam um `Isox.Envelope`, a entrada de `Isox.encode/2` e a
saída de `Isox.decode/1`. Exemplo com uma ordem de crédito (pacs.008):

```elixir
# truncado pra milissegundo porque é essa a precisão que o XML carrega de
# volta — sem truncar, o valor que volta do decode/1 não é `==` ao original
header = %Isox.AppHdr{
  from_ispb: "11111111",
  to_ispb: "22222222",
  biz_msg_idr: "M123456780123456789abcdefghijklm",
  created_at: DateTime.utc_now() |> DateTime.truncate(:millisecond)
}

mensagem = %Isox.Pacs008{
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

envelope = %Isox.Envelope{header: header, message: mensagem}

{:ok, xml} = Isox.encode(envelope, :v1_16)
{:ok, %Isox.Envelope{message: ^mensagem}, :v1_16} = Isox.decode(xml)
```

`Isox.decode/1` identifica sozinho, a partir do namespace do XML, tanto o
tipo da mensagem quanto a versão do schema — não precisa saber de
antemão que mensagem está chegando (por exemplo, ao receber XML de um
canal de ingestão).

Cada mensagem também tem seu próprio módulo de baixo nível, com a mesma
forma de API mas sem o envelope nem o despacho automático — útil se você
já sabe de antemão o tipo da mensagem:

```elixir
{:ok, xml} = Isox.Pacs008.encode(mensagem, header, :v1_16)
{:ok, ^mensagem, :v1_16} = Isox.Pacs008.decode(xml)
```

Mensagens cobertas: `Admi002`, `Admi004`, `Camt014`, `Camt025`, `Camt029`,
`Camt052`, `Camt053`, `Camt054`, `Camt055`, `Camt060`, `Pacs002`,
`Pacs004`, `Pacs008`, `Pain009`, `Pain011`, `Pain012`, `Pain013`,
`Pain014`, `Pibr001`, `Pibr002`, `Reda014`, `Reda016`, `Reda017`,
`Reda022`, `Reda031`, `Reda041`, `Trck002`.

### Lote (várias transações numa mensagem só)

11 mensagens do catálogo permitem lote de verdade — o elemento de
transação é `max: ilimitado` no XSD (`TxInf`, `CdtTrfTxInf`,
`TxInfAndSts`, `Rpt`, `Stmt`, `Ntfctn`, `Mndt`, `UndrlygAccptncDtls`,
`PmtInf`, `OrgnlPmtInfAndSts`, `Tx`): `Pacs002`, `Pacs004`, `Pacs008`,
`Camt052`, `Camt053`, `Camt054`, `Pain009`, `Pain012`, `Pain013`,
`Pain014`, `Trck002`. `Pacs002`/`Pacs004`/`Pacs008` têm exemplo oficial
do BCB com 10 transações numa mensagem só; os outros 8 aceitam lote pelo
mesmo motivo (o XSD permite), mesmo sem exemplo de lote no catálogo
atual.

`encode/3` aceita 1 mensagem OU uma lista (lote); `decode/1` devolve 1
struct OU uma lista, dependendo de quantos itens o XML traz — mesma
função, sem API paralela:

```elixir
# enviando um lote de 2 devoluções (pacs.004)
{:ok, xml} = Isox.Pacs004.encode([devolucao1, devolucao2], header, :v1_5)

# recebendo: decode devolve lista quando o XML trouxer mais de 1 item
{:ok, [d1, d2], :v1_5} = Isox.Pacs004.decode(xml)

# 1 mensagem continua funcionando igual, sem lista
{:ok, xml} = Isox.Pacs004.encode(devolucao1, header, :v1_5)
{:ok, ^devolucao1, :v1_5} = Isox.Pacs004.decode(xml)
```

`msg_id`/`created_at` (e, em `Pacs008`/`Pain012`, mais alguns campos de
`GrpHdr`) são únicos por mensagem XML, não por transação — em lote,
`encode/3` confere que todos os itens da lista concordam nesses campos
e erra explicitamente se não concordarem, em vez de usar o primeiro e
ignorar os outros em silêncio.

## Assinatura digital

Perfil de assinatura XMLDSig do Manual de Segurança do SFN Vol. II §3:
canonicalização XML exclusiva, RSA-SHA256, e o perfil de três
`<ds:Reference>` (`KeyInfo`, `AppHdr` com transformação
enveloped-signature, `Document` sem atributo `URI`).

```elixir
# app_hdr_xml e document_xml precisam já vir em forma canônica exclusiva
# — sign/4 não canonicaliza; a responsabilidade é de quem chama.
signature_xml = Isox.sign(app_hdr_xml, document_xml, minha_chave_privada_der, meu_certificado_der)

:ok = Isox.verify(envelope_recebido_xml, certificado_de_quem_assinou_der)
```

Por trás desses dois, `Isox.Xmldsig.{Signer, Verifier}` — vá
direto lá só se precisar de controle mais fino (montar um perfil com
outro número de `<ds:Reference>`, por exemplo).

### Certificados

Assinar e verificar usam **duas chaves diferentes, uma de cada lado da
conversa** — nunca as duas do mesmo lado:

- Pra **assinar** o que você envia: sua própria chave privada + seu
  próprio certificado.
- Pra **verificar** o que você recebe: o certificado público de quem
  assinou (nunca a chave privada de ninguém além da sua).

Ou seja: se você é um PSP falando com o Banco Central, você guarda **sua**
chave privada (pra assinar) e **o certificado público do Bacen**
(pra verificar as respostas dele) — nunca a chave privada do Bacen, que
só o Bacen tem. Do lado de quem simula o Bacen, é o espelho: chave
privada própria pra assinar respostas, certificado público de cada PSP
confiável pra verificar o que chega.

**Pra testar localmente**, gere dois pares (um representando cada lado):

```elixir
psp = Isox.generate_test_certificate()
bacen = Isox.generate_test_certificate()

signature_xml = Isox.sign(app_hdr_xml, document_xml, psp.private_key_der, psp.certificate_der)
# quem recebe verifica com o certificado do PSP, não com o próprio:
:ok = Isox.verify(envelope_xml, psp.certificate_der)
```

`Isox.generate_test_certificate/0` gera tudo em memória — **nunca
em produção**.

**Em produção**, chave privada não entra em código nem em variável de
ambiente em texto puro; o padrão comum é guardar caminhos de arquivo
(`.pem`) em config/env e decodificar pra DER na sua aplicação, não dentro
desta lib (que de propósito não lê arquivo, nem env, nem config — só
recebe bytes):

```elixir
defp load_der!(path) do
  [{_type, der, _cipher}] = path |> File.read!() |> :public_key.pem_decode()
  der
end

minha_chave_privada_der = load_der!(System.fetch_env!("PIX_PSP_PRIVATE_KEY_PATH"))
meu_certificado_der = load_der!(System.fetch_env!("PIX_PSP_CERT_PATH"))
certificado_do_bacen_der = load_der!(System.fetch_env!("PIX_BACEN_CERT_PATH"))
```

Para medir o throughput local de assinar/verificar:

```bash
MIX_ENV=test mix xmldsig.spike
```

## Gerando o schema a partir dos XSDs

Os XSDs publicados pelo Banco Central não são redistribuídos neste
pacote. Para gerar (ou regenerar) o codec a partir deles:

```bash
mix catalog.gen --xsd-dir /caminho/para/xsd --out lib/isox/generated
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
