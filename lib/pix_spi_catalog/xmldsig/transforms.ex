defmodule PixSpiCatalog.Xmldsig.Transforms do
  @moduledoc """
  Transformação enveloped-signature
  (`http://www.w3.org/2000/09/xmldsig#enveloped-signature`, ADR 0006): tira
  o próprio elemento `Signature` da árvore antes de canonicalizar — tanto o
  `AppHdr` do perfil SPI quanto o elemento raiz do perfil DICT usam essa
  mesma transformação (Manual de Segurança Vol. II, tabelas 3 e 4);
  verificar precisa recomputar o digest sem a assinatura que está sendo
  verificada.
  """

  import PixSpiCatalog.Xmldsig.Xml

  @spec enveloped_signature(tuple()) :: tuple()
  def enveloped_signature(el) do
    content =
      el
      |> xmlElement(:content)
      |> Enum.reject(&signature_element?/1)
      |> Enum.map(&strip_if_element/1)

    xmlElement(el, content: content)
  end

  defp strip_if_element(node) do
    if elem(node, 0) == :xmlElement, do: enveloped_signature(node), else: node
  end

  defp signature_element?(node) do
    elem(node, 0) == :xmlElement and local_name(node) == "Signature"
  end
end
