defmodule Isox.Registry do
  @moduledoc """
  Descobre os módulos `Isox.Generated.<Mensagem>.<Versao>` já
  carregados e despacha o parse pela combinação namespace + `MsgDefIdr`
  (ADR 0002) — os dois precisam concordar, ou é erro.
  """

  @doc """
  Todos os módulos gerados que expõem `namespace/0` (exclui o `Head001`,
  que não é mensagem). Lê a lista de módulos da aplicação compilada
  (`Application.spec/2`) em vez de `:code.all_loaded/0` — este só enxerga
  módulo já referenciado em tempo de execução, e nada aqui garante isso.
  """
  @spec generated_modules() :: [module()]
  def generated_modules do
    Application.load(:isox)

    for module <- Application.spec(:isox, :modules) || [],
        module != Isox.Generated.Head001,
        module |> Atom.to_string() |> String.starts_with?("Elixir.Isox.Generated."),
        Code.ensure_loaded?(module),
        function_exported?(module, :namespace, 0) do
      module
    end
  end

  @doc "Namespace do elemento raiz (`xmlns` do `<Envelope>`), sem fazer o parse completo."
  @spec xml_namespace(binary()) :: String.t() | nil
  def xml_namespace(xml) do
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
  @spec decode(binary()) ::
          {:ok, module(), term()}
          | {:error, {:unknown_namespace, String.t() | nil}}
          | {:error, {:msg_def_idr_mismatch, expected: String.t(), received: term()}}
          | {:error, String.t()}
  def decode(xml) do
    namespace = xml_namespace(xml)

    case Enum.find(generated_modules(), &(&1.namespace() == namespace)) do
      nil ->
        {:error, {:unknown_namespace, namespace}}

      module ->
        with {:ok, term} <- module.decode(xml) do
          check_msg_def_idr(module, term)
        end
    end
  end

  defp check_msg_def_idr(module, term) do
    received = get_in(term, ["AppHdr", "MsgDefIdr"])

    if received == module.msg_def_idr() do
      {:ok, module, term}
    else
      {:error, {:msg_def_idr_mismatch, expected: module.msg_def_idr(), received: received}}
    end
  end
end
