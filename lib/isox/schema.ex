defmodule Isox.Schema do
  # Estruturas do schema normalizado, derivado dos XSDs do catálogo (ADR
  # 0004). Uma árvore destas é o que o gerador (Xsd.Compiler) produz e o
  # que o motor genérico (Xml.Codec) percorre para fazer parse/build.
  #
  # Não referencia tipo por nome: cada árvore já vem com todo tipo nomeado
  # do XSD resolvido e embutido no lugar — não há indireção em tempo de
  # execução.
  #
  # Representação interna do schema — não é API pública da lib.
  @moduledoc false

  defmodule Element do
    # Um <xs:element>: nome, tipo e cardinalidade.
    @moduledoc false
    @enforce_keys [:tag, :type]
    defstruct [:tag, :type, min: 1, max: 1]

    @type t :: %__MODULE__{
            tag: String.t(),
            type: Isox.Schema.element_type(),
            min: non_neg_integer(),
            max: pos_integer() | :unbounded
          }
  end

  defmodule Attribute do
    # Um atributo XML (ex.: Ccy em <IntrBkSttlmAmt Ccy="BRL">).
    @moduledoc false
    @enforce_keys [:tag, :type]
    defstruct [:tag, :type, required: true]

    @type t :: %__MODULE__{tag: String.t(), type: Isox.Schema.SimpleType.t()}
  end

  defmodule SimpleType do
    # Um <xs:simpleType> com <xs:restriction>: valida texto, não estrutura.
    @moduledoc false
    defstruct base: "string", pattern: nil, enum: nil, max_length: nil, min_length: nil

    @type t :: %__MODULE__{
            base: String.t(),
            pattern: String.t() | nil,
            enum: [String.t()] | nil,
            max_length: pos_integer() | nil,
            min_length: pos_integer() | nil
          }
  end

  defmodule Choice do
    # Um <xs:choice>: exatamente uma das opções listadas aparece (ou
    # nenhuma, se min: 0). Uma opção é normalmente 1 elemento; quando vem
    # de xs:group ref= dentro do <xs:choice> e o grupo tem mais de 1
    # elemento, a opção é a lista de elementos do grupo inteiro — todos
    # aparecem juntos, ou nenhum (ex.: reda.022, ReqdModContatoChoice).
    @moduledoc false
    @enforce_keys [:options]
    defstruct [:options, min: 1, max: 1]

    @type t :: %__MODULE__{
            options: [Element.t() | [Element.t()]],
            min: non_neg_integer(),
            max: pos_integer() | :unbounded
          }
  end

  defmodule ComplexType do
    # Um <xs:complexType>: uma sequência de elementos/escolhas, mais,
    # opcionalmente, atributos e conteúdo de texto simples (simpleContent +
    # extension — ex.: IntrBkSttlmAmt, que tem valor e o atributo Ccy).
    @moduledoc false
    defstruct content: [], attributes: [], text: nil

    @type t :: %__MODULE__{
            content: [Element.t() | Choice.t()],
            attributes: [Attribute.t()],
            text: SimpleType.t() | nil
          }
  end

  # Opaco (xs:any, usado só pelo <Sgntr>): o conteúdo não é interpretado.
  @type opaque :: :opaque

  @type element_type :: SimpleType.t() | ComplexType.t() | opaque()
end
