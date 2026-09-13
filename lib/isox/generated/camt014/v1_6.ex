defmodule Isox.Generated.Camt014.V1_6 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/camt.014/1.6"
  def msg_def_idr, do: "camt.014.spi.1.6"

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
                  tag: "RtrMmb",
                  type: %Isox.Schema.ComplexType{
                    content: [
                      %Isox.Schema.Element{
                        tag: "MsgHdr",
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
                            }
                          ],
                          attributes: [],
                          text: nil
                        },
                        min: 1,
                        max: 1
                      },
                      %Isox.Schema.Element{
                        tag: "RptOrErr",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Choice{
                              options: [
                                %Isox.Schema.Element{
                                  tag: "Rpt",
                                  type: %Isox.Schema.ComplexType{
                                    content: [
                                      %Isox.Schema.Element{
                                        tag: "MmbId",
                                        type: %Isox.Schema.ComplexType{
                                          content: [
                                            %Isox.Schema.Choice{
                                              options: [
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
                                        tag: "MmbOrErr",
                                        type: %Isox.Schema.ComplexType{
                                          content: [
                                            %Isox.Schema.Choice{
                                              options: [
                                                %Isox.Schema.Element{
                                                  tag: "Mmb",
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
                                                        tag: "RtrAdr",
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
                      %Isox.Schema.Element{
                        tag: "PtyRoleIdSD1",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "FullLglNm",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 350,
                                min_length: 1
                              },
                              min: 1,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "RolePlyr",
                              type: %Isox.Schema.ComplexType{
                                content: [
                                  %Isox.Schema.Choice{
                                    options: [
                                      %Isox.Schema.Element{
                                        tag: "PtyRole",
                                        type: %Isox.Schema.ComplexType{
                                          content: [
                                            %Isox.Schema.Choice{
                                              options: [
                                                %Isox.Schema.Element{
                                                  tag: "Prtry",
                                                  type: %Isox.Schema.SimpleType{
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

  def decode(xml), do: Codec.parse(schema(), xml)
  def encode(term), do: Codec.build(schema(), term, namespace())
end
