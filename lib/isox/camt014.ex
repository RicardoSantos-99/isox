defmodule Isox.Camt014 do
  @moduledoc """
  Identificação de participante: quem é o dono de um ISPB e em que
  situação ele está.

  Versão 1.6. Serve para consultar o registro de participantes do SPI e
  também para anunciar mudança de situação, já que a mesma mensagem
  carrega `mmb_sts_cd` dizendo se o participante entrou ou saiu.

  Todo campo do schema é obrigatório, então não há opcional a tratar.
  `RptOrErr` resolve só a opção `Rpt` no perfil do SPI, sem `Err`. Se
  aparecer um exemplo oficial com `Err`, é caso de revisitar.

  #{Isox.Dictionary.doc(__MODULE__)}
  """

  alias Isox.AppHdr
  alias Isox.Generated.Camt014.V1_6

  @type version :: :v1_6

  defstruct [
    :msg_id,
    :created_at,
    :mmb_id_ispb,
    :mmb_nm,
    :mmb_rtr_adr,
    :mmb_tp_cd,
    :mmb_sts_cd,
    :full_lgl_nm,
    :role_plyr_prtry
  ]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          mmb_id_ispb: String.t(),
          mmb_nm: String.t(),
          mmb_rtr_adr: String.t(),
          mmb_tp_cd: String.t(),
          mmb_sts_cd: String.t(),
          full_lgl_nm: String.t(),
          role_plyr_prtry: String.t()
        }

  @required_fields [
    :msg_id,
    :created_at,
    :mmb_id_ispb,
    :mmb_nm,
    :mmb_rtr_adr,
    :mmb_tp_cd,
    :mmb_sts_cd,
    :full_lgl_nm,
    :role_plyr_prtry
  ]

  @module_by_version %{v1_6: V1_6}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_6] do
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

  @doc "Decodifica um XML de camt.014 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_camt014, module.msg_def_idr()}}
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
      "RtrMmb" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "RptOrErr" => %{
          "Rpt" => %{
            "MmbId" => %{"ClrSysMmbId" => %{"MmbId" => m.mmb_id_ispb}},
            "MmbOrErr" => %{
              "Mmb" => %{
                "Nm" => m.mmb_nm,
                "RtrAdr" => %{"Othr" => %{"Id" => m.mmb_rtr_adr}},
                "Tp" => %{"Cd" => m.mmb_tp_cd},
                "Sts" => %{"Cd" => m.mmb_sts_cd}
              }
            }
          }
        },
        "PtyRoleIdSD1" => %{
          "FullLglNm" => m.full_lgl_nm,
          "RolePlyr" => %{"PtyRole" => %{"Prtry" => m.role_plyr_prtry}}
        }
      }
    }
  end

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "RtrMmb"])
    mmb = get_in(doc, ["RptOrErr", "Rpt", "MmbOrErr", "Mmb"])
    role = doc["PtyRoleIdSD1"]

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
      mmb_id_ispb: get_in(doc, ["RptOrErr", "Rpt", "MmbId", "ClrSysMmbId", "MmbId"]),
      mmb_nm: mmb["Nm"],
      mmb_rtr_adr: get_in(mmb, ["RtrAdr", "Othr", "Id"]),
      mmb_tp_cd: get_in(mmb, ["Tp", "Cd"]),
      mmb_sts_cd: get_in(mmb, ["Sts", "Cd"]),
      full_lgl_nm: role["FullLglNm"],
      role_plyr_prtry: get_in(role, ["RolePlyr", "PtyRole", "Prtry"])
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
