defmodule Isox.Reda022 do
  @moduledoc """
  Modelo ISO 20022 do reda.022 (solicitação de alteração de
  cadastro de participante), versão 1.4 — a mensagem cujo schema real
  exigiu corrigir o `Compiler` (ver ADR/issue #27): `ReqdMod` é um
  `xs:choice` entre `CtctDtls` (ela mesma outra escolha, entre os grupos
  `ReqdModContato` e `ReqdModDiretor`, que compartilham a maioria das
  tags — só `Nm` distingue), `TechAdr` e `MktSpcfcAttr`.

  `Mod` é `[4..4]` no schema real (exatamente 4, não `ilimitado`) —
  sempre as 4 modificações juntas, uma de cada tipo (`:contact`,
  `:director`, `:tech_adr`, `:mkt_spcfc_attr`), nunca um subconjunto.
  Modelado como lista de mapas com `:type` dizendo qual variante de
  `ReqdMod` é. `ScpIndctn` (enum de valor único `"INSE"`) e
  `MktSpcfcAttr.Nm` (enum de valor único `"CPFDIRETOR"`) ficam fixos.
  `Rspnsblty` também é fixo por tipo (`"CONTATOPSP"` em `:contact`,
  `"DIRETORPSP"` em `:director`) — o schema só garante que é um dos 2
  valores do enum, não que é o valor certo pro ramo; `encode/3` valida
  isso, junto com a composição exata de `mod` (4 itens, um de cada
  tipo).
  """

  alias Isox.AppHdr
  alias Isox.Generated.Reda022.V1_4

  @type version :: :v1_4

  @type modification ::
          %{
            type: :contact,
            phne_nb: String.t(),
            mob_nb: String.t() | nil,
            fax_nb: String.t() | nil,
            email_adr: String.t(),
            rspnsblty: String.t()
          }
          | %{
              type: :director,
              nm: String.t(),
              phne_nb: String.t(),
              mob_nb: String.t() | nil,
              email_adr: String.t(),
              rspnsblty: String.t()
            }
          | %{type: :tech_adr, tech_adr: String.t()}
          | %{type: :mkt_spcfc_attr, val: String.t()}

  defstruct [:msg_id, :created_at, :ispb, mod: []]

  @type t :: %__MODULE__{
          msg_id: String.t(),
          created_at: DateTime.t(),
          ispb: String.t(),
          mod: [modification()]
        }

  @required_fields [:msg_id, :created_at, :ispb]

  @module_by_version %{v1_4: V1_4}
  @version_by_module Map.new(@module_by_version, fn {v, m} -> {m, v} end)

  @doc "Monta o XML (envelope completo, `AppHdr` + `Document`) para a versão dada."
  @spec encode(t(), AppHdr.t(), version()) :: {:ok, binary()} | {:error, String.t()}
  def encode(%__MODULE__{} = message, %AppHdr{} = header, version) when version in [:v1_4] do
    with :ok <- validate_required(message),
         :ok <- validate_mod(message.mod) do
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

  @doc "Decodifica um XML de reda.022 de volta para a struct."
  @spec decode(binary()) :: {:ok, t(), version()} | {:error, term()}
  def decode(xml) when is_binary(xml) do
    case Isox.Registry.decode(xml) do
      {:ok, module, term} ->
        case Map.fetch(@version_by_module, module) do
          {:ok, version} -> {:ok, struct_from_term(term), version}
          :error -> {:error, {:not_reda022, module.msg_def_idr()}}
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

  @mod_types [:contact, :director, :tech_adr, :mkt_spcfc_attr]

  defp validate_mod(mod) do
    types = Enum.map(mod, & &1.type)

    cond do
      length(mod) != 4 ->
        {:error,
         "mod: esperado exatamente 4 modificações (uma de cada tipo), vieram #{length(mod)}"}

      Enum.sort(types) != Enum.sort(@mod_types) ->
        {:error,
         "mod: esperado exatamente uma modificação de cada tipo #{inspect(@mod_types)}, vieram #{inspect(types)}"}

      true ->
        validate_all_rspnsblty(mod)
    end
  end

  defp validate_all_rspnsblty(mod) do
    Enum.reduce_while(mod, :ok, fn m, :ok ->
      case validate_rspnsblty(m) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_rspnsblty(%{type: :contact, rspnsblty: "CONTATOPSP"}), do: :ok

  defp validate_rspnsblty(%{type: :contact, rspnsblty: rspnsblty}) do
    {:error,
     "rspnsblty deve ser \"CONTATOPSP\" quando type: :contact, veio #{inspect(rspnsblty)}"}
  end

  defp validate_rspnsblty(%{type: :director, rspnsblty: "DIRETORPSP"}), do: :ok

  defp validate_rspnsblty(%{type: :director, rspnsblty: rspnsblty}) do
    {:error,
     "rspnsblty deve ser \"DIRETORPSP\" quando type: :director, veio #{inspect(rspnsblty)}"}
  end

  defp validate_rspnsblty(_m), do: :ok

  defp document_term(m) do
    %{
      "PtyModReq" => %{
        "MsgHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => format_datetime(m.created_at)},
        "SysPtyId" => %{"Id" => %{"Id" => %{"PrtryId" => %{"Id" => m.ispb, "Issr" => "BCB"}}}},
        "Mod" => Enum.map(m.mod, &mod_term/1)
      }
    }
  end

  defp mod_term(m), do: %{"ScpIndctn" => "INSE", "ReqdMod" => reqd_mod_term(m)}

  defp reqd_mod_term(%{type: :contact} = m) do
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

  defp reqd_mod_term(%{type: :director} = m) do
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

  defp reqd_mod_term(%{type: :tech_adr} = m), do: %{"TechAdr" => %{"TechAdr" => m.tech_adr}}

  defp reqd_mod_term(%{type: :mkt_spcfc_attr} = m),
    do: %{"MktSpcfcAttr" => %{"Nm" => "CPFDIRETOR", "Val" => m.val}}

  defp struct_from_term(term) do
    doc = get_in(term, ["Document", "PtyModReq"])

    %__MODULE__{
      msg_id: get_in(doc, ["MsgHdr", "MsgId"]),
      created_at: parse_datetime(get_in(doc, ["MsgHdr", "CreDtTm"])),
      ispb: get_in(doc, ["SysPtyId", "Id", "Id", "PrtryId", "Id"]),
      mod: doc |> Map.get("Mod", []) |> Enum.map(&modification_from_term/1)
    }
  end

  defp modification_from_term(t) do
    reqd = t["ReqdMod"]

    cond do
      ctct = reqd["CtctDtls"] -> contact_from_term(ctct)
      tech = reqd["TechAdr"] -> %{type: :tech_adr, tech_adr: tech["TechAdr"]}
      attr = reqd["MktSpcfcAttr"] -> %{type: :mkt_spcfc_attr, val: attr["Val"]}
    end
  end

  defp contact_from_term(%{"Nm" => nm} = ctct) when nm != nil do
    %{
      type: :director,
      nm: nm,
      phne_nb: ctct["PhneNb"],
      mob_nb: ctct["MobNb"],
      email_adr: ctct["EmailAdr"],
      rspnsblty: ctct["Rspnsblty"]
    }
  end

  defp contact_from_term(ctct) do
    %{
      type: :contact,
      phne_nb: ctct["PhneNb"],
      mob_nb: ctct["MobNb"],
      fax_nb: ctct["FaxNb"],
      email_adr: ctct["EmailAdr"],
      rspnsblty: ctct["Rspnsblty"]
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
