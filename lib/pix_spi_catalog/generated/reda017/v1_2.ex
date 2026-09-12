defmodule PixSpiCatalog.Generated.Reda017.V1_2 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/reda.017/1.2"
  def msg_def_idr, do: "reda.017.spi.1.2"

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
                  tag: "PtyRpt",
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
                                  tag: "PtyRpt",
                                  type: %PixSpiCatalog.Schema.ComplexType{
                                    content: [
                                      %PixSpiCatalog.Schema.Element{
                                        tag: "PtyId",
                                        type: %PixSpiCatalog.Schema.ComplexType{
                                          content: [
                                            %PixSpiCatalog.Schema.Element{
                                              tag: "Id",
                                              type: %PixSpiCatalog.Schema.ComplexType{
                                                content: [
                                                  %PixSpiCatalog.Schema.Element{
                                                    tag: "Id",
                                                    type: %PixSpiCatalog.Schema.ComplexType{
                                                      content: [
                                                        %PixSpiCatalog.Schema.Choice{
                                                          options: [
                                                            %PixSpiCatalog.Schema.Element{
                                                              tag: "PrtryId",
                                                              type:
                                                                %PixSpiCatalog.Schema.ComplexType{
                                                                  content: [
                                                                    %PixSpiCatalog.Schema.Element{
                                                                      tag: "Id",
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
                                                                    },
                                                                    %PixSpiCatalog.Schema.Element{
                                                                      tag: "Issr",
                                                                      type:
                                                                        %PixSpiCatalog.Schema.SimpleType{
                                                                          base: "string",
                                                                          pattern: nil,
                                                                          enum: ["BCB"],
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
                                        tag: "PtyOrErr",
                                        type: %PixSpiCatalog.Schema.ComplexType{
                                          content: [
                                            %PixSpiCatalog.Schema.Choice{
                                              options: [
                                                %PixSpiCatalog.Schema.Element{
                                                  tag: "SysPty",
                                                  type: %PixSpiCatalog.Schema.ComplexType{
                                                    content: [
                                                      %PixSpiCatalog.Schema.Element{
                                                        tag: "MktSpcfcAttr",
                                                        type: %PixSpiCatalog.Schema.ComplexType{
                                                          content: [
                                                            %PixSpiCatalog.Schema.Element{
                                                              tag: "Nm",
                                                              type:
                                                                %PixSpiCatalog.Schema.SimpleType{
                                                                  base: "string",
                                                                  pattern: nil,
                                                                  enum: ["PRAZOCONFI"],
                                                                  max_length: nil,
                                                                  min_length: nil
                                                                },
                                                              min: 1,
                                                              max: 1
                                                            },
                                                            %PixSpiCatalog.Schema.Element{
                                                              tag: "Val",
                                                              type:
                                                                %PixSpiCatalog.Schema.SimpleType{
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
