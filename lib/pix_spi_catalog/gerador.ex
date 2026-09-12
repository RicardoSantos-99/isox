defmodule PixSpiCatalog.Gerador do
  @moduledoc """
  Emite, a partir do schema já resolvido (`Xsd.Compilador`), o texto-fonte
  de um módulo `PixSpiCatalog.Gerado.<Mensagem>.<Versao>` (ADR 0004).

  O `AppHdr` (BAH, `head.001`) é idêntico em todo XSD do catálogo — em vez
  de embutir uma cópia por mensagem, o módulo gerado referencia
  `PixSpiCatalog.Gerado.Head001.tipo/0` em tempo de execução.
  """

  alias PixSpiCatalog.Schema.Elemento

  @doc """
  Nome do módulo (`Elixir.PixSpiCatalog.Gerado.Pacs008.V1_16`) e o caminho
  relativo (`pacs008/v1_16.ex`), a partir do nome do arquivo XSD
  (ex.: `"pacs.008.spi.1.16"`).
  """
  @spec nomes(String.t()) :: {modulo :: String.t(), caminho :: String.t()}
  def nomes(nome_arquivo_sem_extensao) do
    [mensagem, versao] = String.split(nome_arquivo_sem_extensao, ".spi.", parts: 2)

    mensagem_modulo = mensagem |> String.split(".") |> Enum.map_join(&String.capitalize/1)
    versao_modulo = "V" <> String.replace(versao, ".", "_")

    modulo = "PixSpiCatalog.Gerado.#{mensagem_modulo}.#{versao_modulo}"
    caminho = "#{Macro.underscore(mensagem_modulo)}/v#{String.replace(versao, ".", "_")}.ex"

    {modulo, caminho}
  end

  @doc """
  Texto-fonte do módulo gerado para uma mensagem comum (com `AppHdr` +
  `Document`), dado o schema raiz já resolvido e os metadados do XSD.
  """
  @spec fonte_mensagem(String.t(), Elemento.t(), String.t(), String.t()) :: String.t()
  def fonte_mensagem(
        modulo,
        %Elemento{tag: "Envelope", tipo: %{conteudo: [apphdr, documento]}},
        namespace,
        msg_def_idr
      ) do
    %Elemento{tag: "AppHdr"} = apphdr
    %Elemento{tag: "Document"} = documento

    """
    defmodule #{modulo} do
      @moduledoc false

      alias PixSpiCatalog.Xml.Codec

      def namespace, do: #{inspect(namespace)}
      def msg_def_idr, do: #{inspect(msg_def_idr)}

      def schema do
        %PixSpiCatalog.Schema.Elemento{
          tag: "Envelope",
          tipo: %PixSpiCatalog.Schema.TipoComplexo{
            conteudo: [
              #{fonte_apphdr(apphdr)},
              #{inspect(documento, limit: :infinity, printable_limit: :infinity)}
            ]
          }
        }
      end

      def parse(xml), do: Codec.parse(schema(), xml)
      def build(termo), do: Codec.build(schema(), termo, namespace())
    end
    """
  end

  @doc "Texto-fonte do módulo do BAH, a partir do tipo já resolvido do AppHdr."
  @spec fonte_head001(String.t(), PixSpiCatalog.Schema.tipo()) :: String.t()
  def fonte_head001(modulo \\ "PixSpiCatalog.Gerado.Head001", tipo) do
    """
    defmodule #{modulo} do
      @moduledoc "BAH (`head.001`) — igual em toda mensagem do catálogo."

      def tipo, do: #{inspect(tipo, limit: :infinity, printable_limit: :infinity)}
    end
    """
  end

  defp fonte_apphdr(%Elemento{tag: tag, min: min, max: max}) do
    "%PixSpiCatalog.Schema.Elemento{tag: #{inspect(tag)}, tipo: PixSpiCatalog.Gerado.Head001.tipo(), min: #{inspect(min)}, max: #{inspect(max)}}"
  end
end
