defmodule Mix.Tasks.Catalog.Gen do
  @shortdoc "Gera os módulos de codec a partir dos XSDs de uma versão do catálogo do SPI"

  @moduledoc """
  Lê todos os `.xsd` de mensagem em `--xsd-dir` (exceto `xmldsig`, que não é
  mensagem) e gera, em `--out`, um módulo `PixSpiCatalog.Gerado.<Mensagem>.<Versao>`
  por arquivo, mais `PixSpiCatalog.Gerado.Head001` (o BAH, compartilhado —
  ADR 0004).

  Não redistribui XSD nenhum: só lê do caminho informado, nunca de um
  arquivo versionado neste repositório (ADR 0009).

      mix catalog.gen --xsd-dir /caminho/para/catalogo_spi/v5.13.1/xsd \\
                      --out lib/pix_spi_catalog/gerado
  """

  use Mix.Task

  alias PixSpiCatalog.Gerador
  alias PixSpiCatalog.Xsd.{Compilador, Leitor}

  @impl Mix.Task
  def run(args) do
    {opts, _} = OptionParser.parse!(args, strict: [xsd_dir: :string, out: :string])
    xsd_dir = Keyword.fetch!(opts, :xsd_dir)
    out = Keyword.fetch!(opts, :out)

    arquivos =
      xsd_dir
      |> Path.join("*.xsd")
      |> Path.wildcard()
      |> Enum.reject(&(Path.basename(&1) =~ "xmldsig"))
      |> Enum.sort()

    if arquivos == [] do
      Mix.raise("Nenhum .xsd de mensagem encontrado em #{xsd_dir}")
    end

    gerar_head001(hd(arquivos), out)
    Enum.each(arquivos, &gerar_mensagem(&1, out))

    Mix.shell().info("#{length(arquivos)} mensagens geradas em #{out}")
  end

  defp gerar_head001(arquivo_referencia, out) do
    lido = Leitor.ler(arquivo_referencia)
    {:complexo, no_head} = Map.fetch!(lido.definicoes, "SPI.head.001.001.01")
    tipo = Compilador.resolver_complexo(no_head, lido.definicoes)

    escrever(Path.join(out, "head001.ex"), Gerador.fonte_head001(tipo))
  end

  defp gerar_mensagem(caminho, out) do
    nome_arquivo = caminho |> Path.basename(".xsd")
    {modulo, caminho_relativo} = Gerador.nomes(nome_arquivo)

    lido = Leitor.ler(caminho)
    raiz = Compilador.resolver_raiz(lido)

    # o MsgDefIdr do catálogo é literalmente o nome do arquivo, sem a extensão
    fonte = Gerador.fonte_mensagem(modulo, raiz, lido.namespace, nome_arquivo)
    escrever(Path.join(out, caminho_relativo), fonte)
  end

  defp escrever(caminho, fonte) do
    File.mkdir_p!(Path.dirname(caminho))
    formatado = fonte |> Code.format_string!() |> IO.iodata_to_binary()
    File.write!(caminho, formatado <> "\n")
    Mix.shell().info("  #{caminho}")
  end
end
