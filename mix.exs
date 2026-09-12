defmodule PixSpiCatalog.MixProject do
  use Mix.Project

  @source_url "https://github.com/RicardoSantos-99/pix_spi_catalog"
  @version "0.1.0"

  def project do
    [
      app: :pix_spi_catalog,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      description: description(),
      package: package(),
      name: "PixSpiCatalog",
      source_url: @source_url,
      docs: docs(),
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  def cli do
    [preferred_envs: [precommit: :test, credo: :test, dialyzer: :test]]
  end

  def application do
    [
      extra_applications: [:logger, :xmerl, :crypto, :public_key]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Codec ISO 20022 do catálogo de mensagens do SPI (Pix) — parse/build " <>
      "tipado por mensagem e versão, mais um módulo apartado de assinatura " <>
      "XMLDSig (perfil do Manual de Segurança do SFN)."
  end

  defp package do
    [
      files: ~w(lib mix.exs .formatter.exs README.md CHANGELOG.md LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md", "LICENSE"],
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      precommit: [
        "compile --warnings-as-errors",
        "deps.unlock --unused",
        "format",
        "credo --strict",
        "test"
      ]
    ]
  end
end
