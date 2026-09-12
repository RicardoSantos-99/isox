defmodule PixSpiCatalog.Gerado.Reda016.V1_5 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/reda.016/1.5"
  def msg_def_idr, do: "reda.016.spi.1.5"

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
                  tag: "PtyStsAdvc",
                  tipo: %PixSpiCatalog.Schema.TipoComplexo{
                    conteudo: [
                      %PixSpiCatalog.Schema.Elemento{
                        tag: "MsgHdr",
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
                              tag: "OrgnlBizInstr",
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
                        tag: "PtySts",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "Sts",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: nil,
                                enum: ["COMP", "QUED", "REJT"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "StsRsn",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Rsn",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Prtry",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                base: "string",
                                                pattern: nil,
                                                enum: [
                                                  "ATC7",
                                                  "CAI4",
                                                  "CP10",
                                                  "CTT9",
                                                  "DI11",
                                                  "DIR1",
                                                  "DIR2",
                                                  "EXP5",
                                                  "IND2",
                                                  "IND3",
                                                  "IND4",
                                                  "IND5",
                                                  "ITC6",
                                                  "PCH8",
                                                  "RP13"
                                                ],
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
                                  }
                                ],
                                atributos: [],
                                texto: nil
                              },
                              min: 0,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "SysPtyId",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Id",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "Id",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Escolha{
                                                opcoes: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "PrtryId",
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
                                                        },
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Issr",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                            base: "string",
                                                            pattern: nil,
                                                            enum: ["BCB"],
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
                                    tag: "RspnsblPtyId",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "Id",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Escolha{
                                                opcoes: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "PrtryId",
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
                                                        },
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Issr",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                            base: "string",
                                                            pattern: nil,
                                                            enum: ["BCB"],
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
                                    min: 0,
                                    max: 1
                                  }
                                ],
                                atributos: [],
                                texto: nil
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
