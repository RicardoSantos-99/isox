defmodule PixSpiCatalog.Generated.Camt014.V1_6 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.014/1.6"
  def msg_def_idr, do: "camt.014.spi.1.6"

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
                  tag: "RtrMmb",
                  type: %PixSpiCatalog.Schema.ComplexType{
                    content: [
                      %PixSpiCatalog.Schema.Element{
                        tag: "MsgHdr",
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
                        tag: "RptOrErr",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Choice{
                              options: [
                                %PixSpiCatalog.Schema.Element{
                                  tag: "Rpt",
                                  type: %PixSpiCatalog.Schema.ComplexType{
                                    content: [
                                      %PixSpiCatalog.Schema.Element{
                                        tag: "MmbId",
                                        type: %PixSpiCatalog.Schema.ComplexType{
                                          content: [
                                            %PixSpiCatalog.Schema.Choice{
                                              options: [
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
                                        tag: "MmbOrErr",
                                        type: %PixSpiCatalog.Schema.ComplexType{
                                          content: [
                                            %PixSpiCatalog.Schema.Choice{
                                              options: [
                                                %PixSpiCatalog.Schema.Element{
                                                  tag: "Mmb",
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
                                                        tag: "RtrAdr",
                                                        type: %PixSpiCatalog.Schema.ComplexType{
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
                                                                            "[0-9A-Z]{12}[0-9]{2}",
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
                                                      },
                                                      %PixSpiCatalog.Schema.Element{
                                                        tag: "Tp",
                                                        type: %PixSpiCatalog.Schema.ComplexType{
                                                          content: [
                                                            %PixSpiCatalog.Schema.Choice{
                                                              options: [
                                                                %PixSpiCatalog.Schema.Element{
                                                                  tag: "Cd",
                                                                  type:
                                                                    %PixSpiCatalog.Schema.SimpleType{
                                                                      base: "string",
                                                                      pattern: nil,
                                                                      enum: ["DRCT", "IDRT"],
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
                                                        tag: "Sts",
                                                        type: %PixSpiCatalog.Schema.ComplexType{
                                                          content: [
                                                            %PixSpiCatalog.Schema.Choice{
                                                              options: [
                                                                %PixSpiCatalog.Schema.Element{
                                                                  tag: "Cd",
                                                                  type:
                                                                    %PixSpiCatalog.Schema.SimpleType{
                                                                      base: "string",
                                                                      pattern: nil,
                                                                      enum: ["DLTD", "ENBL"],
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
                        tag: "PtyRoleIdSD1",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "FullLglNm",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 350,
                                min_length: 1
                              },
                              min: 1,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "RolePlyr",
                              type: %PixSpiCatalog.Schema.ComplexType{
                                content: [
                                  %PixSpiCatalog.Schema.Choice{
                                    options: [
                                      %PixSpiCatalog.Schema.Element{
                                        tag: "PtyRole",
                                        type: %PixSpiCatalog.Schema.ComplexType{
                                          content: [
                                            %PixSpiCatalog.Schema.Choice{
                                              options: [
                                                %PixSpiCatalog.Schema.Element{
                                                  tag: "Prtry",
                                                  type: %PixSpiCatalog.Schema.SimpleType{
                                                    base: "string",
                                                    pattern: nil,
                                                    enum: ["GOVE", "ITUS", "LESP", "PDCT"],
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
          }
        ]
      }
    }
  end

  def parse(xml), do: Codec.parse(schema(), xml)
  def build(term), do: Codec.build(schema(), term, namespace())
end
