defmodule PixSpiCatalog.Xmldsig.Xml do
  @moduledoc false

  require Record

  Record.defrecord(:xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl"))

  Record.defrecord(
    :xmlAttribute,
    Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  )

  Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  Record.defrecord(
    :xmlNamespace,
    Record.extract(:xmlNamespace, from_lib: "xmerl/include/xmerl.hrl")
  )

  @doc "Nome local do elemento, sem prefixo (`ds:SignedInfo` -> `\"SignedInfo\"`)."
  @spec local_name(tuple()) :: String.t()
  def local_name(el) do
    case xmlElement(el, :nsinfo) do
      [] -> to_string(xmlElement(el, :name))
      {_prefix, local} -> to_string(local)
    end
  end

  @doc "Primeiro filho direto do elemento com o nome local dado, ou `nil`."
  @spec child(tuple() | nil, String.t()) :: tuple() | nil
  def child(nil, _name), do: nil

  def child(el, name) do
    el
    |> xmlElement(:content)
    |> Enum.find(fn
      node -> elem(node, 0) == :xmlElement and local_name(node) == name
    end)
  end

  @doc "Texto concatenado dos filhos diretos de texto do elemento."
  @spec text(tuple() | nil) :: String.t() | nil
  def text(nil), do: nil

  def text(el) do
    el
    |> xmlElement(:content)
    |> Enum.filter(&(elem(&1, 0) == :xmlText))
    |> Enum.map_join("", &to_string(xmlText(&1, :value)))
  end

  @doc "Valor do atributo com o nome local dado (sem prefixo), ou `nil`."
  @spec attr(tuple(), String.t()) :: String.t() | nil
  def attr(el, name) do
    el
    |> xmlElement(:attributes)
    |> Enum.find_value(fn attr ->
      attr_name =
        case xmlAttribute(attr, :nsinfo) do
          {_prefix, local} -> to_string(local)
          [] -> to_string(xmlAttribute(attr, :name))
        end

      if attr_name == name, do: to_string(xmlAttribute(attr, :value))
    end)
  end
end
