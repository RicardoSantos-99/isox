defmodule PixSpiCatalog.RoundTripTest do
  @moduledoc """
  Round-trip contra os exemplos oficiais do catálogo (issue #7): `parse`
  seguido de `build` deve reproduzir um XML que, reparseado, dá o mesmo
  termo — não byte a byte (`docs/roadmap.md`: "ou XML semanticamente
  idêntico"), porque nada aqui promete preservar espaço em branco ou tag
  vazia vs. `<Tag></Tag>`.

  Os XSDs e os exemplos do catálogo não são redistribuídos (ADR 0009), e
  portanto não estão neste repositório: este teste lê de um caminho local,
  fora do controle de versão. Sem esse caminho (ex.: no CI), a suíte inteira
  é pulada — com aviso, não em silêncio.
  """

  alias PixSpiCatalog.Registro

  @caminho_catalogo System.get_env("CATALOGO_SPI_DIR") ||
                      Path.expand("../../../bacex/docs/bacen/catalogo_spi", __DIR__)

  @versoes ["v5.12.1", "v5.13.1"]

  @catalogo_presente Enum.any?(@versoes, &File.dir?(Path.join(@caminho_catalogo, &1)))

  use ExUnit.Case, async: true

  unless @catalogo_presente do
    @moduletag skip:
                 "catálogo do SPI não encontrado em #{@caminho_catalogo} (defina CATALOGO_SPI_DIR)"
  end

  test "parse -> build -> parse é idempotente para todo exemplo oficial do catálogo" do
    exemplos =
      for versao <- @versoes,
          dir = Path.join([@caminho_catalogo, versao, "exemplos"]),
          File.dir?(dir),
          caminho <- Path.wildcard(Path.join(dir, "**/*.xml")) do
        {versao, caminho}
      end

    assert exemplos != [], "nenhum exemplo .xml encontrado sob #{@caminho_catalogo}"

    falhas =
      exemplos
      |> Enum.map(fn {versao, caminho} -> {versao, caminho, checar(caminho)} end)
      |> Enum.reject(fn {_versao, _caminho, resultado} -> resultado == :ok end)

    relatorio =
      Enum.map_join(falhas, "\n", fn {versao, caminho, erro} ->
        "#{versao} #{Path.relative_to(caminho, @caminho_catalogo)}: #{inspect(erro)}"
      end)

    assert falhas == [],
           "#{length(falhas)}/#{length(exemplos)} exemplos falharam no round-trip:\n#{relatorio}"
  end

  defp checar(caminho) do
    xml = File.read!(caminho)

    with {:ok, modulo, termo} <- Registro.parse(xml),
         {:ok, xml_construido} <- modulo.build(termo),
         {:ok, _modulo2, termo2} <- Registro.parse(xml_construido) do
      if termo == termo2, do: :ok, else: {:termo_diferente_apos_rebuild, termo, termo2}
    end
  end
end
