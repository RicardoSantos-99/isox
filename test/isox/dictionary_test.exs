defmodule Isox.DictionaryTest do
  @moduledoc """
  O dicionário só vale se estiver completo e casado com as structs. Campo
  que existe na struct e não no dicionário some da tabela sem ninguém
  notar; campo que existe só no dicionário descreve algo que não existe
  mais.
  """

  use ExUnit.Case, async: true

  doctest Isox.Dictionary

  alias Isox.Dictionary
  alias Isox.Dictionary.Entry

  defp struct_fields(message) do
    message.__struct__() |> Map.from_struct() |> Map.keys() |> MapSet.new()
  end

  defp top_level(message) do
    message
    |> Dictionary.fields()
    |> Enum.filter(&is_nil(&1.within))
    |> Enum.map(& &1.field)
    |> MapSet.new()
  end

  describe "cobertura" do
    test "toda mensagem listada tem dicionário" do
      sem_dicionario = Enum.filter(Dictionary.messages(), &(Dictionary.fields(&1) == []))

      assert sem_dicionario == []
    end

    test "todo campo de struct tem entrada, e toda entrada tem campo" do
      for message <- Dictionary.messages() do
        campos = struct_fields(message)
        entradas = top_level(message)

        assert MapSet.difference(campos, entradas) |> MapSet.to_list() == [],
               "#{inspect(message)}: campo sem entrada no dicionário"

        assert MapSet.difference(entradas, campos) |> MapSet.to_list() == [],
               "#{inspect(message)}: entrada que não corresponde a campo nenhum"
      end
    end

    test "campo aninhado aponta para um campo que existe" do
      for message <- Dictionary.messages(),
          %Entry{within: parent, field: field} <- Dictionary.fields(message),
          not is_nil(parent) do
        assert MapSet.member?(struct_fields(message), parent),
               "#{inspect(message)}.#{field} diz morar em #{parent}, que não existe"
      end
    end
  end

  describe "forma das entradas" do
    test "toda entrada diz o que o campo é" do
      for message <- Dictionary.messages(), entry <- Dictionary.fields(message) do
        assert is_binary(entry.what) and entry.what != "",
               "#{inspect(message)}.#{entry.field} sem descrição"

        assert String.ends_with?(entry.what, "."),
               "#{inspect(message)}.#{entry.field}: descrição sem ponto final"
      end
    end

    test "só campo de domínio lista valores" do
      for message <- Dictionary.messages(),
          %Entry{codes: codes, type: type, field: field} <- Dictionary.fields(message),
          is_map(codes) do
        assert type == :code, "#{inspect(message)}.#{field} lista valores mas não é :code"
        refute codes == %{}
      end
    end

    test "caminho XML não fica vazio" do
      for message <- Dictionary.messages(), entry <- Dictionary.fields(message) do
        assert is_binary(entry.xml) and entry.xml != ""
      end
    end
  end

  describe "consulta" do
    test "field/2 acha pelo nome do campo" do
      assert {:ok, entry} = Dictionary.field(Isox.Pacs008, :end_to_end_id)
      assert entry.name_br == "idFimAFim"
    end

    test "field/2 devolve :error para campo que não existe" do
      assert Dictionary.field(Isox.Pacs008, :nao_existe) == :error
    end

    test "codes/2 só responde para campo de domínio" do
      assert {:ok, %{"IPAY" => _}} = Dictionary.codes(Isox.Pacs008, :purp_cd)
      assert Dictionary.codes(Isox.Pacs008, :dbtr_name) == :error
    end

    test "search/1 ignora acento e caixa" do
      com_acento = Dictionary.search("transação")
      sem_acento = Dictionary.search("TRANSACAO")

      refute com_acento == []
      assert com_acento == sem_acento
    end

    test "search/1 exige todos os termos" do
      assert Dictionary.search("chave pix conta") != []
      assert Dictionary.search("chave pix jabuticaba") == []
    end

    test "explain/2 avisa quando o campo não existe" do
      assert Dictionary.explain(Isox.Pacs008, :nao_existe) =~ "não tem campo"
    end

    test "explain/2 de campo com lista mostra o que vai dentro" do
      texto = Dictionary.explain(Isox.Camt053, :balances)

      assert texto =~ "Cada item traz"
    end
  end

  describe "doc/1" do
    test "monta a tabela que entra no moduledoc" do
      doc = Dictionary.doc(Isox.Pacs008)

      assert doc =~ "## Campos"
      assert doc =~ "| `dbtr_acct_id` |"
      assert doc =~ "`contaUsuarioPagador`"
    end

    test "lista os domínios quando a mensagem tem campo de código" do
      assert Dictionary.doc(Isox.Pacs008) =~ "## Domínios"
    end

    test "mensagem sem campo de domínio não ganha seção vazia" do
      refute Dictionary.doc(Isox.Pibr001) =~ "## Domínios"
    end
  end
end
