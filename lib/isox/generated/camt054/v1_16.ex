defmodule Isox.Generated.Camt054.V1_16 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.054/1.16"
  def msg_def_idr, do: "camt.054.spi.1.16"

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
                  tag: "BkToCstmrDbtCdtNtfctn",
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
                        tag: "Ntfctn",
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
                              tag: "Acct",
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
                              tag: "Ntry",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Element{
                                    tag: "Amt",
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
                                    tag: "CdtDbtInd",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["CRDT", "DBIT"],
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
                                    tag: "Sts",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Choice{
                                          options: [
                                            %Isox.Schema.Element{
                                              tag: "Cd",
                                              type: %Isox.Schema.SimpleType{
                                                base: "string",
                                                pattern: nil,
                                                enum: ["BOOK", "INFO"],
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
                                    tag: "BookgDt",
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
                                    min: 0,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "ValDt",
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
                                    tag: "BkTxCd",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "Domn",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Cd",
                                                type: %Isox.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CAMT", "PMNT"],
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
                                                tag: "Fmly",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "Cd",
                                                      type: %Isox.Schema.SimpleType{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: ["IRCT", "MCOP", "MDOP", "RRCT"],
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
                                                      tag: "SubFmlyCd",
                                                      type: %Isox.Schema.SimpleType{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: ["DMCT", "NTAV", "RRTN"],
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
                                  },
                                  %Isox.Schema.Element{
                                    tag: "AddtlInfInd",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "MsgNmId",
                                          type: %Isox.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: nil,
                                            max_length: 35,
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
                                    min: 1,
                                    max: 1
                                  },
                                  %Isox.Schema.Element{
                                    tag: "NtryDtls",
                                    type: %Isox.Schema.ComplexType{
                                      content: [
                                        %Isox.Schema.Element{
                                          tag: "TxDtls",
                                          type: %Isox.Schema.ComplexType{
                                            content: [
                                              %Isox.Schema.Element{
                                                tag: "Refs",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "InstrId",
                                                      type: %Isox.Schema.SimpleType{
                                                        base: "string",
                                                        pattern:
                                                          "[E|D][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
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
                                                          "[E|L][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][a-zA-Z0-9]{11}",
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
                                                      tag: "TxId",
                                                      type: %Isox.Schema.SimpleType{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: nil,
                                                        max_length: 35,
                                                        min_length: 1,
                                                        fraction_digits: nil,
                                                        total_digits: nil,
                                                        min_inclusive: nil,
                                                        max_inclusive: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %Isox.Schema.Element{
                                                      tag: "ClrSysRef",
                                                      type: %Isox.Schema.SimpleType{
                                                        base: "string",
                                                        pattern:
                                                          "[A-Z]{3}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{9}",
                                                        enum: nil,
                                                        max_length: 20,
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
                                                      tag: "Prtry",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "Tp",
                                                            type: %Isox.Schema.SimpleType{
                                                              base: "string",
                                                              pattern: nil,
                                                              enum: ["ServiceLevel"],
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
                                                            tag: "Ref",
                                                            type: %Isox.Schema.SimpleType{
                                                              base: "string",
                                                              pattern: nil,
                                                              enum: ["PAGAGD", "PAGFRD", "PAGPRI"],
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
                                                    }
                                                  ],
                                                  attributes: [],
                                                  text: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %Isox.Schema.Element{
                                                tag: "RltdPties",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "InitgPty",
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
                                                                      type:
                                                                        %Isox.Schema.ComplexType{
                                                                          content: [
                                                                            %Isox.Schema.Choice{
                                                                              options: [
                                                                                %Isox.Schema.Element{
                                                                                  tag: "OrgId",
                                                                                  type:
                                                                                    %Isox.Schema.ComplexType{
                                                                                      content: [
                                                                                        %Isox.Schema.Element{
                                                                                          tag:
                                                                                            "Othr",
                                                                                          type:
                                                                                            %Isox.Schema.ComplexType{
                                                                                              content:
                                                                                                [
                                                                                                  %Isox.Schema.Element{
                                                                                                    tag:
                                                                                                      "Id",
                                                                                                    type:
                                                                                                      %Isox.Schema.SimpleType{
                                                                                                        base:
                                                                                                          "string",
                                                                                                        pattern:
                                                                                                          "[0-9A-Z]{12}[0-9]{2}",
                                                                                                        enum:
                                                                                                          nil,
                                                                                                        max_length:
                                                                                                          nil,
                                                                                                        min_length:
                                                                                                          nil,
                                                                                                        fraction_digits:
                                                                                                          nil,
                                                                                                        total_digits:
                                                                                                          nil,
                                                                                                        min_inclusive:
                                                                                                          nil,
                                                                                                        max_inclusive:
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
                                                                                          min: 1,
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
                                                                      tag: "Nm",
                                                                      type:
                                                                        %Isox.Schema.SimpleType{
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
                                                                      type:
                                                                        %Isox.Schema.ComplexType{
                                                                          content: [
                                                                            %Isox.Schema.Choice{
                                                                              options: [
                                                                                %Isox.Schema.Element{
                                                                                  tag: "PrvtId",
                                                                                  type:
                                                                                    %Isox.Schema.ComplexType{
                                                                                      content: [
                                                                                        %Isox.Schema.Element{
                                                                                          tag:
                                                                                            "Othr",
                                                                                          type:
                                                                                            %Isox.Schema.ComplexType{
                                                                                              content:
                                                                                                [
                                                                                                  %Isox.Schema.Element{
                                                                                                    tag:
                                                                                                      "Id",
                                                                                                    type:
                                                                                                      %Isox.Schema.SimpleType{
                                                                                                        base:
                                                                                                          "string",
                                                                                                        pattern:
                                                                                                          "[0-9]{11}|[0-9A-Z]{12}[0-9]{2}",
                                                                                                        enum:
                                                                                                          nil,
                                                                                                        max_length:
                                                                                                          nil,
                                                                                                        min_length:
                                                                                                          nil,
                                                                                                        fraction_digits:
                                                                                                          nil,
                                                                                                        total_digits:
                                                                                                          nil,
                                                                                                        min_inclusive:
                                                                                                          nil,
                                                                                                        max_inclusive:
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
                                                                                          min: 1,
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
                                                    %Isox.Schema.Element{
                                                      tag: "DbtrAcct",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "Id",
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
                                                                              "[0-9A-Z]{1,20}",
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
                                                                        type:
                                                                          %Isox.Schema.SimpleType{
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
                                                                      type:
                                                                        %Isox.Schema.SimpleType{
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
                                                                      type:
                                                                        %Isox.Schema.ComplexType{
                                                                          content: [
                                                                            %Isox.Schema.Choice{
                                                                              options: [
                                                                                %Isox.Schema.Element{
                                                                                  tag: "PrvtId",
                                                                                  type:
                                                                                    %Isox.Schema.ComplexType{
                                                                                      content: [
                                                                                        %Isox.Schema.Element{
                                                                                          tag:
                                                                                            "Othr",
                                                                                          type:
                                                                                            %Isox.Schema.ComplexType{
                                                                                              content:
                                                                                                [
                                                                                                  %Isox.Schema.Element{
                                                                                                    tag:
                                                                                                      "Id",
                                                                                                    type:
                                                                                                      %Isox.Schema.SimpleType{
                                                                                                        base:
                                                                                                          "string",
                                                                                                        pattern:
                                                                                                          "[0-9]{11}|[0-9A-Z]{12}[0-9]{2}",
                                                                                                        enum:
                                                                                                          nil,
                                                                                                        max_length:
                                                                                                          nil,
                                                                                                        min_length:
                                                                                                          nil,
                                                                                                        fraction_digits:
                                                                                                          nil,
                                                                                                        total_digits:
                                                                                                          nil,
                                                                                                        min_inclusive:
                                                                                                          nil,
                                                                                                        max_inclusive:
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
                                                                                          min: 1,
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
                                                    %Isox.Schema.Element{
                                                      tag: "CdtrAcct",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "Id",
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
                                                                              "[0-9A-Z]{1,20}",
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
                                                                        type:
                                                                          %Isox.Schema.SimpleType{
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
                                                                      type:
                                                                        %Isox.Schema.SimpleType{
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
                                                min: 0,
                                                max: 1
                                              },
                                              %Isox.Schema.Element{
                                                tag: "RltdAgts",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
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
                                                                        type:
                                                                          %Isox.Schema.SimpleType{
                                                                            base: "string",
                                                                            pattern:
                                                                              "[0-9A-Z]{8}",
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
                                                      min: 0,
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
                                                                        type:
                                                                          %Isox.Schema.SimpleType{
                                                                            base: "string",
                                                                            pattern:
                                                                              "[0-9A-Z]{8}",
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
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %Isox.Schema.Element{
                                                      tag: "Prtry",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "Tp",
                                                            type: %Isox.Schema.SimpleType{
                                                              base: "string",
                                                              pattern: nil,
                                                              enum: [
                                                                "ContraparteSelic",
                                                                "ContraparteSTR"
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
                                                          },
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
                                                                        type:
                                                                          %Isox.Schema.ComplexType{
                                                                            content: [
                                                                              %Isox.Schema.Element{
                                                                                tag: "MmbId",
                                                                                type:
                                                                                  %Isox.Schema.SimpleType{
                                                                                    base:
                                                                                      "string",
                                                                                    pattern:
                                                                                      "[0-9A-Z]{8}",
                                                                                    enum: nil,
                                                                                    max_length: 8,
                                                                                    min_length:
                                                                                      nil,
                                                                                    fraction_digits:
                                                                                      nil,
                                                                                    total_digits:
                                                                                      nil,
                                                                                    min_inclusive:
                                                                                      nil,
                                                                                    max_inclusive:
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
                                                min: 0,
                                                max: 1
                                              },
                                              %Isox.Schema.Element{
                                                tag: "Purp",
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
                                                              "GSCB",
                                                              "IPAY",
                                                              "IPRT",
                                                              "OTHR",
                                                              "REFU"
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
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %Isox.Schema.Element{
                                                      tag: "Strd",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "RfrdDocInf",
                                                            type: %Isox.Schema.ComplexType{
                                                              content: [
                                                                %Isox.Schema.Element{
                                                                  tag: "Tp",
                                                                  type: %Isox.Schema.ComplexType{
                                                                    content: [
                                                                      %Isox.Schema.Element{
                                                                        tag: "CdOrPrtry",
                                                                        type:
                                                                          %Isox.Schema.ComplexType{
                                                                            content: [
                                                                              %Isox.Schema.Choice{
                                                                                options: [
                                                                                  %Isox.Schema.Element{
                                                                                    tag: "Prtry",
                                                                                    type:
                                                                                      %Isox.Schema.SimpleType{
                                                                                        base:
                                                                                          "string",
                                                                                        pattern:
                                                                                          nil,
                                                                                        enum: [
                                                                                          "AGFSS",
                                                                                          "AGTEC",
                                                                                          "AGTOT"
                                                                                        ],
                                                                                        max_length:
                                                                                          nil,
                                                                                        min_length:
                                                                                          nil,
                                                                                        fraction_digits:
                                                                                          nil,
                                                                                        total_digits:
                                                                                          nil,
                                                                                        min_inclusive:
                                                                                          nil,
                                                                                        max_inclusive:
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
                                                                      %Isox.Schema.Element{
                                                                        tag: "Issr",
                                                                        type:
                                                                          %Isox.Schema.SimpleType{
                                                                            base: "string",
                                                                            pattern:
                                                                              "[0-9A-Z]{8}",
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
                                                          },
                                                          %Isox.Schema.Element{
                                                            tag: "RfrdDocAmt",
                                                            type: %Isox.Schema.ComplexType{
                                                              content: [
                                                                %Isox.Schema.Element{
                                                                  tag: "AdjstmntAmtAndRsn",
                                                                  type: %Isox.Schema.ComplexType{
                                                                    content: [
                                                                      %Isox.Schema.Element{
                                                                        tag: "Amt",
                                                                        type:
                                                                          %Isox.Schema.ComplexType{
                                                                            content: [],
                                                                            attributes: [
                                                                              %Isox.Schema.Attribute{
                                                                                tag: "Ccy",
                                                                                type:
                                                                                  %Isox.Schema.SimpleType{
                                                                                    base:
                                                                                      "string",
                                                                                    pattern: nil,
                                                                                    enum: ["BRL"],
                                                                                    max_length:
                                                                                      nil,
                                                                                    min_length:
                                                                                      nil,
                                                                                    fraction_digits:
                                                                                      nil,
                                                                                    total_digits:
                                                                                      nil,
                                                                                    min_inclusive:
                                                                                      nil,
                                                                                    max_inclusive:
                                                                                      nil
                                                                                  },
                                                                                required: true
                                                                              }
                                                                            ],
                                                                            text:
                                                                              %Isox.Schema.SimpleType{
                                                                                base: "decimal",
                                                                                pattern: nil,
                                                                                enum: nil,
                                                                                max_length: nil,
                                                                                min_length: nil,
                                                                                fraction_digits:
                                                                                  2,
                                                                                total_digits: 18,
                                                                                min_inclusive:
                                                                                  "0",
                                                                                max_inclusive: nil
                                                                              }
                                                                          },
                                                                        min: 1,
                                                                        max: 1
                                                                      },
                                                                      %Isox.Schema.Element{
                                                                        tag: "Rsn",
                                                                        type:
                                                                          %Isox.Schema.SimpleType{
                                                                            base: "string",
                                                                            pattern: nil,
                                                                            enum: ["VLCP", "VLDN"],
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
                                              %Isox.Schema.Element{
                                                tag: "RltdDts",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "AccptncDtTm",
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
                                                min: 0,
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
                                                              enum: ["INF"],
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
                                                                        type:
                                                                          %Isox.Schema.SimpleType{
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
                                                      max: 2
                                                    }
                                                  ],
                                                  attributes: [],
                                                  text: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %Isox.Schema.Element{
                                                tag: "RtrInf",
                                                type: %Isox.Schema.ComplexType{
                                                  content: [
                                                    %Isox.Schema.Element{
                                                      tag: "Rsn",
                                                      type: %Isox.Schema.ComplexType{
                                                        content: [
                                                          %Isox.Schema.Element{
                                                            tag: "Cd",
                                                            type: %Isox.Schema.SimpleType{
                                                              base: "string",
                                                              pattern: nil,
                                                              enum: [
                                                                "BE08",
                                                                "FR01",
                                                                "MD06",
                                                                "SL02"
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
                                                min: 0,
                                                max: 1
                                              },
                                              %Isox.Schema.Element{
                                                tag: "AddtlTxInf",
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
                                  %Isox.Schema.Element{
                                    tag: "AddtlNtryInf",
                                    type: %Isox.Schema.SimpleType{
                                      base: "string",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: 4,
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
                              tag: "AddtlNtfctnInf",
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
