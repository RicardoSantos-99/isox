defmodule Isox.Generated.Pacs004.V1_5 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pacs.004/1.5"
  def msg_def_idr, do: "pacs.004.spi.1.5"

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
                  tag: "PmtRtr",
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
                              tag: "NbOfTxs",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: "[0-9]{1,15}",
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
                              tag: "SttlmInf",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "SttlmMtd",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["CLRG"],
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
                      },
                      %Isox.Schema.Element{
                        tag: "TxInf",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "RtrId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern:
                                  "[D][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
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
                              tag: "RtrdIntrBkSttlmAmt",
                              type: %Isox.Schema.ComplexType{
                                content: [],
                                attributes: [
                                  %Isox.Schema.Attribute{
                                    tag: "Ccy",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["BRL"],
                                      max_length: nil,
                                      min_length: nil,
                                      fraction_digits: nil,
                                      total_digits: nil,
                                      min_inclusive: nil,
                                      max_inclusive: nil
                                    },
                                    required: true
                                  }
                                ],
                                text: %Isox.Schema.SimpleType{
                                  base: "decimal",
                                  pattern: nil,
                                  enum: nil,
                                  max_length: nil,
                                  min_length: nil,
                                  fraction_digits: 2,
                                  total_digits: 18,
                                  min_inclusive: "0",
                                  max_inclusive: nil
                                }
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "SttlmPrty",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["HIGH", "NORM"],
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
                              tag: "ChrgBr",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["SLEV"],
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
                              tag: "RtrRsnInf",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Rsn",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "Cd",
                                              type: %Isox.Schema.SimpleType{
                                                base: "string",
                                                pattern: nil,
                                                enum: ["BE08", "FR01", "MD06", "SL02"],
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
                                    tag: "AddtlInf",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: 105,
                                      min_length: 1,
                                      fraction_digits: nil,
                                      total_digits: nil,
                                      min_inclusive: nil,
                                      max_inclusive: nil
                                    },
                                    min: 0,
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
                              tag: "OrgnlTxRef",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "RmtInf",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Ustrd",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: nil,
                                            max_length: 140,
                                            min_length: 1,
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
                                    min: 0,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "DbtrAgt",
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
