defmodule Isox.RoundTripTest do
  @moduledoc """
  Round-trip contra os exemplos oficiais do catálogo (issue #7): `parse`
  seguido de `build` deve reproduzir um XML que, reparseado, dá o mesmo
  termo — não byte a byte (`docs/roadmap.md`: "ou XML semanticamente
  idêntico"), porque nada aqui promete preservar espaço em branco ou tag
  vazia vs. `<Tag></Tag>`.

  Os XSDs e os exemplos do catálogo não são redistribuídos aqui: este
  teste lê de um caminho local, fora do controle de versão, apontado pela
  variável de ambiente `CATALOGO_SPI_DIR`. Sem essa variável (ex.: no CI),
  a suíte inteira é pulada — com aviso, não em silêncio.
  """

  alias Isox.Registry

  @catalog_path System.get_env("CATALOGO_SPI_DIR")

  @versions ["v5.12.1", "v5.13.1"]

  @catalog_present @catalog_path != nil and
                     Enum.any?(@versions, &File.dir?(Path.join(@catalog_path, &1)))

  use ExUnit.Case, async: true

  unless @catalog_present do
    @moduletag skip:
                 "catálogo do SPI não encontrado em #{@catalog_path} (defina CATALOGO_SPI_DIR)"
  end

  test "parse -> build -> parse é idempotente para todo exemplo oficial do catálogo" do
    examples =
      for version <- @versions,
          dir = Path.join([@catalog_path, version, "exemplos"]),
          File.dir?(dir),
          path <- Path.wildcard(Path.join(dir, "**/*.xml")) do
        {version, path}
      end

    assert examples != [], "nenhum exemplo .xml encontrado sob #{@catalog_path}"

    failures =
      examples
      |> Enum.map(fn {version, path} -> {version, path, check(path)} end)
      |> Enum.reject(fn {_version, _path, result} -> result == :ok end)

    report =
      Enum.map_join(failures, "\n", fn {version, path, error} ->
        "#{version} #{Path.relative_to(path, @catalog_path)}: #{inspect(error)}"
      end)

    assert failures == [],
           "#{length(failures)}/#{length(examples)} exemplos falharam no round-trip:\n#{report}"
  end

  defp check(path) do
    xml = File.read!(path)

    with {:ok, module, term} <- Registry.decode(xml),
         {:ok, built_xml} <- module.encode(term),
         {:ok, _module2, term2} <- Registry.decode(built_xml) do
      if term == term2, do: :ok, else: {:term_differs_after_rebuild, term, term2}
    end
  end
end
