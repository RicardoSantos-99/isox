defmodule PixSpiCatalog.Gerado.Pain012.V1_4 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/pain.012/1.4"
  def msg_def_idr, do: "pain.012.spi.1.4"

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
                  tag: "MndtAccptncRpt",
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
                              tag: "InstgAgt",
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
                            }
                          ],
                          atributos: [],
                          texto: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %PixSpiCatalog.Schema.Elemento{
                        tag: "UndrlygAccptncDtls",
                        tipo: %PixSpiCatalog.Schema.TipoComplexo{
                          conteudo: [
                            %PixSpiCatalog.Schema.Elemento{
                              tag: "AccptncRslt",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Accptd",
                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                      base: "boolean",
                                      pattern: nil,
                                      enum: nil,
                                      max_length: nil,
                                      min_length: nil
                                    },
                                    min: 1,
                                    max: 1
                                  },
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "RjctRsn",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "Prtry",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                              tag: "OrgnlMndt",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Escolha{
                                    opcoes: [
                                      %PixSpiCatalog.Schema.Elemento{
                                        tag: "OrgnlMndt",
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
                                            },
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "MndtReqId",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Ocrncs",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "SeqTp",
                                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: ["RCUR"],
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "Frqcy",
                                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                      conteudo: [
                                                        %PixSpiCatalog.Schema.Escolha{
                                                          opcoes: [
                                                            %PixSpiCatalog.Schema.Elemento{
                                                              tag: "Tp",
                                                              tipo:
                                                                %PixSpiCatalog.Schema.TipoSimples{
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
                                                      atributos: [],
                                                      texto: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "FrstColltnDt",
                                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                      base: "date",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: nil,
                                                      min_length: nil
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "FnlColltnDt",
                                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                atributos: [],
                                                texto: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "TrckgInd",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                base: "boolean",
                                                pattern: nil,
                                                enum: nil,
                                                max_length: nil,
                                                min_length: nil
                                              },
                                              min: 1,
                                              max: 1
                                            },
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "ColltnAmt",
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
                                              min: 0,
                                              max: 1
                                            },
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "Cdtr",
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
                                              tag: "CdtrAgt",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "FinInstnId",
                                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
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
                                              tag: "Dbtr",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "PstlAdr",
                                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                      conteudo: [
                                                        %PixSpiCatalog.Schema.Elemento{
                                                          tag: "TwnNm",
                                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                                      atributos: [],
                                                      texto: nil
                                                    },
                                                    min: 0,
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
                                              tag: "DbtrAcct",
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
                                                              tipo:
                                                                %PixSpiCatalog.Schema.TipoComplexo{
                                                                  conteudo: [
                                                                    %PixSpiCatalog.Schema.Elemento{
                                                                      tag: "Id",
                                                                      tipo:
                                                                        %PixSpiCatalog.Schema.TipoSimples{
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
                                                                      tipo:
                                                                        %PixSpiCatalog.Schema.TipoSimples{
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
                                                          tipo:
                                                            %PixSpiCatalog.Schema.TipoComplexo{
                                                              conteudo: [
                                                                %PixSpiCatalog.Schema.Elemento{
                                                                  tag: "MmbId",
                                                                  tipo:
                                                                    %PixSpiCatalog.Schema.TipoSimples{
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
                                              tag: "MndtRef",
                                              tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                            %PixSpiCatalog.Schema.Elemento{
                                              tag: "RfrdDoc",
                                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                                conteudo: [
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "Nb",
                                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
                                                      base: "string",
                                                      pattern: nil,
                                                      enum: nil,
                                                      max_length: 35,
                                                      min_length: 1
                                                    },
                                                    min: 1,
                                                    max: 1
                                                  },
                                                  %PixSpiCatalog.Schema.Elemento{
                                                    tag: "CdtrRef",
                                                    tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                              tag: "SplmtryData",
                              tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                conteudo: [
                                  %PixSpiCatalog.Schema.Elemento{
                                    tag: "Envlp",
                                    tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                      conteudo: [
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "MndtPrcgDtls",
                                          tipo: %PixSpiCatalog.Schema.TipoComplexo{
                                            conteudo: [
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "MndtPrcgTp",
                                                tipo: %PixSpiCatalog.Schema.TipoSimples{
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
                                              %PixSpiCatalog.Schema.Elemento{
                                                tag: "PrcgDtTm",
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
                                          max: 3
                                        },
                                        %PixSpiCatalog.Schema.Elemento{
                                          tag: "MndtSts",
                                          tipo: %PixSpiCatalog.Schema.TipoSimples{
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
