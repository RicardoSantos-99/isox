defmodule Isox.Generated.Head001 do
  @moduledoc false

  def type,
    do: %Isox.Schema.ComplexType{
      content: [
        %Isox.Schema.Element{
          tag: "Fr",
          type: %Isox.Schema.ComplexType{
            content: [
              %Isox.Schema.Choice{
                options: [
                  %Isox.Schema.Element{
                    tag: "FIId",
                    type: %Isox.Schema.ComplexType{
                      content: [
                        %Isox.Schema.Element{
                          tag: "FinInstnId",
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
        %Isox.Schema.Element{
          tag: "To",
          type: %Isox.Schema.ComplexType{
            content: [
              %Isox.Schema.Choice{
                options: [
                  %Isox.Schema.Element{
                    tag: "FIId",
                    type: %Isox.Schema.ComplexType{
                      content: [
                        %Isox.Schema.Element{
                          tag: "FinInstnId",
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
        %Isox.Schema.Element{
          tag: "BizMsgIdr",
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
          tag: "MsgDefIdr",
          type: %Isox.Schema.SimpleType{
            base: "string",
            pattern: nil,
            enum: nil,
            max_length: 35,
            min_length: 1
          },
          min: 1,
          max: 1
        },
        %Isox.Schema.Element{
          tag: "CreDt",
          type: %Isox.Schema.SimpleType{
            base: "dateTime",
            pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}Z",
            enum: nil,
            max_length: nil,
            min_length: nil
          },
          min: 1,
          max: 1
        },
        %Isox.Schema.Element{tag: "Sgntr", type: :opaque, min: 1, max: 1}
      ],
      attributes: [],
      text: nil
    }
end
