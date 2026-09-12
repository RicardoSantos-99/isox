defmodule PixSpiCatalog.Camt053 do
  @moduledoc """
  Representação de domínio do camt.053 (saldo/demonstrativo da Conta PI,
  resposta a camt.060), versão 1.4.

  `Stmt` é `max: ilimitado`, simplificado pra exatamente 1 (mesma razão
  do `Camt052`: `camt.060` pede uma conta por vez). Já `Bal` dentro do
  `Stmt` é `max: ilimitado` de verdade — um extrato reporta vários tipos
  de saldo ao mesmo tempo (disponível, bloqueado, remuneração...) — e é
  modelado como lista.

  `CdtDbtInd` (enum de valor único `"CRDT"`) fica fixo.
  """

  alias PixSpiCatalog.AppHdr
  alias PixSpiCatalog.Gerado.Camt053.V1_4

  @type versao :: :v1_4

  defstruct [:msg_id, :criado_em, :stmt_id, :acct_ispb, saldos: []]

  @type saldo :: %{tp_prtry: String.t(), valor: String.t() | number(), dt_tm: DateTime.t()}

  @type t :: %__MODULE__{
          msg_id: String.t(),
          criado_em: DateTime.t(),
          stmt_id: String.t(),
          acct_ispb: String.t(),
          saldos: [saldo()]
        }

  @campos_obrigatorios [:msg_id, :criado_em, :stmt_id, :acct_ispb]

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

  @doc "Parseia um XML de camt.053 de volta para a struct."
  @spec parse(binary()) :: {:ok, t(), versao()} | {:error, term()}
  def parse(xml) when is_binary(xml) do
    case PixSpiCatalog.Registro.parse(xml) do
      {:ok, modulo, termo} ->
        case Map.fetch(@versao_por_modulo, modulo) do
          {:ok, versao} -> {:ok, struct_de_termo(termo), versao}
          :error -> {:error, {:nao_e_camt053, modulo.msg_def_idr()}}
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
      "BkToCstmrStmt" => %{
        "GrpHdr" => %{"MsgId" => m.msg_id, "CreDtTm" => formatar_data_hora(m.criado_em)},
        "Stmt" => [
          %{
            "Id" => m.stmt_id,
            "Acct" => %{"Id" => %{"Othr" => %{"Id" => m.acct_ispb}}},
            "Bal" => Enum.map(m.saldos, &termo_saldo/1)
          }
        ]
      }
    }
  end

  defp termo_saldo(s) do
    %{
      "Tp" => %{"CdOrPrtry" => %{"Prtry" => s.tp_prtry}},
      "Amt" => %{valor: to_string(s.valor), atributos: %{"Ccy" => "BRL"}},
      "CdtDbtInd" => "CRDT",
      "Dt" => %{"DtTm" => formatar_data_hora(s.dt_tm)}
    }
  end

  defp struct_de_termo(termo) do
    doc = get_in(termo, ["Document", "BkToCstmrStmt"])
    [stmt] = doc["Stmt"]

    %__MODULE__{
      msg_id: get_in(doc, ["GrpHdr", "MsgId"]),
      criado_em: parse_data_hora(get_in(doc, ["GrpHdr", "CreDtTm"])),
      stmt_id: stmt["Id"],
      acct_ispb: get_in(stmt, ["Acct", "Id", "Othr", "Id"]),
      saldos: stmt |> Map.get("Bal", []) |> Enum.map(&saldo_de_termo/1)
    }
  end

  defp saldo_de_termo(t) do
    %{
      tp_prtry: get_in(t, ["Tp", "CdOrPrtry", "Prtry"]),
      valor: get_in(t, ["Amt", :valor]),
      dt_tm: get_in(t, ["Dt", "DtTm"]) |> parse_data_hora()
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
