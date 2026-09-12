defmodule PixSpiCatalog.Gerado.Head001 do
  @moduledoc "BAH (`head.001`) — igual em toda mensagem do catálogo."

  def tipo,
    do: %PixSpiCatalog.Schema.TipoComplexo{
      conteudo: [
        %PixSpiCatalog.Schema.Elemento{
          tag: "Fr",
          tipo: %PixSpiCatalog.Schema.TipoComplexo{
            conteudo: [
              %PixSpiCatalog.Schema.Escolha{
                opcoes: [
                  %PixSpiCatalog.Schema.Elemento{
                    tag: "FIId",
                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                      conteudo: [
                        %PixSpiCatalog.Schema.Elemento{
                          tag: "FinInstnId",
                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                            conteudo: [
                              %PixSpiCatalog.Schema.Elemento{
                                tag: "Othr",
                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                  conteudo: [
                                    %PixSpiCatalog.Schema.Elemento{
                                      tag: "Id",
                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
                                        base: "string",
                                        pattern: "[0-9A-Z]{8}",
                                        enum: nil,
                                        max_length: 8,
                                        min_length: nil
                                      },
                                      min: 1,
                                      max: 1
                                    }
                                  ],
                                  atributos: [],
                                  texto: nil
                                },
                                min: 1,
                                max: 1
                              }
                            ],
                            atributos: [],
                            texto: nil
                          },
                          min: 1,
                          max: 1
                        }
                      ],
                      atributos: [],
                      texto: nil
                    },
                    min: 1,
                    max: 1
                  }
                ],
                min: 1,
                max: 1
              }
            ],
            atributos: [],
            texto: nil
          },
          min: 1,
          max: 1
        },
        %PixSpiCatalog.Schema.Elemento{
          tag: "To",
          tipo: %PixSpiCatalog.Schema.TipoComplexo{
            conteudo: [
              %PixSpiCatalog.Schema.Escolha{
                opcoes: [
                  %PixSpiCatalog.Schema.Elemento{
                    tag: "FIId",
                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                      conteudo: [
                        %PixSpiCatalog.Schema.Elemento{
                          tag: "FinInstnId",
                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                            conteudo: [
                              %PixSpiCatalog.Schema.Elemento{
                                tag: "Othr",
                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                  conteudo: [
                                    %PixSpiCatalog.Schema.Elemento{
                                      tag: "Id",
                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
                                        base: "string",
                                        pattern: "[0-9A-Z]{8}",
                                        enum: nil,
                                        max_length: 8,
                                        min_length: nil
                                      },
                                      min: 1,
                                      max: 1
                                    }
                                  ],
                                  atributos: [],
                                  texto: nil
                                },
                                min: 1,
                                max: 1
                              }
                            ],
                            atributos: [],
                            texto: nil
                          },
                          min: 1,
                          max: 1
                        }
                      ],
                      atributos: [],
                      texto: nil
                    },
                    min: 1,
                    max: 1
                  }
                ],
                min: 1,
                max: 1
              }
            ],
            atributos: [],
            texto: nil
          },
          min: 1,
          max: 1
        },
        %PixSpiCatalog.Schema.Elemento{
          tag: "BizMsgIdr",
          tipo: %PixSpiCatalog.Schema.TipoSimples{
            base: "string",
            pattern: "[M][0-9A-Z]{8}[a-zA-Z0-9]{23}",
            enum: nil,
            max_length: 32,
            min_length: nil
          },
          min: 1,
          max: 1
        },
        %PixSpiCatalog.Schema.Elemento{
          tag: "MsgDefIdr",
          tipo: %PixSpiCatalog.Schema.TipoSimples{
            base: "string",
            pattern: nil,
            enum: nil,
            max_length: 35,
            min_length: 1
          },
          min: 1,
          max: 1
        },
        %PixSpiCatalog.Schema.Elemento{
          tag: "CreDt",
          tipo: %PixSpiCatalog.Schema.TipoSimples{
            base: "dateTime",
            pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
            enum: nil,
            max_length: nil,
            min_length: nil
          },
          min: 1,
          max: 1
        },
        %PixSpiCatalog.Schema.Elemento{tag: "Sgntr", tipo: :opaco, min: 1, max: 1}
      ],
      atributos: [],
      texto: nil
    }
end
