defmodule PixSpiCatalog.Generated.Head001 do
  @moduledoc false

  def type,
    do: %PixSpiCatalog.Schema.ComplexType{
      content: [
        %PixSpiCatalog.Schema.Element{
          tag: "Fr",
          type: %PixSpiCatalog.Schema.ComplexType{
            content: [
              %PixSpiCatalog.Schema.Choice{
                options: [
                  %PixSpiCatalog.Schema.Element{
                    tag: "FIId",
                    type: %PixSpiCatalog.Schema.ComplexType{
                      content: [
                        %PixSpiCatalog.Schema.Element{
                          tag: "FinInstnId",
                          type: %PixSpiCatalog.Schema.ComplexType{
                            content: [
                              %PixSpiCatalog.Schema.Element{
                                tag: "Othr",
                                type: %PixSpiCatalog.Schema.ComplexType{
                                  content: [
                                    %PixSpiCatalog.Schema.Element{
                                      tag: "Id",
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
          tag: "To",
          type: %PixSpiCatalog.Schema.ComplexType{
            content: [
              %PixSpiCatalog.Schema.Choice{
                options: [
                  %PixSpiCatalog.Schema.Element{
                    tag: "FIId",
                    type: %PixSpiCatalog.Schema.ComplexType{
                      content: [
                        %PixSpiCatalog.Schema.Element{
                          tag: "FinInstnId",
                          type: %PixSpiCatalog.Schema.ComplexType{
                            content: [
                              %PixSpiCatalog.Schema.Element{
                                tag: "Othr",
                                type: %PixSpiCatalog.Schema.ComplexType{
                                  content: [
                                    %PixSpiCatalog.Schema.Element{
                                      tag: "Id",
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
          tag: "BizMsgIdr",
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
          tag: "MsgDefIdr",
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
          tag: "CreDt",
          type: %PixSpiCatalog.Schema.SimpleType{
            base: "dateTime",
            pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
            enum: nil,
            max_length: nil,
            min_length: nil
          },
          min: 1,
          max: 1
        },
        %PixSpiCatalog.Schema.Element{tag: "Sgntr", type: :opaque, min: 1, max: 1}
      ],
      attributes: [],
      text: nil
    }
end
