defmodule PixSpiCatalog.Generated.Camt054.V1_15 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.054/1.15"
  def msg_def_idr, do: "camt.054.spi.1.15"

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
                  tag: "BkToCstmrDbtCdtNtfctn",
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
                            }
                          ],
                          attributes: [],
                          text: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %PixSpiCatalog.Schema.Element{
                        tag: "Ntfctn",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "Id",
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
                              tag: "Acct",
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
                              tag: "Ntry",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Amt",
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
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "CdtDbtInd",
                                    type: %PixSpiCatalog.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["CRDT", "DBIT"],
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Sts",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Choice{
                                          options: [
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "Cd",
                                              type: %PixSpiCatalog.Schema.SimpleType{
                                                base: "string",
                                                pattern: nil,
                                                enum: ["BOOK", "INFO"],
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
                                    tag: "BookgDt",
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
                                    min: 0,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "ValDt",
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
                                    tag: "BkTxCd",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Domn",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Cd",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CAMT", "PMNT"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Fmly",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "Cd",
                                                      type: %PixSpiCatalog.Schema.SimpleType{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: ["IRCT", "MCOP", "MDOP", "RRCT"],
                                                        max_length: nil,
                                                        min_length: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "SubFmlyCd",
                                                      type: %PixSpiCatalog.Schema.SimpleType{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: ["DMCT", "NTAV", "RRTN"],
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
                                      attributes: [],
                                      text: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "AddtlInfInd",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "MsgNmId",
                                          type: %PixSpiCatalog.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: nil,
                                            max_length: 35,
                                            min_length: 1
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
                                    tag: "NtryDtls",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "TxDtls",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "Refs",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "InstrId",
                                                      type: %PixSpiCatalog.Schema.SimpleType{
                                                        base: "string",
                                                        pattern:
                                                          "[D][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
                                                        enum: nil,
                                                        max_length: 32,
                                                        min_length: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "EndToEndId",
                                                      type: %PixSpiCatalog.Schema.SimpleType{
                                                        base: "string",
                                                        pattern:
                                                          "[E|L][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
                                                        enum: nil,
                                                        max_length: 32,
                                                        min_length: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "TxId",
                                                      type: %PixSpiCatalog.Schema.SimpleType{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: nil,
                                                        max_length: 35,
                                                        min_length: 1
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "ClrSysRef",
                                                      type: %PixSpiCatalog.Schema.SimpleType{
                                                        base: "string",
                                                        pattern:
                                                          "[A-Z]{3}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{9}",
                                                        enum: nil,
                                                        max_length: 20,
                                                        min_length: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "Prtry",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Tp",
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: ["ServiceLevel"],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Ref",
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: [
                                                                  "PAGAGD",
                                                                  "PAGFRD",
                                                                  "PAGPRI"
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
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "RltdPties",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "InitgPty",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Choice{
                                                            options: [
                                                              %PixSpiCatalog.Schema.Element{
                                                                tag: "Pty",
                                                                type:
                                                                  %PixSpiCatalog.Schema.ComplexType{
                                                                    content: [
                                                                      %PixSpiCatalog.Schema.Element{
                                                                        tag: "Id",
                                                                        type:
                                                                          %PixSpiCatalog.Schema.ComplexType{
                                                                            content: [
                                                                              %PixSpiCatalog.Schema.Choice{
                                                                                options: [
                                                                                  %PixSpiCatalog.Schema.Element{
                                                                                    tag: "OrgId",
                                                                                    type:
                                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                                        content: [
                                                                                          %PixSpiCatalog.Schema.Element{
                                                                                            tag:
                                                                                              "Othr",
                                                                                            type:
                                                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                                                content:
                                                                                                  [
                                                                                                    %PixSpiCatalog.Schema.Element{
                                                                                                      tag:
                                                                                                        "Id",
                                                                                                      type:
                                                                                                        %PixSpiCatalog.Schema.SimpleType{
                                                                                                          base:
                                                                                                            "string",
                                                                                                          pattern:
                                                                                                            "[0-9A-Z]{12}[0-9]{2}",
                                                                                                          enum:
                                                                                                            nil,
                                                                                                          max_length:
                                                                                                            nil,
                                                                                                          min_length:
                                                                                                            nil
                                                                                                        },
                                                                                                      min:
                                                                                                        1,
                                                                                                      max:
                                                                                                        1
                                                                                                    }
                                                                                                  ],
                                                                                                attributes:
                                                                                                  [],
                                                                                                text:
                                                                                                  nil
                                                                                              },
                                                                                            min:
                                                                                              1,
                                                                                            max: 1
                                                                                          }
                                                                                        ],
                                                                                        attributes:
                                                                                          [],
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
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "Dbtr",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Choice{
                                                            options: [
                                                              %PixSpiCatalog.Schema.Element{
                                                                tag: "Pty",
                                                                type:
                                                                  %PixSpiCatalog.Schema.ComplexType{
                                                                    content: [
                                                                      %PixSpiCatalog.Schema.Element{
                                                                        tag: "Nm",
                                                                        type:
                                                                          %PixSpiCatalog.Schema.SimpleType{
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
                                                                        type:
                                                                          %PixSpiCatalog.Schema.ComplexType{
                                                                            content: [
                                                                              %PixSpiCatalog.Schema.Choice{
                                                                                options: [
                                                                                  %PixSpiCatalog.Schema.Element{
                                                                                    tag: "PrvtId",
                                                                                    type:
                                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                                        content: [
                                                                                          %PixSpiCatalog.Schema.Element{
                                                                                            tag:
                                                                                              "Othr",
                                                                                            type:
                                                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                                                content:
                                                                                                  [
                                                                                                    %PixSpiCatalog.Schema.Element{
                                                                                                      tag:
                                                                                                        "Id",
                                                                                                      type:
                                                                                                        %PixSpiCatalog.Schema.SimpleType{
                                                                                                          base:
                                                                                                            "string",
                                                                                                          pattern:
                                                                                                            "[0-9]{11}|[0-9A-Z]{12}[0-9]{2}",
                                                                                                          enum:
                                                                                                            nil,
                                                                                                          max_length:
                                                                                                            nil,
                                                                                                          min_length:
                                                                                                            nil
                                                                                                        },
                                                                                                      min:
                                                                                                        1,
                                                                                                      max:
                                                                                                        1
                                                                                                    }
                                                                                                  ],
                                                                                                attributes:
                                                                                                  [],
                                                                                                text:
                                                                                                  nil
                                                                                              },
                                                                                            min:
                                                                                              1,
                                                                                            max: 1
                                                                                          }
                                                                                        ],
                                                                                        attributes:
                                                                                          [],
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
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "DbtrAcct",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Id",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
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
                                                                                  "[0-9A-Z]{1,20}",
                                                                                enum: nil,
                                                                                max_length: nil,
                                                                                min_length: nil
                                                                              },
                                                                            min: 1,
                                                                            max: 1
                                                                          },
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "Issr",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                                base: "integer",
                                                                                pattern:
                                                                                  "[0-9]{1,4}",
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
                                                                attributes: [],
                                                                text: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Tp",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Choice{
                                                                    options: [
                                                                      %PixSpiCatalog.Schema.Element{
                                                                        tag: "Cd",
                                                                        type:
                                                                          %PixSpiCatalog.Schema.SimpleType{
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
                                                      tag: "Cdtr",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Choice{
                                                            options: [
                                                              %PixSpiCatalog.Schema.Element{
                                                                tag: "Pty",
                                                                type:
                                                                  %PixSpiCatalog.Schema.ComplexType{
                                                                    content: [
                                                                      %PixSpiCatalog.Schema.Element{
                                                                        tag: "Id",
                                                                        type:
                                                                          %PixSpiCatalog.Schema.ComplexType{
                                                                            content: [
                                                                              %PixSpiCatalog.Schema.Choice{
                                                                                options: [
                                                                                  %PixSpiCatalog.Schema.Element{
                                                                                    tag: "PrvtId",
                                                                                    type:
                                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                                        content: [
                                                                                          %PixSpiCatalog.Schema.Element{
                                                                                            tag:
                                                                                              "Othr",
                                                                                            type:
                                                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                                                content:
                                                                                                  [
                                                                                                    %PixSpiCatalog.Schema.Element{
                                                                                                      tag:
                                                                                                        "Id",
                                                                                                      type:
                                                                                                        %PixSpiCatalog.Schema.SimpleType{
                                                                                                          base:
                                                                                                            "string",
                                                                                                          pattern:
                                                                                                            "[0-9]{11}|[0-9A-Z]{12}[0-9]{2}",
                                                                                                          enum:
                                                                                                            nil,
                                                                                                          max_length:
                                                                                                            nil,
                                                                                                          min_length:
                                                                                                            nil
                                                                                                        },
                                                                                                      min:
                                                                                                        1,
                                                                                                      max:
                                                                                                        1
                                                                                                    }
                                                                                                  ],
                                                                                                attributes:
                                                                                                  [],
                                                                                                text:
                                                                                                  nil
                                                                                              },
                                                                                            min:
                                                                                              1,
                                                                                            max: 1
                                                                                          }
                                                                                        ],
                                                                                        attributes:
                                                                                          [],
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
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "CdtrAcct",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Id",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
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
                                                                                  "[0-9A-Z]{1,20}",
                                                                                enum: nil,
                                                                                max_length: nil,
                                                                                min_length: nil
                                                                              },
                                                                            min: 1,
                                                                            max: 1
                                                                          },
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "Issr",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                                base: "integer",
                                                                                pattern:
                                                                                  "[0-9]{1,4}",
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
                                                                attributes: [],
                                                                text: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Tp",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Choice{
                                                                    options: [
                                                                      %PixSpiCatalog.Schema.Element{
                                                                        tag: "Cd",
                                                                        type:
                                                                          %PixSpiCatalog.Schema.SimpleType{
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
                                                            tag: "Prxy",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Element{
                                                                    tag: "Id",
                                                                    type:
                                                                      %PixSpiCatalog.Schema.SimpleType{
                                                                        base: "string",
                                                                        pattern: nil,
                                                                        enum: nil,
                                                                        max_length: 77,
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
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "RltdAgts",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "DbtrAgt",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "FinInstnId",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Element{
                                                                    tag: "ClrSysMmbId",
                                                                    type:
                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                        content: [
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "MmbId",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                                base: "string",
                                                                                pattern:
                                                                                  "[0-9A-Z]{8}",
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
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "CdtrAgt",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "FinInstnId",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Element{
                                                                    tag: "ClrSysMmbId",
                                                                    type:
                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                        content: [
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "MmbId",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                                base: "string",
                                                                                pattern:
                                                                                  "[0-9A-Z]{8}",
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
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "Prtry",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Tp",
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: [
                                                                  "ContraparteSelic",
                                                                  "ContraparteSTR"
                                                                ],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Agt",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Element{
                                                                    tag: "FinInstnId",
                                                                    type:
                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                        content: [
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "ClrSysMmbId",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                                content: [
                                                                                  %PixSpiCatalog.Schema.Element{
                                                                                    tag: "MmbId",
                                                                                    type:
                                                                                      %PixSpiCatalog.Schema.SimpleType{
                                                                                        base:
                                                                                          "string",
                                                                                        pattern:
                                                                                          "[0-9A-Z]{8}",
                                                                                        enum: nil,
                                                                                        max_length:
                                                                                          8,
                                                                                        min_length:
                                                                                          nil
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
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "LclInstrm",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Choice{
                                                      options: [
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "Prtry",
                                                          type: %PixSpiCatalog.Schema.SimpleType{
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
                                                tag: "Purp",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Choice{
                                                      options: [
                                                        %PixSpiCatalog.Schema.Element{
                                                          tag: "Cd",
                                                          type: %PixSpiCatalog.Schema.SimpleType{
                                                            base: "string",
                                                            pattern: nil,
                                                            enum: [
                                                              "GSCB",
                                                              "IPAY",
                                                              "IPRT",
                                                              "OTHR",
                                                              "REFU"
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
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "Strd",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "RfrdDocInf",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Element{
                                                                    tag: "Tp",
                                                                    type:
                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                        content: [
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "CdOrPrtry",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                                content: [
                                                                                  %PixSpiCatalog.Schema.Choice{
                                                                                    options: [
                                                                                      %PixSpiCatalog.Schema.Element{
                                                                                        tag:
                                                                                          "Prtry",
                                                                                        type:
                                                                                          %PixSpiCatalog.Schema.SimpleType{
                                                                                            base:
                                                                                              "string",
                                                                                            pattern:
                                                                                              nil,
                                                                                            enum:
                                                                                              [
                                                                                                "AGFSS",
                                                                                                "AGTEC",
                                                                                                "AGTOT"
                                                                                              ],
                                                                                            max_length:
                                                                                              nil,
                                                                                            min_length:
                                                                                              nil
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
                                                                            tag: "Issr",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                                base: "string",
                                                                                pattern:
                                                                                  "[0-9A-Z]{8}",
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
                                                          },
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "RfrdDocAmt",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Element{
                                                                    tag: "AdjstmntAmtAndRsn",
                                                                    type:
                                                                      %PixSpiCatalog.Schema.ComplexType{
                                                                        content: [
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "Amt",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                                content: [],
                                                                                attributes: [
                                                                                  %PixSpiCatalog.Schema.Attribute{
                                                                                    tag: "Ccy",
                                                                                    type:
                                                                                      %PixSpiCatalog.Schema.SimpleType{
                                                                                        base:
                                                                                          "string",
                                                                                        pattern:
                                                                                          nil,
                                                                                        enum: [
                                                                                          "BRL"
                                                                                        ],
                                                                                        max_length:
                                                                                          nil,
                                                                                        min_length:
                                                                                          nil
                                                                                      },
                                                                                    required: true
                                                                                  }
                                                                                ],
                                                                                text:
                                                                                  %PixSpiCatalog.Schema.SimpleType{
                                                                                    base:
                                                                                      "decimal",
                                                                                    pattern: nil,
                                                                                    enum: nil,
                                                                                    max_length:
                                                                                      nil,
                                                                                    min_length:
                                                                                      nil
                                                                                  }
                                                                              },
                                                                            min: 1,
                                                                            max: 1
                                                                          },
                                                                          %PixSpiCatalog.Schema.Element{
                                                                            tag: "Rsn",
                                                                            type:
                                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                                base: "string",
                                                                                pattern: nil,
                                                                                enum: [
                                                                                  "VLCP",
                                                                                  "VLDN"
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
                                                                    max: 2
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
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "RltdDts",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "AccptncDtTm",
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
                                                  attributes: [],
                                                  text: nil
                                                },
                                                min: 0,
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
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
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
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: ["INF"],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "TaxAmt",
                                                            type:
                                                              %PixSpiCatalog.Schema.ComplexType{
                                                                content: [
                                                                  %PixSpiCatalog.Schema.Element{
                                                                    tag: "TtlAmt",
                                                                    type:
                                                                      %PixSpiCatalog.Schema.ComplexType{
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
                                                                        text:
                                                                          %PixSpiCatalog.Schema.SimpleType{
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
                                                      max: 2
                                                    }
                                                  ],
                                                  attributes: [],
                                                  text: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "RtrInf",
                                                type: %PixSpiCatalog.Schema.ComplexType{
                                                  content: [
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "Rsn",
                                                      type: %PixSpiCatalog.Schema.ComplexType{
                                                        content: [
                                                          %PixSpiCatalog.Schema.Element{
                                                            tag: "Cd",
                                                            type:
                                                              %PixSpiCatalog.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: [
                                                                  "BE08",
                                                                  "FR01",
                                                                  "MD06",
                                                                  "SL02"
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
                                                    },
                                                    %PixSpiCatalog.Schema.Element{
                                                      tag: "AddtlInf",
                                                      type: %PixSpiCatalog.Schema.SimpleType{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: nil,
                                                        max_length: 105,
                                                        min_length: 1
                                                      },
                                                      min: 0,
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
                                                tag: "AddtlTxInf",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["HIGH", "NORM"],
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
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "AddtlNtryInf",
                                    type: %PixSpiCatalog.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: 4,
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
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "AddtlNtfctnInf",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 105,
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
