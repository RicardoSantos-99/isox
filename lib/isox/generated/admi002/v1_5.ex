defmodule Isox.Generated.Admi002.V1_5 do
  @moduledoc false

  alias Isox.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/admi.002/1.5"
  def msg_def_idr, do: "admi.002.spi.1.5"

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
                  tag: "admi.002.001.01",
                  type: %Isox.Schema.ComplexType{
                    content: [
                      %Isox.Schema.Element{
                        tag: "RltdRef",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "Ref",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 33,
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
                        tag: "Rsn",
                        type: %Isox.Schema.ComplexType{
                          content: [
                            %Isox.Schema.Element{
                              tag: "RjctgPtyRsn",
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
                            },
                            %Isox.Schema.Element{
                              tag: "RjctnDtTm",
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
                              min: 0,
                              max: 1
                            },
                            %Isox.Schema.Element{
                              tag: "ErrLctn",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 350,
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
                              tag: "RsnDesc",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 350,
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
                              tag: "AddtlData",
                              type: %Isox.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 1000,
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
