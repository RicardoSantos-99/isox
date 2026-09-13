defmodule Isox.Generated.Reda017.V1_2 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/reda.017/1.2"
  def msg_def_idr, do: "reda.017.spi.1.2"

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
                  tag: "PtyRpt",
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
                                  tag: "PtyRpt",
                                  type: %Isox.Schema.ComplexType{
                                    content: [
                                      %Isox.Schema.Element{
                                        tag: "PtyId",
                                        type: %Isox.Schema.ComplexType{
                                          content: [
                                            %Isox.Schema.Element{
                                              tag: "Id",
                                              type: %Isox.Schema.ComplexType{
                                                content: [
                                                  %Isox.Schema.Element{
                                                    tag: "Id",
                                                    type: %Isox.Schema.ComplexType{
                                                      content: [
                                                        %Isox.Schema.Choice{
                                                          options: [
                                                            %Isox.Schema.Element{
                                                              tag: "PrtryId",
                                                              type: %Isox.Schema.ComplexType{
                                                                content: [
                                                                  %Isox.Schema.Element{
                                                                    tag: "Id",
                                                                    type: %Isox.Schema.SimpleType{
                                                                      base: "string",
                                                                      pattern: "[0-9A-Z]{8}",
                                                                      enum: nil,
                                                                      max_length: 8,
                                                                      min_length: nil
                                                                    },
                                                                    min: 1,
                                                                    max: 1
                                                                  },
                                                                  %Isox.Schema.Element{
                                                                    tag: "Issr",
                                                                    type: %Isox.Schema.SimpleType{
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
                                      %Isox.Schema.Element{
                                        tag: "PtyOrErr",
                                        type: %Isox.Schema.ComplexType{
                                          content: [
                                            %Isox.Schema.Choice{
                                              options: [
                                                %Isox.Schema.Element{
                                                  tag: "SysPty",
                                                  type: %Isox.Schema.ComplexType{
                                                    content: [
                                                      %Isox.Schema.Element{
                                                        tag: "MktSpcfcAttr",
                                                        type: %Isox.Schema.ComplexType{
                                                          content: [
                                                            %Isox.Schema.Element{
                                                              tag: "Nm",
                                                              type: %Isox.Schema.SimpleType{
                                                                base: "string",
                                                                pattern: nil,
                                                                enum: ["PRAZOCONFI"],
                                                                max_length: nil,
                                                                min_length: nil
                                                              },
                                                              min: 1,
                                                              max: 1
                                                            },
                                                            %Isox.Schema.Element{
                                                              tag: "Val",
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

  def decode(xml), do: Codec.parse(schema(), xml)
  def encode(term), do: Codec.build(schema(), term, namespace())
end
