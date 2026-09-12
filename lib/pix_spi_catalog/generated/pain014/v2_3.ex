defmodule PixSpiCatalog.Generated.Pain014.V2_3 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.014/2.3"
  def msg_def_idr, do: "pain.014.spi.2.3"

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
                  tag: "CdtrPmtActvtnReqStsRpt",
                  type: %PixSpiCatalog.Schema.ComplexType{
                    content: [
                      %PixSpiCatalog.Schema.Element{
                        tag: "GrpHdr",
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
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "InitgPty",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Id",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Choice{
                                          options: [
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "OrgId",
                                              type: %PixSpiCatalog.Schema.ComplexType{
                                                content: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Othr",
                                                    type: %PixSpiCatalog.Schema.ComplexType{
                                                      content: [
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "Id",
                                                          type: %PixSpiCatalog.Schema.SimpleType{
                                                            base: "string",
                                                            pattern: "[0]{14}",
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
                        tag: "OrgnlGrpInfAndSts",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "OrgnlMsgId",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: "[0]{32}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "OrgnlMsgNmId",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: "[0]{8}",
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
                        tag: "OrgnlPmtInfAndSts",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "OrgnlPmtInfId",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: "[a-zA-Z0-9]{1,35}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "TxInfAndSts",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "OrgnlEndToEndId",
                                    type: %PixSpiCatalog.Schema.SimpleType{
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
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "TxSts",
                                    type: %PixSpiCatalog.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["ACSP", "RJCT"],
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "StsRsnInf",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Rsn",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Prtry",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: [
                                                    "AB10",
                                                    "AC05",
                                                    "AC06",
                                                    "AG12",
                                                    "AM02",
                                                    "AM09",
                                                    "AM23",
                                                    "CRNC",
                                                    "DENC",
                                                    "DS27",
                                                    "DTED",
                                                    "DTNT",
                                                    "FCD1",
                                                    "FCD2",
                                                    "GRER",
                                                    "IRNT",
                                                    "MIDI",
                                                    "MSUC",
                                                    "NIEC",
                                                    "NIPA",
                                                    "NITX",
                                                    "QUNT",
                                                    "RC09",
                                                    "RR06",
                                                    "UDEI"
                                                  ],
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
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 0,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "DbtrDcsnDtTm",
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
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "OrgnlTxRef",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "CdtrAgt",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "FinInstnId",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "ClrSysMmbId",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "MmbId",
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
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
                                          tag: "Cdtr",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Id",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Choice{
                                                      options: [
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "PrvtId",
                                                          type: %PixSpiCatalog.Schema.ComplexType{
                                                            content: [
                                                              %PixSpiCatalog.Schema.Element{
                                                                tag: "Othr",
                                                                type:
                                                                  %PixSpiCatalog.Schema.ComplexType{
                                                                    content: [
                                                                      %PixSpiCatalog.Schema.Element{
                                                                        tag: "Id",
                                                                        type:
                                                                          %PixSpiCatalog.Schema.SimpleType{
                                                                            base: "string",
                                                                            pattern:
                                                                              "[0-9]{11}|[0-9A-Z]{12}[0-9]{2}",
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
                        max: :unbounded
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
