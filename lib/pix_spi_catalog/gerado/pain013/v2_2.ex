defmodule PixSpiCatalog.Gerado.Pain013.V2_2 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.013/2.2"
  def msg_def_idr, do: "pain.013.spi.2.2"

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
                  tag: "CdtrPmtActvtnReq",
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
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "NbOfTxs",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "integer",
                                pattern: "[0-9]{1,15}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "InitgPty",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Id",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "OrgId",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "Othr",
                                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                      conteudo: [
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Id",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                        tag: "PmtInf",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "PmtInfId",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: "[a-zA-Z0-9]{1,35}",
                                enum: nil,
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "PmtMtd",
                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                base: "string",
                                pattern: nil,
                                enum: ["TRF"],
                                max_length: nil,
                                min_length: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "ReqdExctnDt",
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
                              tag: "XpryDt",
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
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "Dbtr",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Id",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "PrvtId",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "Othr",
                                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                      conteudo: [
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Id",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                  }
                                ],
                                atributos: [],
                                texto: nil
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "DbtrAgt",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "FinInstnId",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "ClrSysMmbId",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "MmbId",
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
                              tag: "UltmtDbtr",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Nm",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "PrvtId",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "Othr",
                                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                      conteudo: [
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Id",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                  }
                                ],
                                atributos: [],
                                texto: nil
                              },
                              min: 0,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "CdtTrfTx",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "PmtId",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "EndToEndId",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "PmtTpInf",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "InstrPrty",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
                                            base: "string",
                                            pattern: nil,
                                            enum: ["NORM"],
                                            max_length: nil,
                                            min_length: nil
                                          },
                                          min: 1,
                                          max: 1
                                        },
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "SvcLvl",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "Prtry",
                                                tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "Prtry",
                                                tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                    tag: "Amt",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Escolha{
                                          opcoes: [
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "InstdAmt",
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
                                    tag: "ChrgBr",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                      base: "string",
                                      pattern: nil,
                                      enum: ["SLEV"],
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "MndtRltdInf",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "MndtId",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "CdtrAgt",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "FinInstnId",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "ClrSysMmbId",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "MmbId",
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
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "Id",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Escolha{
                                                opcoes: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "PrvtId",
                                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
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
                                                                        "[0-9]{11}|[0-9A-Z]{12}[0-9]{2}",
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
                                    tag: "CdtrAcct",
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
                                                            base: "integer",
                                                            pattern: "[0-9]{1,20}",
                                                            enum: nil,
                                                            max_length: nil,
                                                            min_length: nil
                                                          },
                                                          min: 1,
                                                          max: 1
                                                        },
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "Issr",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                          tag: "Tp",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Escolha{
                                                opcoes: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "Cd",
                                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                    tag: "Purp",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "Prtry",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                      atributos: [],
                                      texto: nil
                                    },
                                    min: 1,
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
                                                tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                  base: "string",
                                                  pattern: nil,
                                                  enum: ["COR", "INF"],
                                                  max_length: nil,
                                                  min_length: nil
                                                },
                                                min: 1,
                                                max: 1
                                              },
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "TaxAmt",
                                                tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                  conteudo: [
                                                    %PixSpiCatalog.Schema.Elemento{
                                                      tag: "TtlAmt",
                                                      tipo: %PixSpiCatalog.Schema.TipoComplexo{
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
                                          max: 4
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
