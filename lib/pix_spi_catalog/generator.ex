defmodule PixSpiCatalog.Generator do
  # Emite, a partir do schema já resolvido (Xsd.Compiler), o texto-fonte de
  # um módulo PixSpiCatalog.Generated.<Mensagem>.<Versao> (ADR 0004).
  #
  # O AppHdr (BAH, head.001) é idêntico em todo XSD do catálogo — em vez de
  # embutir uma cópia por mensagem, o módulo gerado referencia
  # PixSpiCatalog.Generated.Head001.type/0 em tempo de execução.
  #
  # Suporte de mix catalog.gen — não é API pública da lib.
  @moduledoc false

  alias PixSpiCatalog.Schema.Element

  @doc """
  Nome do módulo (ex.: PixSpiCatalog.Generated.Pacs008.V1_16, como string
  com o prefixo `Elixir.`) e o caminho relativo (`pacs008/v1_16.ex`), a
  partir do nome do arquivo XSD (ex.: `"pacs.008.spi.1.16"`).
  """
  @spec names(String.t()) :: {module :: String.t(), path :: String.t()}
  def names(filename_without_extension) do
    [message, version] = String.split(filename_without_extension, ".spi.", parts: 2)

    message_module = message |> String.split(".") |> Enum.map_join(&String.capitalize/1)
    version_module = "V" <> String.replace(version, ".", "_")

    module = "PixSpiCatalog.Generated.#{message_module}.#{version_module}"
    path = "#{Macro.underscore(message_module)}/v#{String.replace(version, ".", "_")}.ex"

    {module, path}
  end

  @doc """
  Texto-fonte do módulo gerado para uma mensagem comum (com `AppHdr` +
  `Document`), dado o schema raiz já resolvido e os metadados do XSD.
  """
  @spec message_source(String.t(), Element.t(), String.t(), String.t()) :: String.t()
  def message_source(
        module,
        %Element{tag: "Envelope", type: %{content: [app_hdr, document]}},
        namespace,
        msg_def_idr
      ) do
    %Element{tag: "AppHdr"} = app_hdr
    %Element{tag: "Document"} = document

    """
    defmodule #{module} do
      @moduledoc false

      alias PixSpiCatalog.Xml.Codec

      def namespace, do: #{inspect(namespace)}
      def msg_def_idr, do: #{inspect(msg_def_idr)}

      def schema do
        %PixSpiCatalog.Schema.Element{
          tag: "Envelope",
          type: %PixSpiCatalog.Schema.ComplexType{
            content: [
              #{app_hdr_source(app_hdr)},
              #{inspect(document, limit: :infinity, printable_limit: :infinity)}
            ]
          }
        }
      end

      def parse(xml), do: Codec.parse(schema(), xml)
      def build(term), do: Codec.build(schema(), term, namespace())
    end
    """
  end

  @doc "Texto-fonte do módulo do BAH, a partir do tipo já resolvido do AppHdr."
  @spec head001_source(String.t(), PixSpiCatalog.Schema.element_type()) :: String.t()
  def head001_source(module \\ "PixSpiCatalog.Generated.Head001", type) do
    """
    defmodule #{module} do
      @moduledoc false

      def type, do: #{inspect(type, limit: :infinity, printable_limit: :infinity)}
    end
    """
  end

  defp app_hdr_source(%Element{tag: tag, min: min, max: max}) do
    "%PixSpiCatalog.Schema.Element{tag: #{inspect(tag)}, type: PixSpiCatalog.Generated.Head001.type(), min: #{inspect(min)}, max: #{inspect(max)}}"
  end
end
