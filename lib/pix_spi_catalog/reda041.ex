defmodule PixSpiCatalog.Reda041 do
  @moduledoc """
  Representação de domínio do reda.041 (aviso de mudança de
  atividade/status de um participante), versão 1.7.

  `Rcrd.Othr` é `max: ilimitado` no schema real — ao contrário de
  `StsRsnInf`/`TxInfAndSts` nos outros módulos, aqui a lista é o próprio
  conteúdo da mensagem (um ou mais campos alterados), então é modelada
  como lista de verdade, não simplificada pra 1 item.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Reda041.V1_7

  @type versao :: :v1_7

  defstruct [:msg_id, :criado_em, :ispb, alteracoes: []]

  @type alteracao :: %{fld_nm: String.t(), od_fld_val: String.t(), new_fld_val: String.t()}

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          ispb: String.t(),
          alteracoes: [alteracao()]
        }

  @campos_obrigatorios [:msg_id, :criado_em, :ispb]

  @modulo_por_versao %{v1_7: V1_7}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_7] do
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

  @doc "Parseia um XML de reda.041 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_reda041, modulo.msg_def_idr()}}
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
      "PtyActvtyAdvc" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "PtyActvty" => %{
          "Chng" => %{
            "PtyId" => %{"Id" => %{"Id" => %{"PrtryId" => %{"Id" => m.ispb, "Issr" => "BCB"}}}}
          },
          "Rcrd" => %{"Othr" => Enum.map(m.alteracoes, &termo_alteracao/1)}
        }
      }
    }
  end

  defp termo_alteracao(a) do
    %{"FldNm" => a.fld_nm, "OdFldVal" => a.od_fld_val, "NewFldVal" => a.new_fld_val}
  end

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "PtyActvtyAdvc"])
    ptyactvty = doc["PtyActvty"]

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["MsgHdr", "CreDtTm"])),
      ispb: get_in(ptyactvty, ["Chng", "PtyId", "Id", "Id", "PrtryId", "Id"]),
      alteracoes: ptyactvty |> get_in(["Rcrd", "Othr"]) |> Enum.map(&alteracao_de_termo/1)
    }
  end

  defp alteracao_de_termo(t) do
    %{fld_nm: t["FldNm"], od_fld_val: t["OdFldVal"], new_fld_val: t["NewFldVal"]}
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
