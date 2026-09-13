defmodule Isox.Xmldsig.Verifier do
  @moduledoc """
  Verificação do perfil de assinatura SPI (Manual de Segurança do SFN Vol.
  II §3.3): recalcula os três digests com canonicalização real — os bytes
  vêm de terceiro, então, diferente da assinatura na saída, não dá pra
  confiar que já chegaram canônicos — e confere a assinatura RSA-SHA256
  sobre o `SignedInfo`.

  Assume a ordem fixa de `Reference` do perfil SPI (KeyInfo, AppHdr,
  Document) em vez de resolver por tipo — simplificação razoável para um
  verificador de perfil único, não um XMLDSig genérico.

  `certificate_der` é o certificado que **quem chama já confia** para o
  participante emissor — o manual deixa explícito que cada participante
  mantém sua própria base de números de série e chaves públicas (§3.3,
  nota de rodapé), não que se deva confiar em algo vindo dentro da
  mensagem. O `KeyInfo` da mensagem só aponta (por emissor + número de
  série) qual certificado deveria ter sido usado; esta função confere que
  o certificado dado bate com esse apontamento antes de usar a chave
  pública dele pra verificar a assinatura.
  """

  import Isox.Xmldsig.Xml

  require Record

  Record.defrecord(
    :otp_certificate,
    :OTPCertificate,
    Record.extract(:OTPCertificate, from_lib: "public_key/include/public_key.hrl")
  )

  Record.defrecord(
    :otp_tbs_certificate,
    :OTPTBSCertificate,
    Record.extract(:OTPTBSCertificate, from_lib: "public_key/include/public_key.hrl")
  )

  Record.defrecord(
    :otp_subject_public_key_info,
    :OTPSubjectPublicKeyInfo,
    Record.extract(:OTPSubjectPublicKeyInfo, from_lib: "public_key/include/public_key.hrl")
  )

  alias Isox.Xmldsig.{Canonicalizer, Signer, Transforms}

  @type error ::
          :missing_app_hdr
          | :missing_document
          | :missing_signature
          | :missing_signed_info
          | :missing_key_info
          | :missing_signature_value
          | :wrong_reference_count
          | {:digest_mismatch, non_neg_integer()}
          | :certificate_mismatch
          | :invalid_signature

  @doc """
  Verifica `envelope_xml` (`<Envelope><AppHdr>...<Document>...`) contra o
  certificado esperado (DER). `:ok` ou `{:error, motivo}` — motivo nunca é
  detalhe de exceção interna, só as categorias em `t:error/0`.
  """
  @spec verify(binary(), binary()) :: :ok | {:error, error()}
  def verify(envelope_xml, expected_certificate_der) do
    # Bytes crus, não codepoints — ver Canonicalizer.canonicalize/1.
    {root, _rest} = :xmerl_scan.string(:binary.bin_to_list(envelope_xml), quiet: true)

    with {:ok, app_hdr} <- required(child(root, "AppHdr"), :missing_app_hdr),
         {:ok, document} <- required(child(root, "Document"), :missing_document),
         {:ok, signature} <- required(find_signature(app_hdr), :missing_signature),
         {:ok, signed_info} <- required(child(signature, "SignedInfo"), :missing_signed_info),
         {:ok, key_info} <- required(child(signature, "KeyInfo"), :missing_key_info),
         {:ok, signature_value} <-
           required(signature |> child("SignatureValue") |> text(), :missing_signature_value),
         :ok <- verify_certificate(key_info, expected_certificate_der),
         :ok <- verify_digests(signed_info, app_hdr, document, key_info) do
      verify_signature_value(signed_info, signature_value, expected_certificate_der)
    end
  end

  # `required/2` sempre devolve {:ok, _} ou {:error, _}, nunca o valor cru
  # — misturar `nil` com um átomo de fallback (`valor || :faltando`) não dá
  # pra distinguir "achei" de "não achei" num guard `not is_nil/1`, porque
  # o próprio átomo de fallback também não é nil (bug real, achado testando
  # verificação contra uma mensagem sem assinatura nenhuma).
  defp required(nil, reason), do: {:error, reason}
  defp required(value, _reason), do: {:ok, value}

  defp find_signature(app_hdr) do
    app_hdr |> child("Sgntr") |> child("Signature")
  end

  defp verify_certificate(key_info, expected_certificate_der) do
    x509_issuer_serial = key_info |> child("X509Data") |> child("X509IssuerSerial")
    declared_issuer = x509_issuer_serial |> child("X509IssuerName") |> text()
    declared_serial = x509_issuer_serial |> child("X509SerialNumber") |> text()

    {actual_issuer, actual_serial} = Signer.issuer_and_serial(expected_certificate_der)

    if declared_issuer == actual_issuer and parse_serial(declared_serial) == actual_serial do
      :ok
    else
      {:error, :certificate_mismatch}
    end
  end

  defp parse_serial(nil), do: nil
  defp parse_serial(text), do: String.to_integer(text)

  defp verify_digests(signed_info, app_hdr, document, key_info) do
    references =
      signed_info
      |> xmlElement(:content)
      |> Enum.filter(&(elem(&1, 0) == :xmlElement and local_name(&1) == "Reference"))

    expected_canonical = [
      Canonicalizer.canonicalize_element(key_info),
      app_hdr |> Transforms.enveloped_signature() |> Canonicalizer.canonicalize_element(),
      Canonicalizer.canonicalize_element(document)
    ]

    if length(references) == 3 do
      references
      |> Enum.zip(expected_canonical)
      |> Enum.with_index()
      |> Enum.find_value(:ok, &check_digest/1)
    else
      {:error, :wrong_reference_count}
    end
  end

  defp check_digest({{reference, canonical}, index}) do
    expected_digest = Signer.digest(canonical)
    actual_digest = reference |> child("DigestValue") |> text()

    if actual_digest != expected_digest, do: {:error, {:digest_mismatch, index}}
  end

  defp verify_signature_value(signed_info, signature_value, certificate_der) do
    canonical_signed_info = Canonicalizer.canonicalize_element(signed_info)
    public_key = public_key_from_certificate(certificate_der)

    valid? =
      :public_key.verify(
        canonical_signed_info,
        :sha256,
        Base.decode64!(signature_value),
        public_key
      )

    if valid?, do: :ok, else: {:error, :invalid_signature}
  end

  defp public_key_from_certificate(certificate_der) do
    certificate_der
    |> :public_key.pkix_decode_cert(:otp)
    |> otp_certificate(:tbsCertificate)
    |> otp_tbs_certificate(:subjectPublicKeyInfo)
    |> otp_subject_public_key_info(:subjectPublicKey)
  end
end
