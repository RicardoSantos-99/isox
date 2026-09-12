defmodule PixSpiCatalog.Generated.Admi002.V1_5 do
  @moduledoc false

  alias PixSpiCatalog.Xml.Codec

  def namespace, do: "https://www.bcb.gov.br/pi/admi.002/1.5"
  def msg_def_idr, do: "admi.002.spi.1.5"

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
                  tag: "admi.002.001.01",
                  type: %PixSpiCatalog.Schema.ComplexType{
                    content: [
                      %PixSpiCatalog.Schema.Element{
                        tag: "RltdRef",
                        type: %PixSpiCatalog.Schema.ComplexType{
                          content: [
                            %PixSpiCatalog.Schema.Element{
                              tag: "Ref",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 33,
                                min_length: 1
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
                              tag: "RjctgPtyRsn",
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
                              tag: "RjctnDtTm",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "dateTime",
                                pattern:
                                  "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
                                enum: nil,
                                max_length: nil,
                                min_length: nil
                              },
                              min: 0,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "ErrLctn",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 350,
                                min_length: 1
                              },
                              min: 0,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "RsnDesc",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 350,
                                min_length: 1
                              },
                              min: 0,
                              max: 1
                            },
                            %PixSpiCatalog.Schema.Element{
                              tag: "AddtlData",
                              type: %PixSpiCatalog.Schema.SimpleType{
                                base: "string",
                                pattern: nil,
                                enum: nil,
                                max_length: 1000,
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
