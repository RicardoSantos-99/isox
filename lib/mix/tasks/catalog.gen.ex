defmodule Mix.Tasks.Catalog.Gen do
  @shortdoc "Gera os módulos de codec a partir dos XSDs de uma versão do catálogo do SPI"

  @moduledoc """
  Lê todos os `.xsd` de mensagem em `--xsd-dir` (exceto `xmldsig`, que não é
  mensagem) e gera, em `--out`, um módulo `PixSpiCatalog.Generated.<Mensagem>.<Versao>`
  por arquivo, mais `PixSpiCatalog.Generated.Head001` (o BAH, compartilhado —
  ADR 0004).

  Não redistribui XSD nenhum: só lê do caminho informado, nunca de um
  arquivo versionado neste repositório (ADR 0009).

      mix catalog.gen --xsd-dir /caminho/para/catalogo_spi/v5.13.1/xsd \\
                      --out lib/pix_spi_catalog/generated
  """

  use Mix.Task

  alias PixSpiCatalog.Generator
  alias PixSpiCatalog.Xsd.{Compiler, Reader}

  @impl Mix.Task
  def run(args) do
    {opts, _} = OptionParser.parse!(args, strict: [xsd_dir: :string, out: :string])
    xsd_dir = Keyword.fetch!(opts, :xsd_dir)
    out = Keyword.fetch!(opts, :out)

    files =
      xsd_dir
      |> Path.join("*.xsd")
      |> Path.wildcard()
      |> Enum.reject(&(Path.basename(&1) =~ "xmldsig"))
      |> Enum.sort()

    if files == [] do
      Mix.raise("Nenhum .xsd de mensagem encontrado em #{xsd_dir}")
    end

    generate_head001(hd(files), out)
    Enum.each(files, &generate_message(&1, out))

    Mix.shell().info("#{length(files)} mensagens geradas em #{out}")
  end

  defp generate_head001(reference_file, out) do
    read_result = Reader.read(reference_file)
    {:complex_type, head_node} = Map.fetch!(read_result.definitions, "SPI.head.001.001.01")
    type = Compiler.resolve_complex_type(head_node, read_result.definitions)

    write(Path.join(out, "head001.ex"), Generator.head001_source(type))
  end

  defp generate_message(path, out) do
    filename = path |> Path.basename(".xsd")
    {module, relative_path} = Generator.names(filename)

    read_result = Reader.read(path)
    root = Compiler.resolve_root(read_result)

    # o MsgDefIdr do catálogo é literalmente o nome do arquivo, sem a extensão
    source = Generator.message_source(module, root, read_result.namespace, filename)
    write(Path.join(out, relative_path), source)
  end

  defp write(path, source) do
    File.mkdir_p!(Path.dirname(path))
    formatted = source |> Code.format_string!() |> IO.iodata_to_binary()
    File.write!(path, formatted <> "\n")
    Mix.shell().info("  #{path}")
  end
end
