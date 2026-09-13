defmodule Isox.Reda016 do
  @moduledoc """
  Modelo ISO 20022 do reda.016 (aviso de status — resposta a
  reda.014/022/031), versão 1.5. Correlaciona com o pedido original por
  `OrgnlBizInstr.MsgId`.

  `sts` tem 3 valores possíveis (`Status6Code`): `"COMP"` (sucesso),
  `"QUED"` (fila/pendência) e `"REJT"` (rejeição) — confirmado pelos 3
  exemplos oficiais do BCB. `rsn_prtry`/`StsRsn` é obrigatório em
  `"QUED"`/`"REJT"` e proibido em `"COMP"`; `sys_pty_ispb`/`SysPtyId` é
  o inverso — obrigatório em `"COMP"` (regra explícita da planilha do
  catálogo) e proibido em `"QUED"`/`"REJT"`. `rspnsbl_pty_ispb` só faz
  sentido dentro de `SysPtyId`, ou seja, exige `sys_pty_ispb`.
  `encode/3` valida tudo isso.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Reda016.V1_5

  @type version :: :v1_5

  defstruct [
    :msg_id,
    :created_at,
    :orgnl_msg_id,
    :sts,
    :rsn_prtry,
    :sys_pty_ispb,
    :rspnsbl_pty_ispb
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          orgnl_msg_id: String.t(),
          sts: String.t(),
          rsn_prtry: String.t() | nil,
          sys_pty_ispb: String.t() | nil,
          rspnsbl_pty_ispb: String.t() | nil
        }

  @required_fields [:msg_id, :created_at, :orgnl_msg_id, :sts]

  @module_by_version %{v1_5: V1_5}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_5] do
    with :ok <- validate_required(message),
         :ok <- validate_status_consistency(message) do
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

  @doc "Decodifica um XML de reda.016 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_reda016, module.msg_def_idr()}}
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

  defp validate_status_consistency(%{sts: "COMP", rsn_prtry: rsn}) when not is_nil(rsn) do
    {:error, "rsn_prtry não deve ser preenchido quando sts = \"COMP\""}
  end

  defp validate_status_consistency(%{sts: "COMP", sys_pty_ispb: nil}) do
    {:error, "sys_pty_ispb é obrigatório quando sts = \"COMP\""}
  end

  defp validate_status_consistency(%{sts: sts, rsn_prtry: nil}) when sts in ["QUED", "REJT"] do
    {:error, "rsn_prtry é obrigatório quando sts = #{inspect(sts)}"}
  end

  defp validate_status_consistency(%{sts: sts, sys_pty_ispb: ispb})
       when sts in ["QUED", "REJT"] and not is_nil(ispb) do
    {:error, "sys_pty_ispb não deve ser preenchido quando sts = #{inspect(sts)}"}
  end

  defp validate_status_consistency(%{sys_pty_ispb: nil, rspnsbl_pty_ispb: rspnsbl})
       when not is_nil(rspnsbl) do
    {:error, "rspnsbl_pty_ispb não pode ser preenchido sem sys_pty_ispb"}
  end

  defp validate_status_consistency(_message), do: :ok

  defp document_term(m) do
    %{
      "PtyStsAdvc" => %{
        "MsgHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => format_datetime(m.created_at),
          "OrgnlBizInstr" => %{"MsgId" => m.orgnl_msg_id}
        },
        "PtySts" =>
          %{"Sts" => m.sts}
          |> maybe_put("StsRsn", if(m.rsn_prtry, do: %{"Rsn" => %{"Prtry" => m.rsn_prtry}}))
          |> maybe_put("SysPtyId", sys_pty_id_term(m))
      }
    }
  end

  defp sys_pty_id_term(%{sys_pty_ispb: nil}), do: nil

  defp sys_pty_id_term(m) do
    %{"Id" => %{"Id" => %{"PrtryId" => %{"Id" => m.sys_pty_ispb, "Issr" => "BCB"}}}}
    |> maybe_put("RspnsblPtyId", rspnsbl_pty_id_term(m.rspnsbl_pty_ispb))
  end

  defp rspnsbl_pty_id_term(nil), do: nil
  defp rspnsbl_pty_id_term(ispb), do: %{"Id" => %{"PrtryId" => %{"Id" => ispb, "Issr" => "BCB"}}}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "PtyStsAdvc"])
    pty_sts = doc["PtySts"]
    sys_pty_id = pty_sts["SysPtyId"]

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
      orgnl_msg_id: get_in(doc, ["MsgHdr", "OrgnlBizInstr", "MsgId"]),
      sts: pty_sts["Sts"],
      rsn_prtry: get_in(pty_sts, ["StsRsn", "Rsn", "Prtry"]),
      sys_pty_ispb: get_in(sys_pty_id, ["Id", "Id", "PrtryId", "Id"]),
      rspnsbl_pty_ispb: get_in(sys_pty_id, ["RspnsblPtyId", "Id", "PrtryId", "Id"])
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
