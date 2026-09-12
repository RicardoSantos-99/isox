defmodule PixSpiCatalog.Reda022 do
  @moduledoc """
  Representação de domínio do reda.022 (solicitação de alteração de
  cadastro de participante), versão 1.4 — a mensagem cujo schema real
  exigiu corrigir o `Compilador` (ver ADR/issue #27): `ReqdMod` é um
  `xs:choice` entre `CtctDtls` (ela mesma outra escolha, entre os grupos
  `ReqdModContato` e `ReqdModDiretor`, que compartilham a maioria das
  tags — só `Nm` distingue), `TechAdr` e `MktSpcfcAttr`.

  `Mod` é `max: ilimitado` de verdade — uma mensagem pode carregar várias
  alterações de uma vez — modelado como lista de mapas com `:tipo`
  (`:contato`, `:diretor`, `:tech_adr` ou `:mkt_spcfc_attr`) dizendo qual
  variante de `ReqdMod` é. `ScpIndctn` (enum de valor único `"INSE"`) e
  `MktSpcfcAttr.Nm` (enum de valor único `"CPFDIRETOR"`) ficam fixos.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Reda022.V1_4

  @type versao :: :v1_4

  @type modificacao ::
          %{
            tipo: :contato,
            phne_nb: String.t(),
            mob_nb: String.t() | nil,
            fax_nb: String.t() | nil,
            email_adr: String.t(),
            rspnsblty: String.t()
          }
          | %{
              tipo: :diretor,
              nm: String.t(),
              phne_nb: String.t(),
              mob_nb: String.t() | nil,
              email_adr: String.t(),
              rspnsblty: String.t()
            }
          | %{tipo: :tech_adr, tech_adr: String.t()}
          | %{tipo: :mkt_spcfc_attr, val: String.t()}

  defstruct [:msg_id, :criado_em, :ispb, mod: []]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          ispb: String.t(),
          mod: [modificacao()]
        }

  @campos_obrigatorios [:msg_id, :criado_em, :ispb]

  @modulo_por_versao %{v1_4: V1_4}
  @versao_por_modulo Map.new(@modulo_por_versao, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec build(t(), AppHdr.t(), versao()) :: {:ok, binary()} | {:error, String.t()}
  def build(%__MODULE__{} = mensagem, %AppHdr{} = cabecalho, versao) when versao in [:v1_4] do
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

  @doc "Parseia um XML de reda.022 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_reda022, modulo.msg_def_idr()}}
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
      "PtyModReq" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "SysPtyId" => %{"Id" => %{"Id" => %{"PrtryId" => %{"Id" => m.ispb, "Issr" => "BCB"}}}},
        "Mod" => Enum.map(m.mod, &termo_mod/1)
      }
    }
  end

  defp termo_mod(m), do: %{"ScpIndctn" => "INSE", "ReqdMod" => termo_reqd_mod(m)}

  defp termo_reqd_mod(%{tipo: :contato} = m) do
    %{
      "CtctDtls" => %{
        "PhneNb" => m.phne_nb,
        "MobNb" => m[:mob_nb],
        "FaxNb" => m[:fax_nb],
        "EmailAdr" => m.email_adr,
        "Rspnsblty" => m.rspnsblty
      }
    }
  end

  defp termo_reqd_mod(%{tipo: :diretor} = m) do
    %{
      "CtctDtls" => %{
        "Nm" => m.nm,
        "PhneNb" => m.phne_nb,
        "MobNb" => m[:mob_nb],
        "EmailAdr" => m.email_adr,
        "Rspnsblty" => m.rspnsblty
      }
    }
  end

  defp termo_reqd_mod(%{tipo: :tech_adr} = m), do: %{"TechAdr" => %{"TechAdr" => m.tech_adr}}

  defp termo_reqd_mod(%{tipo: :mkt_spcfc_attr} = m),
    do: %{"MktSpcfcAttr" => %{"Nm" => "CPFDIRETOR", "Val" => m.val}}

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "PtyModReq"])

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["MsgHdr", "CreDtTm"])),
      ispb: get_in(doc, ["SysPtyId", "Id", "Id", "PrtryId", "Id"]),
      mod: doc |> Map.get("Mod", []) |> Enum.map(&modificacao_de_termo/1)
    }
  end

  defp modificacao_de_termo(t) do
    reqd = t["ReqdMod"]

    cond do
      ctct = reqd["CtctDtls"] -> ctct_de_termo(ctct)
      tech = reqd["TechAdr"] -> %{tipo: :tech_adr, tech_adr: tech["TechAdr"]}
      attr = reqd["MktSpcfcAttr"] -> %{tipo: :mkt_spcfc_attr, val: attr["Val"]}
    end
  end

  defp ctct_de_termo(%{"Nm" => nm} = ctct) when nm != nil do
    %{
      tipo: :diretor,
      nm: nm,
      phne_nb: ctct["PhneNb"],
      mob_nb: ctct["MobNb"],
      email_adr: ctct["EmailAdr"],
      rspnsblty: ctct["Rspnsblty"]
    }
  end

  defp ctct_de_termo(ctct) do
    %{
      tipo: :contato,
      phne_nb: ctct["PhneNb"],
      mob_nb: ctct["MobNb"],
      fax_nb: ctct["FaxNb"],
      email_adr: ctct["EmailAdr"],
      rspnsblty: ctct["Rspnsblty"]
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
