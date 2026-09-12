defmodule PixSpiCatalog.Camt014 do
  @moduledoc """
  Representação de domínio do camt.014 (consulta de identificação de
  participante — `ReturnMember`), versão 1.6 — lookup num registro
  estático/configurável de participantes: ISPB consultado (`MmbId`) mais
  os dados do participante (`MmbOrErr.Mmb`) e do papel (`PtyRoleIdSD1`).

  Todo campo do schema real é obrigatório — nenhum opcional a tratar.
  `RptOrErr` só resolve a opção `Rpt` no schema compilado hoje (sem `Err`
  no perfil do SPI); se aparecer um exemplo real com `Err`, revisitar.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt014.V1_6

  @type versao :: :v1_6

  defstruct [
    :msg_id,
    :criado_em,
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
          criado_em: DateTime.t(),
          mmb_id_ispb: String.t(),
          mmb_nm: String.t(),
          mmb_rtr_adr: String.t(),
          mmb_tp_cd: String.t(),
          mmb_sts_cd: String.t(),
          full_lgl_nm: String.t(),
          role_plyr_prtry: String.t()
        }

  @campos_obrigatorios [
    :msg_id,
    :criado_em,
    :mmb_id_ispb,
    :mmb_nm,
    :mmb_rtr_adr,
    :mmb_tp_cd,
    :mmb_sts_cd,
    :full_lgl_nm,
    :role_plyr_prtry
  ]

  @modulo_por_versao %{v1_6: V1_6}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_6] do
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

  @doc "Parseia um XML de camt.014 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt014, modulo.msg_def_idr()}}
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
      "RtrMmb" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
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

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "RtrMmb"])
    mmb = get_in(doc, ["RptOrErr", "Rpt", "MmbOrErr", "Mmb"])
    papel = doc["PtyRoleIdSD1"]

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["MsgHdr", "CreDtTm"])),
      mmb_id_ispb: get_in(doc, ["RptOrErr", "Rpt", "MmbId", "ClrSysMmbId", "MmbId"]),
      mmb_nm: mmb["Nm"],
      mmb_rtr_adr: get_in(mmb, ["RtrAdr", "Othr", "Id"]),
      mmb_tp_cd: get_in(mmb, ["Tp", "Cd"]),
      mmb_sts_cd: get_in(mmb, ["Sts", "Cd"]),
      full_lgl_nm: papel["FullLglNm"],
      role_plyr_prtry: get_in(papel, ["RolePlyr", "PtyRole", "Prtry"])
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
