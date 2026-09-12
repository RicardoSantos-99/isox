defmodule PixSpiCatalog.Generated.Reda022.V1_4 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/reda.022/1.4"
  def msg_def_idr, do: "reda.022.spi.1.4"

  def schema do
    %PixSpiCatalog.Schema.Element{
      tag: "Envelope",
      type: %PixSpiCatalog.Schema.ComplexType{
        content: [
          %PixSpiCatalog.Schema.Element{
            tag: "AppHdr",
            type: PixSpiCatalog.Generated.Head001.type(),
            min: 1,
            max: 1
          },
          %PixSpiCatalog.Schema.Element{
            tag: "Document",
            type: %PixSpiCatalog.Schema.ComplexType{
              content: [
                %PixSpiCatalog.Schema.Element{
                  tag: "PtyModReq",
                  type: %PixSpiCatalog.Schema.ComplexType{
                    content: [
                      %PixSpiCatalog.Schema.Element{
                        tag: "MsgHdr",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "MsgId",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: "[M][0-9A-Z]{8}[a-zA-Z0-9]{23}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "CreDtTm",
                              type: %PixSpiCatalog.Schema.SimpleType{
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
                          attributes: [],
                          text: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %PixSpiCatalog.Schema.Element{
                        tag: "SysPtyId",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "Id",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Id",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Choice{
                                          options: [
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "PrtryId",
                                              type: %PixSpiCatalog.Schema.ComplexType{
                                                content: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Id",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "[0-9A-Z]{8}",
                                                      enum: nil,
                                                      max_length: 8,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Issr",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
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
                                                attributes: [],
                                                text: nil
                                              },
                                              min: 1,
                                              max: 1
                                            }
                                          ],
                                          min: 1,
                                          max: 1
                                        }
                                      ],
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 1,
                                    max: 1
                                  }
                                ],
                                attributes: [],
                                text: nil
                              },
                              min: 1,
                              max: 1
                            }
                          ],
                          attributes: [],
                          text: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %PixSpiCatalog.Schema.Element{
                        tag: "Mod",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "ScpIndctn",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["INSE"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "ReqdMod",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Choice{
                                    options: [
                                      %PixSpiCatalog.Schema.Element{
                                        tag: "CtctDtls",
                                        type: %PixSpiCatalog.Schema.ComplexType{
                                          content: [
                                            %PixSpiCatalog.Schema.Choice{
                                              options: [
                                                [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "PhneNb",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "MobNb",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 0,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "FaxNb",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 0,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "EmailAdr",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "(.+)@(.+)",
                                                      enum: nil,
                                                      max_length: 77,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Rspnsblty",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
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
                                                [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Nm",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: 140,
                                                      min_length: 1
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "PhneNb",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "MobNb",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 0,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "EmailAdr",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "(.+)@(.+)",
                                                      enum: nil,
                                                      max_length: 77,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Rspnsblty",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: ["CONTATOPSP", "DIRETORPSP"],
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  }
                                                ]
                                              ],
                                              min: 1,
                                              max: 1
                                            }
                                          ],
                                          attributes: [],
                                          text: nil
                                        },
                                        min: 1,
                                        max: 1
                                      },
                                      [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "TechAdr",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Choice{
                                                options: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "TechAdr",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
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
                                            attributes: [],
                                            text: nil
                                          },
                                          min: 1,
                                          max: 1
                                        }
                                      ],
                                      [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "MktSpcfcAttr",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Nm",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CPFDIRETOR"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Val",
                                                type: %PixSpiCatalog.Schema.SimpleType{
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
                                            attributes: [],
                                            text: nil
                                          },
                                          min: 1,
                                          max: 1
                                        }
                                      ]
                                    ],
                                    min: 1,
                                    max: 1
                                  }
                                ],
                                attributes: [],
                                text: nil
                              },
                              min: 1,
                              max: 1
                            }
                          ],
                          attributes: [],
                          text: nil
                        },
                        min: 4,
                        max: 4
                      }
                    ],
                    attributes: [],
                    text: nil
                  },
                  min: 1,
                  max: 1
                }
              ],
              attributes: [],
              text: nil
            },
            min: 1,
            max: 1
          }
        ]
      }
    }
  end

  def parse(xml), do: Codec.parse(schema(), xml)
  def build(term), do: Codec.build(schema(), term, namespace())
end
