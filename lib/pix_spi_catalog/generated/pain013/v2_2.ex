defmodule PixSpiCatalog.Generated.Pain013.V2_2 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.013/2.2"
  def msg_def_idr, do: "pain.013.spi.2.2"

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
                  tag: "CdtrPmtActvtnReq",
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
                              tag: "NbOfTxs",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "integer",
                                pattern: "[0-9]{1,15}",
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
                        tag: "PmtInf",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "PmtInfId",
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
                              tag: "PmtMtd",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: ["TRF"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "ReqdExctnDt",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Choice{
                                    options: [
                                      %PixSpiCatalog.Schema.Element{
                                        tag: "DtTm",
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
                            %PixSpiCatalog.Schema.Element{
                              tag: "XpryDt",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Choice{
                                    options: [
                                      %PixSpiCatalog.Schema.Element{
                                        tag: "Dt",
                                        type: %PixSpiCatalog.Schema.SimpleType{
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
                              tag: "Dbtr",
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
                                                    type: %PixSpiCatalog.Schema.ComplexType{
                                                      content: [
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "Id",
                                                          type: %PixSpiCatalog.Schema.SimpleType{
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
                            %PixSpiCatalog.Schema.Element{
                              tag: "DbtrAgt",
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
                                                type: %PixSpiCatalog.Schema.SimpleType{
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
                              tag: "UltmtDbtr",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Nm",
                                    type: %PixSpiCatalog.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: 140,
                                      min_length: 1
                                    },
                                    min: 1,
                                    max: 1
                                  },
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
                                                    type: %PixSpiCatalog.Schema.ComplexType{
                                                      content: [
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "Id",
                                                          type: %PixSpiCatalog.Schema.SimpleType{
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
                            %PixSpiCatalog.Schema.Element{
                              tag: "CdtTrfTx",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "PmtId",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "EndToEndId",
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
                                        }
                                      ],
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "PmtTpInf",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "InstrPrty",
                                          type: %PixSpiCatalog.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["NORM"],
                                            max_length: nil,
                                            min_length: nil
                                          },
                                          min: 1,
                                          max: 1
                                        },
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "SvcLvl",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Prtry",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["PAGAGD"],
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
                                          tag: "LclInstrm",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Prtry",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["AUTO"],
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
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Amt",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Choice{
                                          options: [
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "InstdAmt",
                                              type: %PixSpiCatalog.Schema.ComplexType{
                                                content: [],
                                                attributes: [
                                                  %PixSpiCatalog.Schema.Attribute{
                                                    tag: "Ccy",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: ["BRL"],
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    required: true
                                                  }
                                                ],
                                                text: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "decimal",
                                                  pattern: nil,
                                                  enum: nil,
                                                  max_length: nil,
                                                  min_length: nil
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
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "ChrgBr",
                                    type: %PixSpiCatalog.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["SLEV"],
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "MndtRltdInf",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "MndtId",
                                          type: %PixSpiCatalog.Schema.SimpleType{
                                            base: "string",
                                            pattern:
                                              "[R|C][R|N][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{11}",
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
                                                      type: %PixSpiCatalog.Schema.SimpleType{
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
                                                          type: %PixSpiCatalog.Schema.ComplexType{
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
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "CdtrAcct",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Id",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Choice{
                                                options: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Othr",
                                                    type: %PixSpiCatalog.Schema.ComplexType{
                                                      content: [
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "Id",
                                                          type: %PixSpiCatalog.Schema.SimpleType{
                                                            base: "integer",
                                                            pattern: "[0-9]{1,20}",
                                                            enum: nil,
                                                            max_length: nil,
                                                            min_length: nil
                                                          },
                                                          min: 1,
                                                          max: 1
                                                        },
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "Issr",
                                                          type: %PixSpiCatalog.Schema.SimpleType{
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
                                        },
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Tp",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Choice{
                                                options: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Cd",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: ["CACC", "SVGS", "TRAN"],
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
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Purp",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Prtry",
                                          type: %PixSpiCatalog.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["AGND", "NTAG", "RIFL"],
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
                                    tag: "Tax",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "RefNb",
                                          type: %PixSpiCatalog.Schema.SimpleType{
                                            base: "string",
                                            pattern: "[a-zA-Z0-9]{1,50}",
                                            enum: nil,
                                            max_length: nil,
                                            min_length: nil
                                          },
                                          min: 0,
                                          max: 1
                                        },
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Rcrd",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Tp",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CBSSPLIT", "IBSSPLIT"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Ctgy",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["COR", "INF"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "TaxAmt",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "TtlAmt",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [],
                                                        attributes: [
                                                          %PixSpiCatalog.Schema.Attribute{
                                                            tag: "Ccy",
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: ["BRL"],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                            required: true
                                                          }
                                                        ],
                                                        text: %PixSpiCatalog.Schema.SimpleType{
                                                          base: "decimal",
                                                          pattern: nil,
                                                          enum: nil,
                                                          max_length: nil,
                                                          min_length: nil
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
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "RmtInf",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Ustrd",
                                          type: %PixSpiCatalog.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: nil,
                                            max_length: 140,
                                            min_length: 1
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

  def parse(xml), do: Codec.parse(schema(), xml)
  def build(term), do: Codec.build(schema(), term, namespace())
end
