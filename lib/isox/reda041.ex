defmodule Isox.Reda041 do
  @moduledoc """
  Modelo ISO 20022 do reda.041 (aviso de mudança de
  atividade/status de um participante), versão 1.7.

  `Rcrd.Othr` é `[1..3]` no schema real (`maxOccurs="3"`, sem
  `minOccurs` — logo `1` implícito), não `ilimitado` — no máximo uma
  alteração por campo (`FldNm`: `"MODP"`/`"NOME"`/`"NOMR"`, só 3 opções
  na tabela de domínios). Ao contrário de `StsRsnInf`/`TxInfAndSts` nos
  outros módulos, aqui a lista é o próprio conteúdo da mensagem (um ou
  mais campos alterados), então é modelada como lista de verdade, não
  simplificada pra 1 item. `encode/3` não precisa validar o limite
  explicitamente — `confirm/2` (round-trip) já rejeita 0 ou mais de 3
  itens via o motor (Isox.Xml.Codec, módulo interno).
  """

  alias Isox.AppHdr
  alias Isox.Generated.Reda041.V1_7

  @type version :: :v1_7

  defstruct [:msg_id, :created_at, :ispb, changes: []]

  @type change :: %{fld_nm: String.t(), od_fld_val: String.t(), new_fld_val: String.t()}

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          ispb: String.t(),
          changes: [change()]
        }

  @required_fields [:msg_id, :created_at, :ispb]

  @module_by_version %{v1_7: V1_7}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_7] do
    with :ok <- validate_required(message) do
      module = Map.fetch!(@module_by_version, version)

      term = %{
        "AppHdr" => AppHdr.term(header, module.msg_def_idr()),
        "Document" => document_term(message)
      }

      with {:ok, xml} <- module.encode(term) do
        confirm(module, xml)
      end
    end
  end

  @doc "Decodifica um XML de reda.041 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_reda041, module.msg_def_idr()}}
        end

      error ->
        error
    end
  end

  defp confirm(module, xml) do
    case module.decode(xml) do
      {:ok, _term} -> {:ok, xml}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_required(message) do
    missing = Enum.filter(@required_fields, &(Map.get(message, &1) in [nil, ""]))

    if missing == [],
      do: :ok,
      else: {:error, "campos obrigatórios ausentes: #{inspect(missing)}"}
  end

  defp document_term(m) do
    %{
      "PtyActvtyAdvc" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "PtyActvty" => %{
          "Chng" => %{
            "PtyId" => %{"Id" => %{"Id" => %{"PrtryId" => %{"Id" => m.ispb, "Issr" => "BCB"}}}}
          },
          "Rcrd" => %{"Othr" => Enum.map(m.changes, &change_term/1)}
        }
      }
    }
  end

  defp change_term(a) do
    %{"FldNm" => a.fld_nm, "OdFldVal" => a.od_fld_val, "NewFldVal" => a.new_fld_val}
  end

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "PtyActvtyAdvc"])
    ptyactvty = doc["PtyActvty"]

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
      ispb: get_in(ptyactvty, ["Chng", "PtyId", "Id", "Id", "PrtryId", "Id"]),
      changes: ptyactvty |> get_in(["Rcrd", "Othr"]) |> Enum.map(&change_from_term/1)
    }
  end

  defp change_from_term(t) do
    %{fld_nm: t["FldNm"], od_fld_val: t["OdFldVal"], new_fld_val: t["NewFldVal"]}
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
