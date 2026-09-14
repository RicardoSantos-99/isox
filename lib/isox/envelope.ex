defmodule Isox.Envelope do
  @moduledoc """
  Cabeçalho mais mensagem: o par que `Isox.encode/2` recebe e
  `Isox.decode/1` devolve.

  Não confundir com o `<Envelope>` do XML, que é o elemento raiz de toda
  mensagem do catálogo. Esta struct é só a representação em Elixir do
  mesmo par.
  """

  defstruct [:header, :message]

  @type t :: %__MODULE__{header: Isox.AppHdr.t(), message: struct()}
end
