# AGENTS.md

Biblioteca de codec das mensagens do catálogo do SPI. Irmã do
[`bacex`](https://github.com/RicardoSantos-99/bacex) — a arquitetura e as
decisões (ADRs) vivem lá, não aqui.

## Fronteira desta lib

- Conhece o catálogo: mensagens, versões, `parse`/`build`/`template`.
- **Não** conhece transporte, streams, cenários, correlação de transação —
  isso é do `bacex`.
- **Não** assina nem verifica assinatura — isso é do `pix_xmldsig`. `<Sgntr>`
  é sempre opaco aqui.
- Não redistribui XSDs, XSDs de exemplo nem planilhas do BCB. O gerador
  (`mix catalog.gen`) lê de um caminho fornecido em tempo de execução, nunca
  de arquivo versionado neste repositório.

## Convenções

- `mix format` sempre; `mix credo --strict` sem pendência.
- Comentário só quando o código sozinho não explica o porquê.
- Todo módulo novo tem teste. O motor genérico (XSD → schema, parse/build)
  é testado com schemas sintéticos pequenos, sem depender dos XSDs reais.
  Os schemas gerados de verdade são testados à parte, por round-trip contra
  os exemplos oficiais do catálogo.
- Moduledocs e comentários em português.
- Nenhuma menção a IA, assistente ou ferramenta de geração em código,
  comentário ou commit.
- `mix precommit` roda a escada completa — use antes de qualquer commit.
