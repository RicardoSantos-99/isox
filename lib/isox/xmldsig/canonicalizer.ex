defmodule Isox.Xmldsig.Canonicalizer do
  # Canonicalização XML exclusiva (http://www.w3.org/2001/10/xml-exc-c14n#,
  # ADR 0006), só o suficiente para o que o catálogo do SPI realmente usa:
  # sem comentários, sem instruções de processamento, sem xml:lang/
  # xml:space, sem lista de prefixos inclusivos (InclusiveNamespaces).
  #
  # Um nó de namespace só é declarado num elemento se for visivelmente
  # utilizado ali (pelo próprio elemento ou por um atributo seu) e ainda não
  # tiver sido renderizado por um ancestral na árvore de saída, não
  # necessariamente onde a declaração vivia no XML de origem. É essa regra,
  # não a localização original da declaração, que a torna "exclusiva".
  #
  # Usado internamente por Signer/Verifier. Não é API pública da lib.
  @moduledoc false

  import Isox.Xmldsig.Xml

  @doc "Decodifica e canonicaliza um XML completo, a partir do elemento raiz."
  @spec canonicalize(binary()) :: binary()
  def canonicalize(xml) when is_binary(xml) do
    # Lista de bytes crus, não de codepoints (String.to_charlist/1): o
    # XML declara encoding="UTF-8" e é o próprio xmerl quem decodifica a
    # partir disso; dar codepoint já decodificado confunde o parser diante
    # de qualquer caractere fora do ASCII (mesmo bug do Codec genérico).
    {root, _rest} = :xmerl_scan.string(:binary.bin_to_list(xml), quiet: true)
    canonicalize_element(root)
  end

  @doc """
  Canonicaliza um elemento já parseado (`:xmlElement`), com o namespace já
  renderizado por ancestrais fora desta chamada (mapa prefixo/`:default` =>
  URI). Usado para canonicalizar sub-árvores, por exemplo o `AppHdr` sem o
  próprio `<Signature>`, para a referência com transformação
  enveloped-signature.
  """
  @spec canonicalize_element(tuple(), %{optional(:default | String.t()) => String.t()}) ::
          binary()
  def canonicalize_element(el, rendered \\ %{}) do
    ns = xmlElement(el, :namespace)
    element_namespace = element_ns(el, ns)

    content_attrs = Enum.reject(xmlElement(el, :attributes), &namespace_declaration?/1)

    attr_namespaces =
      content_attrs
      |> Enum.map(&attribute_ns(&1, ns))
      |> Enum.reject(&is_nil/1)

    needed =
      [element_namespace | attr_namespaces]
      |> Enum.reject(fn
        {_prefix, nil} -> true
        {prefix, uri} -> Map.get(rendered, ns_key(prefix)) == uri
      end)
      |> Enum.uniq()

    new_rendered =
      Enum.reduce(needed, rendered, fn {prefix, uri}, acc -> Map.put(acc, ns_key(prefix), uri) end)

    tag = element_tag(el)

    # Nós de namespace sempre vêm antes dos atributos comuns, como um
    # grupo à parte: não é um único sort por (uri, nome) misturando os
    # dois, senão um atributo sem namespace (uri "") poderia intercalar
    # com as declarações de namespace (que também "não têm uri" pra fim
    # de ordenação), o que a spec não permite.
    ns_decls =
      needed
      |> Enum.sort_by(fn {prefix, _uri} -> prefix || "" end)
      |> Enum.map_join("", fn {prefix, uri} -> " " <> ns_decl(prefix, uri) end)

    regular_attrs =
      content_attrs
      |> Enum.map(&regular_attr(&1, ns))
      |> Enum.sort_by(fn {uri, local, _rendered} -> {uri || "", local} end)
      |> Enum.map_join("", fn {_uri, _local, rendered} -> " " <> rendered end)

    rendered_attrs = ns_decls <> regular_attrs

    inner =
      el
      |> xmlElement(:content)
      |> Enum.map_join("", &canonicalize_node(&1, new_rendered))

    "<#{tag}#{rendered_attrs}>#{inner}</#{tag}>"
  end

  defp canonicalize_node(node, rendered) do
    case elem(node, 0) do
      :xmlElement -> canonicalize_element(node, rendered)
      :xmlText -> node |> xmlText(:value) |> escape_text()
      _ -> ""
    end
  end

  defp element_tag(el) do
    case xmlElement(el, :nsinfo) do
      [] -> to_string(xmlElement(el, :name))
      {prefix, local} -> "#{prefix}:#{local}"
    end
  end

  # {prefix_or_nil, uri_or_nil}, onde uri nil significa "sem namespace", que
  # nunca gera declaração.
  defp element_ns(el, ns) do
    case xmlElement(el, :nsinfo) do
      [] ->
        case xmlNamespace(ns, :default) do
          [] -> {nil, nil}
          uri -> {nil, to_string(uri)}
        end

      {prefix, _local} ->
        {to_string(prefix), lookup_prefix(ns, prefix)}
    end
  end

  # Atributo sem prefixo nunca está em namespace nenhum, mesmo com
  # namespace padrão em vigor (regra da spec de XML Namespaces).
  defp attribute_ns(attr, owning_namespace) do
    case xmlAttribute(attr, :nsinfo) do
      {prefix, _local} -> {to_string(prefix), lookup_prefix(owning_namespace, prefix)}
      [] -> nil
    end
  end

  defp lookup_prefix(ns, prefix) do
    ns
    |> xmlNamespace(:nodes)
    |> Enum.find_value(fn {p, uri} -> if p == prefix, do: to_string(uri) end)
  end

  defp namespace_declaration?(attr) do
    xmlAttribute(attr, :name) == :xmlns or match?({~c"xmlns", _}, xmlAttribute(attr, :nsinfo))
  end

  defp ns_key(nil), do: :default
  defp ns_key(prefix), do: prefix

  defp ns_decl(nil, uri), do: ~s(xmlns="#{escape_attr(uri)}")
  defp ns_decl(prefix, uri), do: ~s(xmlns:#{prefix}="#{escape_attr(uri)}")

  defp regular_attr(attr, owning_namespace) do
    {name, uri} =
      case xmlAttribute(attr, :nsinfo) do
        {prefix, local} -> {"#{prefix}:#{local}", lookup_prefix(owning_namespace, prefix)}
        [] -> {to_string(xmlAttribute(attr, :name)), nil}
      end

    value = attr |> xmlAttribute(:value) |> escape_attr()
    local_for_sort = name |> String.split(":") |> List.last()

    {uri, local_for_sort, ~s(#{name}="#{value}")}
  end

  defp escape_text(value) do
    value
    |> to_string()
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\r", "&#xD;")
  end

  defp escape_attr(value) do
    value
    |> to_string()
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("\t", "&#x9;")
    |> String.replace("\n", "&#xA;")
    |> String.replace("\r", "&#xD;")
  end
end
