defmodule Isox.Dictionary.Builder do
  @moduledoc false

  # Açúcar para escrever as entradas do dicionário sem repetir o nome de cada
  # chave 300 vezes. Interno: quem consome o dicionário lê `Isox.Dictionary`.

  alias Isox.Dictionary.Entry

  @spec entry(atom(), String.t() | nil, String.t(), keyword()) :: Entry.t()
  def entry(field, name_br, xml, opts) do
    %Entry{
      field: field,
      within: Keyword.get(opts, :within),
      name_br: name_br,
      xml: xml,
      type: Keyword.fetch!(opts, :type),
      length: Keyword.get(opts, :length),
      requirement: Keyword.get(opts, :requirement, :required),
      what: Keyword.fetch!(opts, :what),
      rule: Keyword.get(opts, :rule),
      codes: Keyword.get(opts, :codes)
    }
  end
end
