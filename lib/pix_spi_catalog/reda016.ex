defmodule PixSpiCatalog.Reda016 do
  @moduledoc """
  Representação de domínio do reda.016 (aviso de status — resposta a
  reda.014/022/031), versão 1.5. Correlaciona com o pedido original por
  `OrgnlBizInstr.MsgId`.

  `rsn_prtry` só faz sentido quando `sts` é rejeição; `sys_pty_ispb`
  (e, dentro dele, `rspnsbl_pty_ispb`) só quando o pedido teve sucesso —
  ambos opcionais, cada um controlando a presença do próprio elemento
  contêiner (`StsRsn`/`SysPtyId`).
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Reda016.V1_5

  @type versao :: :v1_5

  defstruct [
    :msg_id,
    :criado_em,
    :orgnl_msg_id,
    :sts,
    :rsn_prtry,
    :sys_pty_ispb,
    :rspnsbl_pty_ispb
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          orgnl_msg_id: String.t(),
          sts: String.t(),
          rsn_prtry: String.t() | nil,
          sys_pty_ispb: String.t() | nil,
          rspnsbl_pty_ispb: String.t() | nil
        }

  @campos_obrigatorios [:msg_id, :criado_em, :orgnl_msg_id, :sts]

  @modulo_por_versao %{v1_5: V1_5}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_5] do
    with :ok <- validar_obrigatorios(mensagem) do
      modulo = Map.fetch!(@modulo_por_versao, versao)

      termo = %{
        "AppHdr" => AppHdr.termo(cabecalho, modulo.msg_def_idr()),
        "Document" => termo_document(mensagem)
      }

      with {:ok, xml} <- modulo.build(termo) do
        confirmar(modulo, xml)
      end
    end
  end

  @doc "Parseia um XML de reda.016 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_reda016, modulo.msg_def_idr()}}
        end

      erro ->
        erro
    end
  end

  defp confirmar(modulo, xml) do
    case modulo.parse(xml) do
      {:ok, _termo} -> {:ok, xml}
      {:error, motivo} -> {:error, motivo}
    end
  end

  defp validar_obrigatorios(mensagem) do
    faltando = Enum.filter(@campos_obrigatorios, &(Map.get(mensagem, &1) in [nil, ""]))

    if faltando == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(faltando)}"}
  end

  defp termo_document(m) do
    %{
      "PtyStsAdvc" => %{
        "MsgHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => formatar_data_hora(m.criado_em),
          "OrgnlBizInstr" => %{"MsgId" => m.orgnl_msg_id}
        },
        "PtySts" =>
          %{"Sts" => m.sts}
          |> talvez_por("StsRsn", if(m.rsn_prtry, do: %{"Rsn" => %{"Prtry" => m.rsn_prtry}}))
          |> talvez_por("SysPtyId", sys_pty_id_termo(m))
      }
    }
  end

  defp sys_pty_id_termo(%{sys_pty_ispb: nil}), do: nil

  defp sys_pty_id_termo(m) do
    %{"Id" => %{"Id" => %{"PrtryId" => %{"Id" => m.sys_pty_ispb, "Issr" => "BCB"}}}}
    |> talvez_por("RspnsblPtyId", rspnsbl_pty_id_termo(m.rspnsbl_pty_ispb))
  end

  defp rspnsbl_pty_id_termo(nil), do: nil
  defp rspnsbl_pty_id_termo(ispb), do: %{"Id" => %{"PrtryId" => %{"Id" => ispb, "Issr" => "BCB"}}}

  defp talvez_por(mapa, _chave, nil), do: mapa
  defp talvez_por(mapa, chave, valor), do: Map.put(mapa, chave, valor)

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "PtyStsAdvc"])
    pty_sts = doc["PtySts"]
    sys_pty_id = pty_sts["SysPtyId"]

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["MsgHdr", "CreDtTm"])),
      orgnl_msg_id: get_in(doc, ["MsgHdr", "OrgnlBizInstr", "MsgId"]),
      sts: pty_sts["Sts"],
      rsn_prtry: get_in(pty_sts, ["StsRsn", "Rsn", "Prtry"]),
      sys_pty_ispb: get_in(sys_pty_id, ["Id", "Id", "PrtryId", "Id"]),
      rspnsbl_pty_ispb: get_in(sys_pty_id, ["RspnsblPtyId", "Id", "PrtryId", "Id"])
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
