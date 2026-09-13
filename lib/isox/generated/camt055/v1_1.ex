defmodule Isox.Generated.Camt055.V1_1 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.055/1.1"
  def msg_def_idr, do: "camt.055.spi.1.1"

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
                  tag: "CstmrPmtCxlReq",
                  type: %Isox.Schema.ComplexType{
                    content: [
                      %Isox.Schema.Element{
                        tag: "Assgnmt",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "Id",
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
                              tag: "Assgnr",
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
                              tag: "Assgne",
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
                        tag: "Undrlyg",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "OrgnlPmtInfAndCxl",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "PmtCxlId",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern:
                                        "[C][A][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{11}",
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
                                    tag: "CxlRsnInf",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Orgtr",
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
                                        },
                                        %Isox.Schema.Element{
                                          tag: "Rsn",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Choice{
                                                options: [
                                                  %Isox.Schema.Element{
                                                    tag: "Prtry",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: [
                                                        "ACCT",
                                                        "BLCK",
                                                        "CCLD",
                                                        "FAIL",
                                                        "OTHR",
                                                        "SLBD",
                                                        "SLCR"
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
                                          tag: "SplmtryData",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Envlp",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "CxlPrcgDtls",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "CxlPrcgTp",
                                                            type: %Isox.Schema.SimpleType{
                                                              base: "string",
                                                              pattern: nil,
                                                              enum: ["DHIP", "DHSR"],
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
                                                            tag: "PrcgDtTm",
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
