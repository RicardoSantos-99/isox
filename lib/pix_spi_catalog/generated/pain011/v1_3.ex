defmodule PixSpiCatalog.Generated.Pain011.V1_3 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.011/1.3"
  def msg_def_idr, do: "pain.011.spi.1.3"

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
                  tag: "MndtCxlReq",
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
                              tag: "InstgAgt",
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
                            }
                          ],
                          attributes: [],
                          text: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %PixSpiCatalog.Schema.Element{
                        tag: "UndrlygCxlDtls",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "CxlRsn",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Orgtr",
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
                                    tag: "Rsn",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "Prtry",
                                          type: %PixSpiCatalog.Schema.SimpleType{
                                            base: "string",
                                            pattern: nil,
                                            enum: [
                                              "ACCL",
                                              "CPCL",
                                              "DCSD",
                                              "ERSL",
                                              "FRUD",
                                              "NRES",
                                              "OTHS",
                                              "PCFD",
                                              "SJUD",
                                              "SLCR",
                                              "SLDB"
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
                                  }
                                ],
                                attributes: [],
                                text: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "OrgnlMndt",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Choice{
                                    options: [
                                      %PixSpiCatalog.Schema.Element{
                                        tag: "OrgnlMndt",
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
                                            },
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "MndtReqId",
                                              type: %PixSpiCatalog.Schema.SimpleType{
                                                base: "string",
                                                pattern:
                                                  "[I][C][0-9A-Z]{8}[0-9]{4}[0-1][0-9][0-3][0-9][a-zA-Z0-9]{11}",
                                                enum: nil,
                                                max_length: nil,
                                                min_length: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "Ocrncs",
                                              type: %PixSpiCatalog.Schema.ComplexType{
                                                content: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "SeqTp",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: ["RCUR"],
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Frqcy",
                                                    type: %PixSpiCatalog.Schema.ComplexType{
                                                      content: [
                                                        %PixSpiCatalog.Schema.Choice{
                                                          options: [
                                                            %PixSpiCatalog.Schema.Element{
                                                              tag: "Tp",
                                                              type:
                                                                %PixSpiCatalog.Schema.SimpleType{
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
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "FrstColltnDt",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "date",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "FnlColltnDt",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
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
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "TrckgInd",
                                              type: %PixSpiCatalog.Schema.SimpleType{
                                                base: "boolean",
                                                pattern: nil,
                                                enum: nil,
                                                max_length: nil,
                                                min_length: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "ColltnAmt",
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
                                              min: 0,
                                              max: 1
                                            },
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "Cdtr",
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
                                                                type:
                                                                  %PixSpiCatalog.Schema.SimpleType{
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
                                              tag: "DbtrAcct",
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
                                                              type:
                                                                %PixSpiCatalog.Schema.ComplexType{
                                                                  content: [
                                                                    %PixSpiCatalog.Schema.Element{
                                                                      tag: "Id",
                                                                      type:
                                                                        %PixSpiCatalog.Schema.SimpleType{
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
                                                                      type:
                                                                        %PixSpiCatalog.Schema.SimpleType{
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
                                                                type:
                                                                  %PixSpiCatalog.Schema.SimpleType{
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
                                              tag: "RfrdDoc",
                                              type: %PixSpiCatalog.Schema.ComplexType{
                                                content: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Nb",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: 35,
                                                      min_length: 1
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "CdtrRef",
                                                    type: %PixSpiCatalog.Schema.SimpleType{
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
                            %PixSpiCatalog.Schema.Element{
                              tag: "SplmtryData",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Element{
                                    tag: "Envlp",
                                    type: %PixSpiCatalog.Schema.ComplexType{
                                      content: [
                                        %PixSpiCatalog.Schema.Element{
                                          tag: "MndtPrcgDtls",
                                          type: %PixSpiCatalog.Schema.ComplexType{
                                            content: [
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "MndtPrcgTp",
                                                type: %PixSpiCatalog.Schema.SimpleType{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CLTN", "CRTN"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Element{
                                                tag: "PrcgDtTm",
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
                                          min: 2,
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

  def parse(xml), do: Codec.parse(schema(), xml)
  def build(term), do: Codec.build(schema(), term, namespace())
end
