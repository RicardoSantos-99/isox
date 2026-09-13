defmodule Isox.Envelope do
  @moduledoc """
  Cabeçalho (`Isox.AppHdr`) + modelo de uma mensagem do catálogo — o par
  que `Isox.encode/2` recebe e `Isox.decode/1` devolve.

  Não confundir com o `<Envelope>` do XML (o elemento raiz de toda
  mensagem do catálogo): esta struct é só a representação em Elixir do
  mesmo par cabeçalho + mensagem.
  """

  defstruct [:header, :message]

  @type t :: %__MODULE__{header: Isox.AppHdr.t(), message: struct()}
end
