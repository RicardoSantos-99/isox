defmodule PixSpiCatalog.Gerado.Camt054.V1_15 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.054/1.15"
  def msg_def_idr, do: "camt.054.spi.1.15"

  def schema do
    %PixSpiCatalog.Schema.Elemento{
      tag: "Envelope",
      tipo: %PixSpiCatalog.Schema.TipoComplexo{
        conteudo: [
          %PixSpiCatalog.Schema.Elemento{
            tag: "AppHdr",
            tipo: PixSpiCatalog.Gerado.Head001.tipo(),
            min: 1,
            max: 1
          },
          %PixSpiCatalog.Schema.Elemento{
            tag: "Document",
            tipo: %PixSpiCatalog.Schema.TipoComplexo{
              conteudo: [
                %PixSpiCatalog.Schema.Elemento{
                  tag: "BkToCstmrDbtCdtNtfctn",
                  tipo: %PixSpiCatalog.Schema.TipoComplexo{
                    conteudo: [
                      %PixSpiCatalog.Schema.Elemento{
                        tag: "GrpHdr",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "MsgId",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: "[M][0-9A-Z]{8}[a-zA-Z0-9]{23}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "CreDtTm",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                          atributos: [],
                          texto: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %PixSpiCatalog.Schema.Elemento{
                        tag: "Ntfctn",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "Id",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: "[M][0-9A-Z]{8}[a-zA-Z0-9]{23}",
                                enum: nil,
                                max_length: 32,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "Acct",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Id",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Othr",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "Id",
                                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                atributos: [],
                                                texto: nil
                                              },
                                              min: 1,
                                              max: 1
                                            }
                                          ],
                                          min: 1,
                                          max: 1
                                        }
                                      ],
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
                                    max: 1
                                  }
                                ],
                                atributos: [],
                                texto: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "Ntry",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Amt",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [],
                                      atributos: [
                                        %PixSpiCatalog.Schema.Atributo{
                                          tag: "Ccy",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["BRL"],
                                            max_length: nil,
                                            min_length: nil
                                          },
                                          obrigatorio: true
                                        }
                                      ],
                                      texto: %PixSpiCatalog.Schema.TipoSimples{
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
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "CdtDbtInd",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["CRDT", "DBIT"],
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Sts",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Cd",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "BookgDt",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Dt",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 0,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "ValDt",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "DtTm",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 0,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "BkTxCd",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "Domn",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "Cd",
                                                tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["CAMT", "PMNT"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "Fmly",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Cd",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: ["IRCT", "MCOP", "MDOP", "RRCT"],
                                                        max_length: nil,
                                                        min_length: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "SubFmlyCd",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 1,
                                                max: 1
                                              }
                                            ],
                                            atributos: [],
                                            texto: nil
                                          },
                                          min: 1,
                                          max: 1
                                        }
                                      ],
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "AddtlInfInd",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "MsgNmId",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "NtryDtls",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "TxDtls",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "Refs",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "InstrId",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "EndToEndId",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "TxId",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: nil,
                                                        max_length: 35,
                                                        min_length: 1
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "ClrSysRef",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Prtry",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Tp",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoSimples{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: ["ServiceLevel"],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Ref",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    }
                                                  ],
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "RltdPties",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "InitgPty",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Escolha{
                                                            opcoes: [
                                                              %PixSpiCatalog.Schema.Elemento{
                                                                tag: "Pty",
                                                                tipo:
                                                                  %PixSpiCatalog.Schema.TipoComplexo{
                                                                    conteudo: [
                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                        tag: "Id",
                                                                        tipo:
                                                                          %PixSpiCatalog.Schema.TipoComplexo{
                                                                            conteudo: [
                                                                              %PixSpiCatalog.Schema.Escolha{
                                                                                opcoes: [
                                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                                    tag: "OrgId",
                                                                                    tipo:
                                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                                        conteudo:
                                                                                          [
                                                                                            %PixSpiCatalog.Schema.Elemento{
                                                                                              tag:
                                                                                                "Othr",
                                                                                              tipo:
                                                                                                %PixSpiCatalog.Schema.TipoComplexo{
                                                                                                  conteudo:
                                                                                                    [
                                                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                                                        tag:
                                                                                                          "Id",
                                                                                                        tipo:
                                                                                                          %PixSpiCatalog.Schema.TipoSimples{
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
                                                                                                  atributos:
                                                                                                    [],
                                                                                                  texto:
                                                                                                    nil
                                                                                                },
                                                                                              min:
                                                                                                1,
                                                                                              max:
                                                                                                1
                                                                                            }
                                                                                          ],
                                                                                        atributos:
                                                                                          [],
                                                                                        texto: nil
                                                                                      },
                                                                                    min: 1,
                                                                                    max: 1
                                                                                  }
                                                                                ],
                                                                                min: 1,
                                                                                max: 1
                                                                              }
                                                                            ],
                                                                            atributos: [],
                                                                            texto: nil
                                                                          },
                                                                        min: 1,
                                                                        max: 1
                                                                      }
                                                                    ],
                                                                    atributos: [],
                                                                    texto: nil
                                                                  },
                                                                min: 1,
                                                                max: 1
                                                              }
                                                            ],
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Dbtr",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Escolha{
                                                            opcoes: [
                                                              %PixSpiCatalog.Schema.Elemento{
                                                                tag: "Pty",
                                                                tipo:
                                                                  %PixSpiCatalog.Schema.TipoComplexo{
                                                                    conteudo: [
                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                        tag: "Nm",
                                                                        tipo:
                                                                          %PixSpiCatalog.Schema.TipoSimples{
                                                                            base: "string",
                                                                            pattern: nil,
                                                                            enum: nil,
                                                                            max_length: 140,
                                                                            min_length: 1
                                                                          },
                                                                        min: 1,
                                                                        max: 1
                                                                      },
                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                        tag: "Id",
                                                                        tipo:
                                                                          %PixSpiCatalog.Schema.TipoComplexo{
                                                                            conteudo: [
                                                                              %PixSpiCatalog.Schema.Escolha{
                                                                                opcoes: [
                                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                                    tag: "PrvtId",
                                                                                    tipo:
                                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                                        conteudo:
                                                                                          [
                                                                                            %PixSpiCatalog.Schema.Elemento{
                                                                                              tag:
                                                                                                "Othr",
                                                                                              tipo:
                                                                                                %PixSpiCatalog.Schema.TipoComplexo{
                                                                                                  conteudo:
                                                                                                    [
                                                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                                                        tag:
                                                                                                          "Id",
                                                                                                        tipo:
                                                                                                          %PixSpiCatalog.Schema.TipoSimples{
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
                                                                                                  atributos:
                                                                                                    [],
                                                                                                  texto:
                                                                                                    nil
                                                                                                },
                                                                                              min:
                                                                                                1,
                                                                                              max:
                                                                                                1
                                                                                            }
                                                                                          ],
                                                                                        atributos:
                                                                                          [],
                                                                                        texto: nil
                                                                                      },
                                                                                    min: 1,
                                                                                    max: 1
                                                                                  }
                                                                                ],
                                                                                min: 1,
                                                                                max: 1
                                                                              }
                                                                            ],
                                                                            atributos: [],
                                                                            texto: nil
                                                                          },
                                                                        min: 1,
                                                                        max: 1
                                                                      }
                                                                    ],
                                                                    atributos: [],
                                                                    texto: nil
                                                                  },
                                                                min: 1,
                                                                max: 1
                                                              }
                                                            ],
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "DbtrAcct",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Id",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "Othr",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "Id",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "Issr",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                        atributos: [],
                                                                        texto: nil
                                                                      },
                                                                    min: 1,
                                                                    max: 1
                                                                  }
                                                                ],
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Tp",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Escolha{
                                                                    opcoes: [
                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                        tag: "Cd",
                                                                        tipo:
                                                                          %PixSpiCatalog.Schema.TipoSimples{
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
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Cdtr",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Escolha{
                                                            opcoes: [
                                                              %PixSpiCatalog.Schema.Elemento{
                                                                tag: "Pty",
                                                                tipo:
                                                                  %PixSpiCatalog.Schema.TipoComplexo{
                                                                    conteudo: [
                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                        tag: "Id",
                                                                        tipo:
                                                                          %PixSpiCatalog.Schema.TipoComplexo{
                                                                            conteudo: [
                                                                              %PixSpiCatalog.Schema.Escolha{
                                                                                opcoes: [
                                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                                    tag: "PrvtId",
                                                                                    tipo:
                                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                                        conteudo:
                                                                                          [
                                                                                            %PixSpiCatalog.Schema.Elemento{
                                                                                              tag:
                                                                                                "Othr",
                                                                                              tipo:
                                                                                                %PixSpiCatalog.Schema.TipoComplexo{
                                                                                                  conteudo:
                                                                                                    [
                                                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                                                        tag:
                                                                                                          "Id",
                                                                                                        tipo:
                                                                                                          %PixSpiCatalog.Schema.TipoSimples{
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
                                                                                                  atributos:
                                                                                                    [],
                                                                                                  texto:
                                                                                                    nil
                                                                                                },
                                                                                              min:
                                                                                                1,
                                                                                              max:
                                                                                                1
                                                                                            }
                                                                                          ],
                                                                                        atributos:
                                                                                          [],
                                                                                        texto: nil
                                                                                      },
                                                                                    min: 1,
                                                                                    max: 1
                                                                                  }
                                                                                ],
                                                                                min: 1,
                                                                                max: 1
                                                                              }
                                                                            ],
                                                                            atributos: [],
                                                                            texto: nil
                                                                          },
                                                                        min: 1,
                                                                        max: 1
                                                                      }
                                                                    ],
                                                                    atributos: [],
                                                                    texto: nil
                                                                  },
                                                                min: 1,
                                                                max: 1
                                                              }
                                                            ],
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "CdtrAcct",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Id",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "Othr",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "Id",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "Issr",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                        atributos: [],
                                                                        texto: nil
                                                                      },
                                                                    min: 1,
                                                                    max: 1
                                                                  }
                                                                ],
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Tp",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Escolha{
                                                                    opcoes: [
                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                        tag: "Cd",
                                                                        tipo:
                                                                          %PixSpiCatalog.Schema.TipoSimples{
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
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Prxy",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "Id",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoSimples{
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
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 0,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    }
                                                  ],
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "RltdAgts",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "DbtrAgt",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "FinInstnId",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "ClrSysMmbId",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "MmbId",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                        atributos: [],
                                                                        texto: nil
                                                                      },
                                                                    min: 1,
                                                                    max: 1
                                                                  }
                                                                ],
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "CdtrAgt",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "FinInstnId",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "ClrSysMmbId",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "MmbId",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                        atributos: [],
                                                                        texto: nil
                                                                      },
                                                                    min: 1,
                                                                    max: 1
                                                                  }
                                                                ],
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Prtry",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Tp",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Agt",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "FinInstnId",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "ClrSysMmbId",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                                conteudo: [
                                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                                    tag: "MmbId",
                                                                                    tipo:
                                                                                      %PixSpiCatalog.Schema.TipoSimples{
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
                                                                                atributos: [],
                                                                                texto: nil
                                                                              },
                                                                            min: 1,
                                                                            max: 1
                                                                          }
                                                                        ],
                                                                        atributos: [],
                                                                        texto: nil
                                                                      },
                                                                    min: 1,
                                                                    max: 1
                                                                  }
                                                                ],
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    }
                                                  ],
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "LclInstrm",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Escolha{
                                                      opcoes: [
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Prtry",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "Purp",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Escolha{
                                                      opcoes: [
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Cd",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "RmtInf",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Ustrd",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                        base: "string",
                                                        pattern: nil,
                                                        enum: nil,
                                                        max_length: 140,
                                                        min_length: 1
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Strd",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "RfrdDocInf",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "Tp",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "CdOrPrtry",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                                conteudo: [
                                                                                  %PixSpiCatalog.Schema.Escolha{
                                                                                    opcoes: [
                                                                                      %PixSpiCatalog.Schema.Elemento{
                                                                                        tag:
                                                                                          "Prtry",
                                                                                        tipo:
                                                                                          %PixSpiCatalog.Schema.TipoSimples{
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
                                                                                atributos: [],
                                                                                texto: nil
                                                                              },
                                                                            min: 1,
                                                                            max: 1
                                                                          },
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "Issr",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                        atributos: [],
                                                                        texto: nil
                                                                      },
                                                                    min: 1,
                                                                    max: 1
                                                                  }
                                                                ],
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "RfrdDocAmt",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "AdjstmntAmtAndRsn",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "Amt",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                                conteudo: [],
                                                                                atributos: [
                                                                                  %PixSpiCatalog.Schema.Atributo{
                                                                                    tag: "Ccy",
                                                                                    tipo:
                                                                                      %PixSpiCatalog.Schema.TipoSimples{
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
                                                                                    obrigatorio:
                                                                                      true
                                                                                  }
                                                                                ],
                                                                                texto:
                                                                                  %PixSpiCatalog.Schema.TipoSimples{
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
                                                                          %PixSpiCatalog.Schema.Elemento{
                                                                            tag: "Rsn",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                                        atributos: [],
                                                                        texto: nil
                                                                      },
                                                                    min: 1,
                                                                    max: 2
                                                                  }
                                                                ],
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    }
                                                  ],
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "RltdDts",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "AccptncDtTm",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "Tax",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "RefNb",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                        base: "string",
                                                        pattern: "[a-zA-Z0-9]{1,50}",
                                                        enum: nil,
                                                        max_length: nil,
                                                        min_length: nil
                                                      },
                                                      min: 0,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Rcrd",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Tp",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoSimples{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: ["CBSSPLIT", "IBSSPLIT"],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Ctgy",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoSimples{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: ["INF"],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          },
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "TaxAmt",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoComplexo{
                                                                conteudo: [
                                                                  %PixSpiCatalog.Schema.Elemento{
                                                                    tag: "TtlAmt",
                                                                    tipo:
                                                                      %PixSpiCatalog.Schema.TipoComplexo{
                                                                        conteudo: [],
                                                                        atributos: [
                                                                          %PixSpiCatalog.Schema.Atributo{
                                                                            tag: "Ccy",
                                                                            tipo:
                                                                              %PixSpiCatalog.Schema.TipoSimples{
                                                                                base: "string",
                                                                                pattern: nil,
                                                                                enum: ["BRL"],
                                                                                max_length: nil,
                                                                                min_length: nil
                                                                              },
                                                                            obrigatorio: true
                                                                          }
                                                                        ],
                                                                        texto:
                                                                          %PixSpiCatalog.Schema.TipoSimples{
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
                                                                atributos: [],
                                                                texto: nil
                                                              },
                                                            min: 1,
                                                            max: 1
                                                          }
                                                        ],
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 2,
                                                      max: 2
                                                    }
                                                  ],
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "RtrInf",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "Rsn",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                        conteudo: [
                                                          %PixSpiCatalog.Schema.Elemento{
                                                            tag: "Cd",
                                                            tipo:
                                                              %PixSpiCatalog.Schema.TipoSimples{
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
                                                        atributos: [],
                                                        texto: nil
                                                      },
                                                      min: 1,
                                                      max: 1
                                                    },
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "AddtlInf",
                                                      tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                  atributos: [],
                                                  texto: nil
                                                },
                                                min: 0,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "AddtlTxInf",
                                                tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                            atributos: [],
                                            texto: nil
                                          },
                                          min: 1,
                                          max: 1
                                        }
                                      ],
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "AddtlNtryInf",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                atributos: [],
                                texto: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "AddtlNtfctnInf",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                          atributos: [],
                          texto: nil
                        },
                        min: 1,
                        max: :ilimitado
                      }
                    ],
                    atributos: [],
                    texto: nil
                  },
                  min: 1,
                  max: 1
                }
              ],
              atributos: [],
              texto: nil
            },
            min: 1,
            max: 1
          }
        ]
      }
    }
  end

  def parse(xml), do: Codec.parse(schema(), xml)
  def build(termo), do: Codec.build(schema(), termo, namespace())
end
