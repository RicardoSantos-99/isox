defmodule Isox.Generated.Pain014.V2_3 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.014/2.3"
  def msg_def_idr, do: "pain.014.spi.2.3"

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
                  tag: "CdtrPmtActvtnReqStsRpt",
                  type: %Isox.Schema.ComplexType{
                    content: [
                      %Isox.Schema.Element{
                        tag: "GrpHdr",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "MsgId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: "[M][0-9A-Z]{8}[a-zA-Z0-9]{23}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil,
                                fraction_digits: nil,
                                total_digits: nil,
                                min_inclusive: nil,
                                max_inclusive: nil
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
                                min_length: nil,
                                fraction_digits: nil,
                                total_digits: nil,
                                min_inclusive: nil,
                                max_inclusive: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "InitgPty",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Id",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "OrgId",
                                              type: %Isox.Schema.ComplexType{
                                                content: [
                                                  %Isox.Schema.Element{
                                                    tag: "Othr",
                                                    type: %Isox.Schema.ComplexType{
                                                      content: [
                                                        %Isox.Schema.Element{
                                                          tag: "Id",
                                                          type: %Isox.Schema.SimpleType{
                                                            base: "string",
                                                            pattern: "[0]{14}",
                                                            enum: nil,
                                                            max_length: nil,
                                                            min_length: nil,
                                                            fraction_digits: nil,
                                                            total_digits: nil,
                                                            min_inclusive: nil,
                                                            max_inclusive: nil
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
                      %Isox.Schema.Element{
                        tag: "OrgnlGrpInfAndSts",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "OrgnlMsgId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: "[0]{32}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil,
                                fraction_digits: nil,
                                total_digits: nil,
                                min_inclusive: nil,
                                max_inclusive: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "OrgnlMsgNmId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: "[0]{8}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil,
                                fraction_digits: nil,
                                total_digits: nil,
                                min_inclusive: nil,
                                max_inclusive: nil
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
                        tag: "OrgnlPmtInfAndSts",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "OrgnlPmtInfId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: "[a-zA-Z0-9]{1,35}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil,
                                fraction_digits: nil,
                                total_digits: nil,
                                min_inclusive: nil,
                                max_inclusive: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "TxInfAndSts",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "OrgnlEndToEndId",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern:
                                        "[E][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
                                      enum: nil,
                                      max_length: 32,
                                      min_length: nil,
                                      fraction_digits: nil,
                                      total_digits: nil,
                                      min_inclusive: nil,
                                      max_inclusive: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "TxSts",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["ACSP", "RJCT"],
                                      max_length: nil,
                                      min_length: nil,
                                      fraction_digits: nil,
                                      total_digits: nil,
                                      min_inclusive: nil,
                                      max_inclusive: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "StsRsnInf",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Rsn",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Prtry",
                                                type: %Isox.Schema.SimpleType{
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
                                                  min_length: nil,
                                                  fraction_digits: nil,
                                                  total_digits: nil,
                                                  min_inclusive: nil,
                                                  max_inclusive: nil
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
                                  %Isox.Schema.Element{
                                    tag: "DbtrDcsnDtTm",
                                    type: %Isox.Schema.SimpleType{
                                      base: "dateTime",
                                      pattern:
                                        "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
                                      enum: nil,
                                      max_length: nil,
                                      min_length: nil,
                                      fraction_digits: nil,
                                      total_digits: nil,
                                      min_inclusive: nil,
                                      max_inclusive: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "OrgnlTxRef",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "CdtrAgt",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "FinInstnId",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "ClrSysMmbId",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "MmbId",
                                                            type: %Isox.Schema.SimpleType{
                                                              base: "string",
                                                              pattern: "[0-9A-Z]{8}",
                                                              enum: nil,
                                                              max_length: 8,
                                                              min_length: nil,
                                                              fraction_digits: nil,
                                                              total_digits: nil,
                                                              min_inclusive: nil,
                                                              max_inclusive: nil
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
                                        %Isox.Schema.Element{
                                          tag: "Cdtr",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Id",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Choice{
                                                      options: [
                                                        %Isox.Schema.Element{
                                                          tag: "PrvtId",
                                                          type: %Isox.Schema.ComplexType{
                                                            content: [
                                                              %Isox.Schema.Element{
                                                                tag: "Othr",
                                                                type: %Isox.Schema.ComplexType{
                                                                  content: [
                                                                    %Isox.Schema.Element{
                                                                      tag: "Id",
                                                                      type:
                                                                        %Isox.Schema.SimpleType{
                                                                          base: "string",
                                                                          pattern:
                                                                            "[0-9]{11}|[0-9A-Z]{12}[0-9]{2}",
                                                                          enum: nil,
                                                                          max_length: nil,
                                                                          min_length: nil,
                                                                          fraction_digits: nil,
                                                                          total_digits: nil,
                                                                          min_inclusive: nil,
                                                                          max_inclusive: nil
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

  def decode(xml), do: Codec.parse(schema(), xml)
  def encode(term), do: Codec.build(schema(), term, namespace())
end
