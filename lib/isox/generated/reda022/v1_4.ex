defmodule Isox.Generated.Reda022.V1_4 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/reda.022/1.4"
  def msg_def_idr, do: "reda.022.spi.1.4"

  def schema do
    %Isox.Schema.Element{
      tag: "Envelope",
      type: %Isox.Schema.ComplexType{
        content: [
          %Isox.Schema.Element{
            tag: "AppHdr",
            type: Isox.Generated.Head001.type(),
            min: 1,
            max: 1
          },
          %Isox.Schema.Element{
            tag: "Document",
            type: %Isox.Schema.ComplexType{
              content: [
                %Isox.Schema.Element{
                  tag: "PtyModReq",
                  type: %Isox.Schema.ComplexType{
                    content: [
                      %Isox.Schema.Element{
                        tag: "MsgHdr",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "MsgId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: "[M][0-9A-Z]{8}[a-zA-Z0-9]{23}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "CreDtTm",
                              type: %Isox.Schema.SimpleType{
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
                      %Isox.Schema.Element{
                        tag: "SysPtyId",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "Id",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Id",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "PrtryId",
                                              type: %Isox.Schema.ComplexType{
                                                content: [
                                                  %Isox.Schema.Element{
                                                    tag: "Id",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "[0-9A-Z]{8}",
                                                      enum: nil,
                                                      max_length: 8,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "Issr",
                                                    type: %Isox.Schema.SimpleType{
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
                      %Isox.Schema.Element{
                        tag: "Mod",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "ScpIndctn",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["INSE"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "ReqdMod",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Choice{
                                    options: [
                                      %Isox.Schema.Element{
                                        tag: "CtctDtls",
                                        type: %Isox.Schema.ComplexType{
                                          content: [
                                            %Isox.Schema.Choice{
                                              options: [
                                                [
                                                  %Isox.Schema.Element{
                                                    tag: "PhneNb",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "MobNb",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 0,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "FaxNb",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 0,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "EmailAdr",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "(.+)@(.+)",
                                                      enum: nil,
                                                      max_length: 77,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "Rspnsblty",
                                                    type: %Isox.Schema.SimpleType{
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
                                                  %Isox.Schema.Element{
                                                    tag: "Nm",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: 140,
                                                      min_length: 1
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "PhneNb",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "MobNb",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "\\+(.+)-(.+)",
                                                      enum: nil,
                                                      max_length: 30,
                                                      min_length: nil
                                                    },
                                                    min: 0,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "EmailAdr",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: "(.+)@(.+)",
                                                      enum: nil,
                                                      max_length: 77,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "Rspnsblty",
                                                    type: %Isox.Schema.SimpleType{
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
                                        %Isox.Schema.Element{
                                          tag: "TechAdr",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Choice{
                                                options: [
                                                  %Isox.Schema.Element{
                                                    tag: "TechAdr",
                                                    type: %Isox.Schema.SimpleType{
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
                                        %Isox.Schema.Element{
                                          tag: "MktSpcfcAttr",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Nm",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CPFDIRETOR"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %Isox.Schema.Element{
                                                tag: "Val",
                                                type: %Isox.Schema.SimpleType{
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

  def decode(xml), do: Codec.parse(schema(), xml)
  def encode(term), do: Codec.build(schema(), term, namespace())
end
