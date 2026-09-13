# AGENTS.md

Biblioteca publicada no Hex: codec ISO 20022 das mensagens do catálogo do
SPI (Pix), mais um módulo apartado de assinatura XMLDSig. Autocontida —
não depende de nenhum outro projeto para compilar, testar ou publicar.

## Fronteira desta lib

- Conhece o catálogo: mensagens, versões, `Isox.encode/2`/`Isox.decode/1`
  (por `Isox.Envelope`) e, por mensagem, `encode/3`/`decode/1` de baixo
  nível.
- Conhece o perfil de assinatura XMLDSig do Manual de Segurança do SFN
  (`Isox.Xmldsig`), como módulo à parte que não conhece estrutura
  de mensagem alguma — `<Sgntr>` é sempre opaco para o resto do codec.
- **Não** conhece transporte, streams, cenários, correlação de
  transação, nem qualquer regra de negócio de quem consome a lib.
- Não redistribui XSDs, exemplos nem planilhas do BCB. O gerador
  (`mix catalog.gen`) lê de um caminho fornecido em tempo de execução, nunca
  de arquivo versionado neste repositório.

## Convenções

- `mix format` sempre; `mix credo --strict` sem pendência.
- Comentário só quando o código sozinho não explica o porquê.
- Todo módulo novo tem teste. O motor genérico (XSD → schema, encode/decode)
  é testado com schemas sintéticos pequenos, sem depender dos XSDs reais.
  Os schemas gerados de verdade são testados à parte, por round-trip contra
  os exemplos oficiais do catálogo.
- Moduledocs e comentários em português.
- Nenhuma menção a IA, assistente ou ferramenta de geração em código,
  comentário ou commit.
- Toda função pública tem `@doc` e `@spec` (módulos gerados em
  `lib/isox/generated/` são a exceção deliberada: `@moduledoc
  false`, não fazem parte da API pública). `mix docs` deve gerar sem
  aviso de função pública sem documentação.
- Mudança visível de comportamento entra no `CHANGELOG.md`.
- `mix precommit` roda a escada completa — use antes de qualquer commit.
  `mix dialyzer` é separado (mais lento) — não faz parte do precommit,
  mas roda no CI.
