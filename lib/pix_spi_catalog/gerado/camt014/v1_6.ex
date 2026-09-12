defmodule PixSpiCatalog.Gerado.Camt014.V1_6 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.014/1.6"
  def msg_def_idr, do: "camt.014.spi.1.6"

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
                  tag: "RtrMmb",
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
                        tag: "RptOrErr",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Escolha{
                              opcoes: [
                                %PixSpiCatalog.Schema.Elemento{
                                  tag: "Rpt",
                                  tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                    conteudo: [
                                      %PixSpiCatalog.Schema.Elemento{
                                        tag: "MmbId",
                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                          conteudo: [
                                            %PixSpiCatalog.Schema.Escolha{
                                              opcoes: [
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
                                        tag: "MmbOrErr",
                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                          conteudo: [
                                            %PixSpiCatalog.Schema.Escolha{
                                              opcoes: [
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "Mmb",
                                                  tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                    conteudo: [
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
                                                        tag: "RtrAdr",
                                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                          conteudo: [
                                                            %PixSpiCatalog.Schema.Elemento{
                                                              tag: "Othr",
                                                              tipo:
                                                                %PixSpiCatalog.Schema.TipoComplexo{
                                                                  conteudo: [
                                                                    %PixSpiCatalog.Schema.Elemento{
                                                                      tag: "Id",
                                                                      tipo:
                                                                        %PixSpiCatalog.Schema.TipoSimples{
                                                                          base: "string",
                                                                          pattern:
                                                                            "[0-9A-Z]{12}[0-9]{2}",
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
                                                          atributos: [],
                                                          texto: nil
                                                        },
                                                        min: 1,
                                                        max: 1
                                                      },
                                                      %PixSpiCatalog.Schema.Elemento{
                                                        tag: "Tp",
                                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                          conteudo: [
                                                            %PixSpiCatalog.Schema.Escolha{
                                                              opcoes: [
                                                                %PixSpiCatalog.Schema.Elemento{
                                                                  tag: "Cd",
                                                                  tipo:
                                                                    %PixSpiCatalog.Schema.TipoSimples{
                                                                      base: "string",
                                                                      pattern: nil,
                                                                      enum: ["DRCT", "IDRT"],
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
                                                        tag: "Sts",
                                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                          conteudo: [
                                                            %PixSpiCatalog.Schema.Escolha{
                                                              opcoes: [
                                                                %PixSpiCatalog.Schema.Elemento{
                                                                  tag: "Cd",
                                                                  tipo:
                                                                    %PixSpiCatalog.Schema.TipoSimples{
                                                                      base: "string",
                                                                      pattern: nil,
                                                                      enum: ["DLTD", "ENBL"],
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
                        tag: "PtyRoleIdSD1",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "FullLglNm",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 350,
                                min_length: 1
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "RolePlyr",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Escolha{
                                    opcoes: [
                                      %PixSpiCatalog.Schema.Elemento{
                                        tag: "PtyRole",
                                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                          conteudo: [
                                            %PixSpiCatalog.Schema.Escolha{
                                              opcoes: [
                                                %PixSpiCatalog.Schema.Elemento{
                                                  tag: "Prtry",
                                                  tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                    base: "string",
                                                    pattern: nil,
                                                    enum: ["GOVE", "ITUS", "LESP", "PDCT"],
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
        ]
      }
    }
  end

  def parse(xml), do: Codec.parse(schema(), xml)
  def build(termo), do: Codec.build(schema(), termo, namespace())
end
