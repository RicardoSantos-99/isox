defmodule PixSpiCatalog.AppHdr do
  @moduledoc """
  BAH (`head.001`) — cabeçalho compartilhado por toda mensagem do catálogo
  (Manual VIII). Fica isolado aqui porque toda mensagem aprofundada
  (pacs.008, pacs.002, admi.002, ...) monta o mesmo cabeçalho do mesmo
  jeito; só o `Document` muda por mensagem.

  `Sgntr` sai sempre vazio: a assinatura fica para a lib de XMLDSig
  (ADR 0003, ADR 0006), ainda não implementada.
  """

  defstruct [:ispb_origem, :ispb_destino, :biz_msg_idr, :criado_em]

  @type t :: %__MODULE__{
          ispb_origem: String.t(),
          ispb_destino: String.t(),
          biz_msg_idr: String.t(),
          criado_em: DateTime.t()
        }

  @doc "Termo genérico do `AppHdr`, para compor com o `Document` de uma mensagem."
  @spec termo(t(), String.t()) :: map()
  def termo(%__MODULE__{} = cabecalho, msg_def_idr) do
    %{
      "Fr" => %{"FIId" => %{"FinInstnId" => %{"Othr" => %{"Id" => cabecalho.ispb_origem}}}},
      "To" => %{"FIId" => %{"FinInstnId" => %{"Othr" => %{"Id" => cabecalho.ispb_destino}}}},
      "BizMsgIdr" => cabecalho.biz_msg_idr,
      "MsgDefIdr" => msg_def_idr,
      "CreDt" => formatar_data_hora(cabecalho.criado_em),
      "Sgntr" => ""
    }
  end

  @doc "Struct a partir do termo genérico já parseado."
  @spec de_termo(map()) :: t()
  def de_termo(termo) do
    %__MODULE__{
      ispb_origem: get_in(termo, ["Fr", "FIId", "FinInstnId", "Othr", "Id"]),
      ispb_destino: get_in(termo, ["To", "FIId", "FinInstnId", "Othr", "Id"]),
      biz_msg_idr: termo["BizMsgIdr"],
      criado_em: parse_data_hora(termo["CreDt"])
    }
  end

  defp formatar_data_hora(%DateTime{} = dt) do
    dt |> DateTime.truncate(:millisecond) |> DateTime.to_iso8601()
  end

  defp parse_data_hora(nil), do: nil

  defp parse_data_hora(texto) do
    {:ok, dt, _offset} = DateTime.from_iso8601(texto)
    dt
  end
end
