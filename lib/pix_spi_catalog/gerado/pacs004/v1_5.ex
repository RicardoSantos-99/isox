defmodule PixSpiCatalog.Gerado.Pacs004.V1_5 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pacs.004/1.5"
  def msg_def_idr, do: "pacs.004.spi.1.5"

  def schema do
    %PixSpiCatalog.Schema.Elemento{
      tag: "Envelope",
      tipo: %PixSpiCatalog.Schema.TipoComplexo{
        conteudo: [
          %PixSpiCatalog.Schema.Elemento{
            tag: "AppHdr",
            tipo: PixSpiCatalog.Gerado.Head001.tipo(),
            min: 1,
            max: 1
          },
          %PixSpiCatalog.Schema.Elemento{
            tag: "Document",
            tipo: %PixSpiCatalog.Schema.TipoComplexo{
              conteudo: [
                %PixSpiCatalog.Schema.Elemento{
                  tag: "PmtRtr",
                  tipo: %PixSpiCatalog.Schema.TipoComplexo{
                    conteudo: [
                      %PixSpiCatalog.Schema.Elemento{
                        tag: "GrpHdr",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "MsgId",
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
                              tag: "CreDtTm",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "dateTime",
                                pattern:
                                  "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
                                enum: nil,
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "NbOfTxs",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: "[0-9]{1,15}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "SttlmInf",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "SttlmMtd",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["CLRG"],
                                      max_length: nil,
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
                      },
                      %PixSpiCatalog.Schema.Elemento{
                        tag: "TxInf",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "RtrId",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern:
                                  "[D][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "OrgnlEndToEndId",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern:
                                  "[E][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "RtrdIntrBkSttlmAmt",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [],
                                atributos: [
                                  %PixSpiCatalog.Schema.Atributo{
                                    tag: "Ccy",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["BRL"],
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    obrigatorio: true
                                  }
                                ],
                                texto: %PixSpiCatalog.Schema.TipoSimples{
                                  base: "decimal",
                                  pattern: nil,
                                  enum: nil,
                                  max_length: nil,
                                  min_length: nil
                                }
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "SttlmPrty",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: nil,
                                enum: ["HIGH", "NORM"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "ChrgBr",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: nil,
                                enum: ["SLEV"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "RtrRsnInf",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Rsn",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Cd",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                base: "string",
                                                pattern: nil,
                                                enum: ["BE08", "FR01", "MD06", "SL02"],
                                                max_length: nil,
                                                min_length: nil
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
                                    tag: "AddtlInf",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                      base: "string",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: 105,
                                      min_length: 1
                                    },
                                    min: 0,
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
                              tag: "OrgnlTxRef",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "RmtInf",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "Ustrd",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
                                            base: "string",
                                            pattern: nil,
                                            enum: nil,
                                            max_length: 140,
                                            min_length: 1
                                          },
                                          min: 1,
                                          max: 1
                                        }
                                      ],
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 0,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "DbtrAgt",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "FinInstnId",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "ClrSysMmbId",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "MmbId",
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
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "CdtrAgt",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "FinInstnId",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "ClrSysMmbId",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "MmbId",
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
                        max: :ilimitado
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
        ]
      }
    }
  end

  def parse(xml), do: Codec.parse(schema(), xml)
  def build(termo), do: Codec.build(schema(), termo, namespace())
end
