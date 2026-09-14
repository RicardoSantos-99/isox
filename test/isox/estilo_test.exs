defmodule Isox.EstiloTest do
  @moduledoc """
  Travessão é proibido na documentação deste projeto. A regra é de estilo,
  mas some do radar sem alguém para cobrá-la: por isso é teste, não
  convenção escrita num arquivo que ninguém abre.
  """

  use ExUnit.Case, async: true

  # O caractere vem por codepoint para este arquivo não ser o único do
  # projeto a conter um travessão, o que faria o teste acusar a si mesmo.
  @travessao <<0x2014::utf8>>

  @arquivos Path.wildcard("lib/**/*.ex") ++
              Path.wildcard("test/**/*.exs") ++
              ["README.md", "CHANGELOG.md", "AGENTS.md", "SECURITY.md", "mix.exs", ".credo.exs"]

  test "nenhum travessão em código, documentação ou changelog" do
    com_travessao =
      for caminho <- @arquivos,
          File.exists?(caminho),
          linha_com_numero <- Enum.with_index(File.stream!(caminho), 1),
          {linha, numero} = linha_com_numero,
          String.contains?(linha, @travessao),
          do: "#{caminho}:#{numero}"

    assert com_travessao == [],
           "travessão encontrado em:\n" <> Enum.join(com_travessao, "\n")
  end
end
