defmodule Isox.Generated.Camt060.V1_9 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.060/1.9"
  def msg_def_idr, do: "camt.060.spi.1.9"

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
                  tag: "AcctRptgReq",
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
                            }
                          ],
                          attributes: [],
                          text: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %Isox.Schema.Element{
                        tag: "RptgReq",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "Id",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern:
                                  "[E|D][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}|[A-Z]{3}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{9}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil,
                                fraction_digits: nil,
                                total_digits: nil,
                                min_inclusive: nil,
                                max_inclusive: nil
                              },
                              min: 0,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "ReqdMsgNmId",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["camt.052", "camt.053", "camt.054"],
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
                              tag: "AcctOwnr",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Choice{
                                    options: [
                                      %Isox.Schema.Element{
                                        tag: "Agt",
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
                              tag: "RptgPrd",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "FrToDt",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "FrDt",
                                          type: %Isox.Schema.SimpleType{
                                            base: "date",
                                            pattern: nil,
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
                                          tag: "ToDt",
                                          type: %Isox.Schema.SimpleType{
                                            base: "date",
                                            pattern: nil,
                                            enum: nil,
                                            max_length: nil,
                                            min_length: nil,
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
                                    tag: "FrToTm",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "FrTm",
                                          type: %Isox.Schema.SimpleType{
                                            base: "time",
                                            pattern: "[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
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
                                          tag: "ToTm",
                                          type: %Isox.Schema.SimpleType{
                                            base: "time",
                                            pattern: "[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
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
                                    min: 0,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "Tp",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["ALLL"],
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
                              min: 0,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "ReqdBalTp",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "CdOrPrtry",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "Prtry",
                                              type: %Isox.Schema.SimpleType{
                                                base: "string",
                                                pattern: nil,
                                                enum: ["CRE", "CSA", "REL", "TRD", "TRT"],
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
        ]
      }
    }
  end

  def decode(xml), do: Codec.parse(schema(), xml)
  def encode(term), do: Codec.build(schema(), term, namespace())
end
