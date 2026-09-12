defmodule PixSpiCatalog.XmldsigTestCA do
  @moduledoc """
  CA de teste local mínima, só para os testes do XMLDSig (issue #34 monta
  a versão completa, com CERTPIA/CERTPIC separados). Gera um par de chaves
  RSA e um certificado autoassinado sobre ele.
  """

  @spec generate() :: %{private_key_der: binary(), certificate_der: binary()}
  def generate do
    private_key = :public_key.generate_key({:rsa, 2048, 65_537})
    %{cert: certificate_der} = :public_key.pkix_test_root_cert("Teste Pix", key: private_key)

    %{
      private_key_der: :public_key.der_encode(:RSAPrivateKey, private_key),
      certificate_der: certificate_der
    }
  end
end
