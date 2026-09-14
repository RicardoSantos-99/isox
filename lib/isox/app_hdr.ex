defmodule Isox.AppHdr do
  @moduledoc """
  BAH (`head.001`): o cabeçalho que toda mensagem do catálogo carrega
  (Manual VIII).

  Fica isolado aqui porque todas as mensagens montam o mesmo cabeçalho do
  mesmo jeito. Só o `Document` muda de uma para outra.

  `Sgntr` sai sempre vazio deste módulo. A assinatura é montada à parte,
  por `Isox.sign/4`, e o codec trata `<Sgntr>` como opaco (ADR 0003, ADR
  0006).

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  defstruct [:from_ispb, :to_ispb, :biz_msg_idr, :created_at]

  @type t :: %__MODULE__{
          from_ispb: String.t(),
          to_ispb: String.t(),
          biz_msg_idr: String.t(),
          created_at: DateTime.t()
        }

  @doc "Termo genérico do `AppHdr`, para compor com o `Document` de uma message."
  @spec term(t(), String.t()) :: map()
  def term(%__MODULE__{} = header, msg_def_idr) do
    %{
      "Fr" => %{"FIId" => %{"FinInstnId" => %{"Othr" => %{"Id" => header.from_ispb}}}},
      "To" => %{"FIId" => %{"FinInstnId" => %{"Othr" => %{"Id" => header.to_ispb}}}},
      "BizMsgIdr" => header.biz_msg_idr,
      "MsgDefIdr" => msg_def_idr,
      "CreDt" => format_datetime(header.created_at),
      "Sgntr" => ""
    }
  end

  @doc "Struct a partir do term genérico já parseado."
  @spec from_term(map()) :: t()
  def from_term(term) do
    %__MODULE__{
      from_ispb: get_in(term, ["Fr", "FIId", "FinInstnId", "Othr", "Id"]),
      to_ispb: get_in(term, ["To", "FIId", "FinInstnId", "Othr", "Id"]),
      biz_msg_idr: term["BizMsgIdr"],
      created_at: parse_datetime(term["CreDt"])
    }
  end

  defp format_datetime(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(text) do
    {:ok, dt, _offset} = DateTime.from_iso8601(text)
    dt
  end
end
