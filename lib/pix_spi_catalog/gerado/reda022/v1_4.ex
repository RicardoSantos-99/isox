defmodule PixSpiCatalog.Gerado.Reda022.V1_4 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/reda.022/1.4"
  def msg_def_idr, do: "reda.022.spi.1.4"

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
                  tag: "PtyModReq",
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
                            }
                          ],
                          atributos: [],
                          texto: nil
                        },
                        min: 1,
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
                            }
                          ],
                          atributos: [],
                          texto: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %PixSpiCatalog.Schema.Elemento{
                        tag: "Mod",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "ScpIndctn",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: nil,
                                enum: ["INSE"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "ReqdMod",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Escolha{
                                    opcoes: [
                                      %PixSpiCatalog.Schema.Elemento{
                                        tag: "CtctDtls",
                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                          conteudo: [
                                            %PixSpiCatalog.Schema.Escolha{
                                              opcoes: [
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "PhneNb",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "\\+(.+)-(.+)",
                                                    enum: nil,
                                                    max_length: 30,
                                                    min_length: nil
                                                  },
                                                  min: 1,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "MobNb",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "\\+(.+)-(.+)",
                                                    enum: nil,
                                                    max_length: 30,
                                                    min_length: nil
                                                  },
                                                  min: 0,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "FaxNb",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "\\+(.+)-(.+)",
                                                    enum: nil,
                                                    max_length: 30,
                                                    min_length: nil
                                                  },
                                                  min: 0,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "EmailAdr",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "(.+)@(.+)",
                                                    enum: nil,
                                                    max_length: 77,
                                                    min_length: nil
                                                  },
                                                  min: 1,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "Rspnsblty",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: nil,
                                                    enum: ["CONTATOPSP", "DIRETORPSP"],
                                                    max_length: nil,
                                                    min_length: nil
                                                  },
                                                  min: 1,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "Nm",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: nil,
                                                    enum: nil,
                                                    max_length: 140,
                                                    min_length: 1
                                                  },
                                                  min: 1,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "PhneNb",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "\\+(.+)-(.+)",
                                                    enum: nil,
                                                    max_length: 30,
                                                    min_length: nil
                                                  },
                                                  min: 1,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "MobNb",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "\\+(.+)-(.+)",
                                                    enum: nil,
                                                    max_length: 30,
                                                    min_length: nil
                                                  },
                                                  min: 0,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "EmailAdr",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "(.+)@(.+)",
                                                    enum: nil,
                                                    max_length: 77,
                                                    min_length: nil
                                                  },
                                                  min: 1,
                                                  max: 1
                                                },
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "Rspnsblty",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: nil,
                                                    enum: ["CONTATOPSP", "DIRETORPSP"],
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
                                        tag: "TechAdr",
                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                          conteudo: [
                                            %PixSpiCatalog.Schema.Escolha{
                                              opcoes: [
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "TechAdr",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: "[a-zA-Z0-9]{8}",
                                                    enum: nil,
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
                                        tag: "MktSpcfcAttr",
                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                          conteudo: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Nm",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                base: "string",
                                                pattern: nil,
                                                enum: ["CPFDIRETOR"],
                                                max_length: nil,
                                                min_length: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Val",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                base: "string",
                                                pattern: "[0-9]{11}",
                                                enum: nil,
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
                        min: 4,
                        max: 4
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
