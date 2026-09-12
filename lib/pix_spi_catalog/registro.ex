defmodule PixSpiCatalog.Registro do
  @moduledoc """
  Descobre os módulos `PixSpiCatalog.Gerado.<Mensagem>.<Versao>` já
  carregados e despacha o parse pela combinação namespace + `MsgDefIdr`
  (ADR 0002) — os dois precisam concordar, ou é erro.
  """

  @doc """
  Todos os módulos gerados que expõem `namespace/0` (exclui o `Head001`,
  que não é mensagem). Lê a lista de módulos da aplicação compilada
  (`Application.spec/2`) em vez de `:code.all_loaded/0` — este só enxerga
  módulo já referenciado em tempo de execução, e nada aqui garante isso.
  """
  @spec modulos_gerados() :: [module()]
  def modulos_gerados do
    Application.load(:pix_spi_catalog)

    for modulo <- Application.spec(:pix_spi_catalog, :modules) || [],
        modulo != PixSpiCatalog.Gerado.Head001,
        modulo |> Atom.to_string() |> String.starts_with?("Elixir.PixSpiCatalog.Gerado."),
        Code.ensure_loaded?(modulo),
        function_exported?(modulo, :namespace, 0) do
      modulo
    end
  end

  @doc "Namespace do elemento raiz (`xmlns` do `<Envelope>`), sem fazer o parse completo."
  @spec namespace_do_xml(binary()) :: String.t() | nil
  def namespace_do_xml(xml) do
    case Regex.run(~r/<Envelope[^>]*\sxmlns=["']([^"']+)["']/, xml) do
      [_, namespace] -> namespace
      nil -> nil
    end
  end

  @doc """
  Acha, entre os módulos gerados carregados, o que declara o `namespace` do
  XML; faz o parse com ele e confere que o `MsgDefIdr` recebido é
  exatamente o esperado por aquele módulo.
  """
  @spec parse(binary()) ::
          {:ok, module(), term()}
          | {:error, {:namespace_desconhecido, String.t() | nil}}
          | {:error, {:msg_def_idr_diverge, esperado: String.t(), recebido: term()}}
          | {:error, String.t()}
  def parse(xml) do
    namespace = namespace_do_xml(xml)

    case Enum.find(modulos_gerados(), &(&1.namespace() == namespace)) do
      nil ->
        {:error, {:namespace_desconhecido, namespace}}

      modulo ->
        with {:ok, termo} <- modulo.parse(xml) do
          conferir_msg_def_idr(modulo, termo)
        end
    end
  end

  defp conferir_msg_def_idr(modulo, termo) do
    recebido = get_in(termo, ["AppHdr", "MsgDefIdr"])

    if recebido == modulo.msg_def_idr() do
      {:ok, modulo, termo}
    else
      {:error, {:msg_def_idr_diverge, esperado: modulo.msg_def_idr(), recebido: recebido}}
    end
  end
end
