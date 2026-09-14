defmodule Isox.Dictionary.Entry do
  @moduledoc """
  Uma entrada do dicionário: tudo que se sabe sobre um campo de uma
  mensagem.

  Cada entrada amarra três coisas que, separadas, obrigam quem usa a lib a
  abrir a planilha do catálogo do lado: o nome do campo na struct do isox, o
  nome que o Banco Central dá a ele (`name_br`) e o caminho dele dentro do
  XML (`xml`).

  O `name_br` é o mais útil dos três. É por ele que se acha o campo em
  qualquer documento oficial do Pix, porque é o nome que o BCB usa na
  planilha, nos manuais e nas mensagens de erro.

  `within` marca campo que não fica solto na struct e sim dentro de uma lista
  de mapas, como cada saldo de `Isox.Camt053`. Nesse caso `within` aponta o
  campo da struct que carrega a lista.
  """

  @typedoc "Se o campo tem que ser preenchido, e sob que condição."
  @type requirement :: :required | :optional | :conditional

  @typedoc "Tipo base do campo, como o catálogo classifica."
  @type type :: :text | :numeric | :amount | :date | :datetime | :code | :indicator

  @type t :: %__MODULE__{
          field: atom(),
          within: atom() | nil,
          name_br: String.t() | nil,
          xml: String.t(),
          type: type(),
          length: String.t() | nil,
          requirement: requirement(),
          what: String.t(),
          rule: String.t() | nil,
          codes: %{optional(String.t()) => String.t()} | nil
        }

  @enforce_keys [:field, :xml, :type, :requirement, :what]
  defstruct [
    :field,
    :within,
    :name_br,
    :xml,
    :type,
    :length,
    :requirement,
    :what,
    :rule,
    codes: nil
  ]
end
