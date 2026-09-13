defmodule Isox.Pain014 do
  @moduledoc """
  Modelo ISO 20022 do pain.014 (resposta a pain.013), versões 2.3
  e 2.4 coexistindo. Correlaciona com a instrução agendada por
  `OrgnlPmtInfId`/`OrgnlEndToEndId`.

  O schema real só define `TxSts` como `ACSP`/`RJCT` — um eventual estado
  de fila/pendência não existe neste schema, então não é modelado aqui.

  `InitgPty` (14 zeros) e `OrgnlGrpInfAndSts` (`OrgnlMsgId` com 32 zeros,
  `OrgnlMsgNmId` com 8 zeros) são valores fixos no perfil do BCB, não
  campos variáveis — a correlação de verdade acontece em
  `OrgnlPmtInfAndSts`, não no grupo.
  """

  alias Isox.AppHdr
  alias Isox.Generated.Pain014.{V2_3, V2_4}

  @type version :: :v2_3 | :v2_4

  defstruct [
    :msg_id,
    :created_at,
    :orgnl_pmt_inf_id,
    :orgnl_end_to_end_id,
    :tx_sts,
    :rsn_prtry,
    :dbtr_dcsn_dt_tm,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          orgnl_pmt_inf_id: String.t(),
          orgnl_end_to_end_id: String.t(),
          tx_sts: String.t(),
          rsn_prtry: String.t() | nil,
          dbtr_dcsn_dt_tm: DateTime.t(),
          cdtr_agt_ispb: String.t(),
          cdtr_cpf_cnpj: String.t()
        }

  @required_fields [
    :msg_id,
    :created_at,
    :orgnl_pmt_inf_id,
    :orgnl_end_to_end_id,
    :tx_sts,
    :dbtr_dcsn_dt_tm,
    :cdtr_agt_ispb,
    :cdtr_cpf_cnpj
  ]

  @module_by_version %{v2_3: V2_3, v2_4: V2_4}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version)
      when version in [:v2_3, :v2_4] do
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

  @doc "Decodifica um XML de pain.014 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_pain014, module.msg_def_idr()}}
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
      "CdtrPmtActvtnReqStsRpt" => %{
        "GrpHdr" => %{
          "MsgId" => m.msg_id,
          "CreDtTm" => format_datetime(m.created_at),
          "InitgPty" => %{
            "Id" => %{"OrgId" => %{"Othr" => %{"Id" => String.duplicate("0", 14)}}}
          }
        },
        "OrgnlGrpInfAndSts" => %{
          "OrgnlMsgId" => String.duplicate("0", 32),
          "OrgnlMsgNmId" => String.duplicate("0", 8)
        },
        "OrgnlPmtInfAndSts" => [
          %{
            "OrgnlPmtInfId" => m.orgnl_pmt_inf_id,
            "TxInfAndSts" =>
              %{
                "OrgnlEndToEndId" => m.orgnl_end_to_end_id,
                "TxSts" => m.tx_sts,
                "DbtrDcsnDtTm" => format_datetime(m.dbtr_dcsn_dt_tm),
                "OrgnlTxRef" => %{
                  "CdtrAgt" => agent_term(m.cdtr_agt_ispb),
                  "Cdtr" => %{"Id" => %{"PrvtId" => %{"Othr" => %{"Id" => m.cdtr_cpf_cnpj}}}}
                }
              }
              |> maybe_put(
                "StsRsnInf",
                if(m.rsn_prtry, do: %{"Rsn" => %{"Prtry" => m.rsn_prtry}})
              )
          }
        ]
      }
    }
  end

  defp agent_term(ispb), do: %{"FinInstnId" => %{"ClrSysMmbId" => %{"MmbId" => ispb}}}

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "CdtrPmtActvtnReqStsRpt"])
    grp = doc["GrpHdr"]
    [orgnl] = doc["OrgnlPmtInfAndSts"]
    tx = orgnl["TxInfAndSts"]

    %__MODULE__{
      msg_id: grp["MsgId"],
      created_at: parse_datetime(grp["CreDtTm"]),
      orgnl_pmt_inf_id: orgnl["OrgnlPmtInfId"],
      orgnl_end_to_end_id: tx["OrgnlEndToEndId"],
      tx_sts: tx["TxSts"],
      rsn_prtry: get_in(tx, ["StsRsnInf", "Rsn", "Prtry"]),
      dbtr_dcsn_dt_tm: parse_datetime(tx["DbtrDcsnDtTm"]),
      cdtr_agt_ispb: get_in(tx, ["OrgnlTxRef", "CdtrAgt", "FinInstnId", "ClrSysMmbId", "MmbId"]),
      cdtr_cpf_cnpj: get_in(tx, ["OrgnlTxRef", "Cdtr", "Id", "PrvtId", "Othr", "Id"])
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
