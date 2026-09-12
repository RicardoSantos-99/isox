defmodule PixSpiCatalog.Schema do
  @moduledoc """
  Estruturas do schema normalizado, derivado dos XSDs do catálogo (ADR
  0004). Uma árvore destas é o que o gerador (`Xsd.Compilador`) produz e o
  que o motor genérico (`Xml.Codec`) percorre para fazer `parse`/`build`.

  Não referencia tipo por nome: cada árvore já vem com todo tipo nomeado do
  XSD resolvido e embutido no lugar — não há indireção em tempo de execução.
  """

  defmodule Elemento do
    @moduledoc "Um `<xs:element>`: nome, tipo e cardinalidade."
    @enforce_keys [:tag, :tipo]
    defstruct [:tag, :tipo, min: 1, max: 1]

    @type t :: %__MODULE__{
            tag: String.t(),
            tipo: PixSpiCatalog.Schema.tipo(),
            min: non_neg_integer(),
            max: pos_integer() | :ilimitado
          }
  end

  defmodule Atributo do
    @moduledoc "Um atributo XML (ex.: `Ccy` em `<IntrBkSttlmAmt Ccy=\"BRL\">`)."
    @enforce_keys [:tag, :tipo]
    defstruct [:tag, :tipo, obrigatorio: true]

    @type t :: %__MODULE__{tag: String.t(), tipo: PixSpiCatalog.Schema.TipoSimples.t()}
  end

  defmodule TipoSimples do
    @moduledoc "Um `<xs:simpleType>` com `<xs:restriction>`: valida texto, não estrutura."
    defstruct base: "string", pattern: nil, enum: nil, max_length: nil, min_length: nil

    @type t :: %__MODULE__{
            base: String.t(),
            pattern: String.t() | nil,
            enum: [String.t()] | nil,
            max_length: pos_integer() | nil,
            min_length: pos_integer() | nil
          }
  end

  defmodule Escolha do
    @moduledoc "Um `<xs:choice>`: exatamente um dos elementos listados aparece (ou nenhum, se `min: 0`)."
    @enforce_keys [:opcoes]
    defstruct [:opcoes, min: 1, max: 1]

    @type t :: %__MODULE__{
            opcoes: [Elemento.t()],
            min: non_neg_integer(),
            max: pos_integer() | :ilimitado
          }
  end

  defmodule TipoComplexo do
    @moduledoc """
    Um `<xs:complexType>`: uma sequência de elementos/escolhas, mais,
    opcionalmente, atributos e conteúdo de texto simples (`simpleContent` +
    `extension` — ex.: `IntrBkSttlmAmt`, que tem valor e o atributo `Ccy`).
    """
    defstruct conteudo: [], atributos: [], texto: nil

    @type t :: %__MODULE__{
            conteudo: [Elemento.t() | Escolha.t()],
            atributos: [Atributo.t()],
            texto: TipoSimples.t() | nil
          }
  end

  @typedoc "Opaco (`xs:any`, usado só pelo `<Sgntr>`): o conteúdo não é interpretado."
  @type opaco :: :opaco

  @type tipo :: TipoSimples.t() | TipoComplexo.t() | opaco()
end
