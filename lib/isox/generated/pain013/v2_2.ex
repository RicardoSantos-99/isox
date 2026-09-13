defmodule Isox.Generated.Pain013.V2_2 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.013/2.2"
  def msg_def_idr, do: "pain.013.spi.2.2"

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
                  tag: "CdtrPmtActvtnReq",
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
                                base: "integer",
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
                        tag: "PmtInf",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "PmtInfId",
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
                              tag: "PmtMtd",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["TRF"],
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
                              min: 0,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "XpryDt",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Choice{
                                    options: [
                                      %Isox.Schema.Element{
                                        tag: "Dt",
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
                                                          type: %Isox.Schema.SimpleType{
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
                              tag: "UltmtDbtr",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Nm",
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
                                  },
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
                                                          type: %Isox.Schema.SimpleType{
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
                              min: 0,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "CdtTrfTx",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "PmtId",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
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
                                          tag: "InstrPrty",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["NORM"],
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
                                          tag: "SvcLvl",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Prtry",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["PAGAGD"],
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
                                          tag: "LclInstrm",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Prtry",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["AUTO"],
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
                                    tag: "Amt",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "InstdAmt",
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
                                    tag: "MndtRltdInf",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "MndtId",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern:
                                              "[R|C][R|N][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{11}",
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
                                                                type: %Isox.Schema.SimpleType{
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
                                                            base: "integer",
                                                            pattern: "[0-9]{1,20}",
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
                                                      enum: ["CACC", "SVGS", "TRAN"],
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
                                    tag: "Purp",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Prtry",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["AGND", "NTAG", "RIFL"],
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
                                    tag: "Tax",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "RefNb",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: "[a-zA-Z0-9]{1,50}",
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
                                        },
                                        %Isox.Schema.Element{
                                          tag: "Rcrd",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Tp",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CBSSPLIT", "IBSSPLIT"],
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
                                                tag: "Ctgy",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["COR", "INF"],
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
                                                tag: "TaxAmt",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "TtlAmt",
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
                                          min: 2,
                                          max: 4
                                        }
                                      ],
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 0,
                                    max: 1
                                  },
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
