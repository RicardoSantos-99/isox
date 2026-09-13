defmodule Isox.Generated.Pacs002.V1_17 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pacs.002/1.17"
  def msg_def_idr, do: "pacs.002.spi.1.17"

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
                  tag: "FIToFIPmtStsRpt",
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
                        tag: "TxInfAndSts",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "OrgnlInstrId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern:
                                  "[E|D][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil
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
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "TxSts",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["ACCC", "ACSC", "ACSP", "RJCT"],
                                max_length: nil,
                                min_length: nil
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
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "Cd",
                                              type: %Isox.Schema.SimpleType{
                                                base: "string",
                                                pattern: nil,
                                                enum: [
                                                  "AB03",
                                                  "AB09",
                                                  "AB11",
                                                  "AC03",
                                                  "AC06",
                                                  "AC07",
                                                  "AC14",
                                                  "AG03",
                                                  "AG12",
                                                  "AG13",
                                                  "AGNT",
                                                  "AM01",
                                                  "AM02",
                                                  "AM04",
                                                  "AM09",
                                                  "AM12",
                                                  "AM18",
                                                  "AM23",
                                                  "BE01",
                                                  "BE05",
                                                  "BE15",
                                                  "BE17",
                                                  "CH11",
                                                  "CH16",
                                                  "CN01",
                                                  "DS02",
                                                  "DS04",
                                                  "DS0G",
                                                  "DS27",
                                                  "DT02",
                                                  "DT05",
                                                  "DU03",
                                                  "DUPL",
                                                  "ED05",
                                                  "FF07",
                                                  "FF08",
                                                  "FRAD",
                                                  "INDT",
                                                  "MD01",
                                                  "RC09",
                                                  "RC10",
                                                  "RR04",
                                                  "RR06",
                                                  "SL02",
                                                  "UPAY"
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
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 0,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "AddtlInf",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: 105,
                                      min_length: 1
                                    },
                                    min: 0,
                                    max: :unbounded
                                  }
                                ],
                                attributes: [],
                                text: nil
                              },
                              min: 0,
                              max: :unbounded
                            },
                            %Isox.Schema.Element{
                              tag: "FctvIntrBkSttlmDt",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Choice{
                                    options: [
                                      %Isox.Schema.Element{
                                        tag: "DtTm",
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
                              tag: "OrgnlTxRef",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "IntrBkSttlmDt",
                                    type: %Isox.Schema.SimpleType{
                                      base: "date",
                                      pattern: nil,
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
                              min: 0,
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
