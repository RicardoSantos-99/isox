defmodule Isox.Generated.Trck002.V1_1 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/trck.002/1.1"
  def msg_def_idr, do: "trck.002.spi.1.1"

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
                  tag: "PmtStsTrckrRpt",
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
                        tag: "TrckrStsAndTx",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "TxSts",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Sts",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["ACCC"],
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
                              tag: "Tx",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "PmtId",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "InstrId",
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
                                          min: 0,
                                          max: 1
                                        },
                                        %Isox.Schema.Element{
                                          tag: "EndToEndId",
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
                                        }
                                      ],
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "PmtTpInf",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "LclInstrm",
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
                                                        "APDN",
                                                        "APES",
                                                        "AUTO",
                                                        "DICT",
                                                        "INIC",
                                                        "MANU",
                                                        "QRDN",
                                                        "QRES"
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
                                    tag: "PmtScnro",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Prtry",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["BOK1", "BOK2"],
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
                                    tag: "IntrBkSttlmAmt",
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
                                    tag: "ReqdExctnDt",
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
                                    tag: "Dbtr",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "Pty",
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
                                                                    type:
                                                                      %Isox.Schema.ComplexType{
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
                                                                                fraction_digits:
                                                                                  nil,
                                                                                total_digits: nil,
                                                                                min_inclusive:
                                                                                  nil,
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
                                    tag: "DbtrAcct",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Id",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Choice{
                                                options: [
                                                  %Isox.Schema.Element{
                                                    tag: "Othr",
                                                    type: %Isox.Schema.ComplexType{
                                                      content: [
                                                        %Isox.Schema.Element{
                                                          tag: "Id",
                                                          type: %Isox.Schema.SimpleType{
                                                            base: "string",
                                                            pattern: "[0-9A-Z]{1,20}",
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
                                                          tag: "Issr",
                                                          type: %Isox.Schema.SimpleType{
                                                            base: "integer",
                                                            pattern: "[0-9]{1,4}",
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
                                          tag: "Tp",
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
                                                        "CACC",
                                                        "OTHR",
                                                        "SLRY",
                                                        "SVGS",
                                                        "TRAN"
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
                                  },
                                  %Isox.Schema.Element{
                                    tag: "Cdtr",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "Pty",
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
                                                                    type:
                                                                      %Isox.Schema.ComplexType{
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
                                                                                fraction_digits:
                                                                                  nil,
                                                                                total_digits: nil,
                                                                                min_inclusive:
                                                                                  nil,
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
                                    tag: "CdtrAcct",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Id",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Choice{
                                                options: [
                                                  %Isox.Schema.Element{
                                                    tag: "Othr",
                                                    type: %Isox.Schema.ComplexType{
                                                      content: [
                                                        %Isox.Schema.Element{
                                                          tag: "Id",
                                                          type: %Isox.Schema.SimpleType{
                                                            base: "string",
                                                            pattern: "[0-9A-Z]{1,20}",
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
                                                          tag: "Issr",
                                                          type: %Isox.Schema.SimpleType{
                                                            base: "integer",
                                                            pattern: "[0-9]{1,4}",
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
                                          tag: "Tp",
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
                                                        "CACC",
                                                        "OTHR",
                                                        "SLRY",
                                                        "SVGS",
                                                        "TRAN"
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
                                        },
                                        %Isox.Schema.Element{
                                          tag: "Prxy",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Id",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: nil,
                                                  max_length: 77,
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
