defmodule Isox.Generated.Pain012.V1_4 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.012/1.4"
  def msg_def_idr, do: "pain.012.spi.1.4"

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
                  tag: "MndtAccptncRpt",
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
                            },
                            %Isox.Schema.Element{
                              tag: "InstgAgt",
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
                            }
                          ],
                          attributes: [],
                          text: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %Isox.Schema.Element{
                        tag: "UndrlygAccptncDtls",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "AccptncRslt",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Accptd",
                                    type: %Isox.Schema.SimpleType{
                                      base: "boolean",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "RjctRsn",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Prtry",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: [
                                              "AC01",
                                              "AC04",
                                              "AC06",
                                              "AM05",
                                              "AP01",
                                              "AP02",
                                              "AP03",
                                              "AP04",
                                              "AP05",
                                              "AP06",
                                              "AP07",
                                              "AP08",
                                              "AP09",
                                              "AP10",
                                              "AP11",
                                              "AP12",
                                              "AP13",
                                              "AP14",
                                              "AP15",
                                              "CH16",
                                              "MD01",
                                              "MD20",
                                              "SA01"
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
                              tag: "OrgnlMndt",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Choice{
                                    options: [
                                      %Isox.Schema.Element{
                                        tag: "OrgnlMndt",
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
                                                min_length: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %Isox.Schema.Element{
                                              tag: "MndtReqId",
                                              type: %Isox.Schema.SimpleType{
                                                base: "string",
                                                pattern:
                                                  "[I][S][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{11}",
                                                enum: nil,
                                                max_length: nil,
                                                min_length: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %Isox.Schema.Element{
                                              tag: "Ocrncs",
                                              type: %Isox.Schema.ComplexType{
                                                content: [
                                                  %Isox.Schema.Element{
                                                    tag: "SeqTp",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: ["RCUR"],
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "Frqcy",
                                                    type: %Isox.Schema.ComplexType{
                                                      content: [
                                                        %Isox.Schema.Choice{
                                                          options: [
                                                            %Isox.Schema.Element{
                                                              tag: "Tp",
                                                              type: %Isox.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: [
                                                                  "MIAN",
                                                                  "MNTH",
                                                                  "QURT",
                                                                  "WEEK",
                                                                  "YEAR"
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
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "FrstColltnDt",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "date",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "FnlColltnDt",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "date",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: nil,
                                                      min_length: nil
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
                                              tag: "TrckgInd",
                                              type: %Isox.Schema.SimpleType{
                                                base: "boolean",
                                                pattern: nil,
                                                enum: nil,
                                                max_length: nil,
                                                min_length: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %Isox.Schema.Element{
                                              tag: "ColltnAmt",
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
                                                      min_length: nil
                                                    },
                                                    required: true
                                                  }
                                                ],
                                                text: %Isox.Schema.SimpleType{
                                                  base: "decimal",
                                                  pattern: nil,
                                                  enum: nil,
                                                  max_length: nil,
                                                  min_length: nil
                                                }
                                              },
                                              min: 0,
                                              max: 1
                                            },
                                            %Isox.Schema.Element{
                                              tag: "Cdtr",
                                              type: %Isox.Schema.ComplexType{
                                                content: [
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
                                            %Isox.Schema.Element{
                                              tag: "Dbtr",
                                              type: %Isox.Schema.ComplexType{
                                                content: [
                                                  %Isox.Schema.Element{
                                                    tag: "PstlAdr",
                                                    type: %Isox.Schema.ComplexType{
                                                      content: [
                                                        %Isox.Schema.Element{
                                                          tag: "TwnNm",
                                                          type: %Isox.Schema.SimpleType{
                                                            base: "string",
                                                            pattern: "[0-9]{7}",
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
                                                                      base: "integer",
                                                                      pattern: "[0-9]{1,20}",
                                                                      enum: nil,
                                                                      max_length: nil,
                                                                      min_length: nil
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
                                                                      min_length: nil
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
                                                      min_length: 1
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
                                              min: 0,
                                              max: 1
                                            },
                                            %Isox.Schema.Element{
                                              tag: "MndtRef",
                                              type: %Isox.Schema.SimpleType{
                                                base: "string",
                                                pattern:
                                                  "(SC|IC|IS)[0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{11}",
                                                enum: nil,
                                                max_length: nil,
                                                min_length: nil
                                              },
                                              min: 0,
                                              max: 1
                                            },
                                            %Isox.Schema.Element{
                                              tag: "RfrdDoc",
                                              type: %Isox.Schema.ComplexType{
                                                content: [
                                                  %Isox.Schema.Element{
                                                    tag: "Nb",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: 35,
                                                      min_length: 1
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %Isox.Schema.Element{
                                                    tag: "CdtrRef",
                                                    type: %Isox.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: 35,
                                                      min_length: 1
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
                              tag: "SplmtryData",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Envlp",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "MndtPrcgDtls",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "MndtPrcgTp",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: [
                                                    "AUT1",
                                                    "AUT2",
                                                    "AUT3",
                                                    "AUT4",
                                                    "CRTN",
                                                    "UPDT"
                                                  ],
                                                  max_length: nil,
                                                  min_length: nil
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
                                          max: 3
                                        },
                                        %Isox.Schema.Element{
                                          tag: "MndtSts",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["CCLD", "CFDB", "PDNG"],
                                            max_length: nil,
                                            min_length: nil
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
