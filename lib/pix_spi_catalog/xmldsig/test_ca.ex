defmodule PixSpiCatalog.Xmldsig.TestCA do
  @moduledoc """
  Gera, em memória, um par de chave privada + certificado autoassinado
  RSA-2048, para uso em testes e exemplos de `PixSpiCatalog.Xmldsig.Signer`
  e `PixSpiCatalog.Xmldsig.Verifier`.

  **Nunca use em produção.** Nada aqui é persistido: cada chamada gera um
  par novo, descartado ao final do processo. Um serviço real precisa de
  uma cadeia de certificados emitida por uma CA de verdade (ou pela ICP
  interna do participante), com rotação e armazenamento próprios — fora
  do escopo desta biblioteca.
  """

  @type ca :: %{private_key_der: binary(), certificate_der: binary()}

  @doc """
  Gera uma CA de teste mínima: par de chaves RSA-2048 e um certificado
  autoassinado sobre ele, ambos em DER.
  """
  @spec generate() :: ca()
  def generate do
    private_key = :public_key.generate_key({:rsa, 2048, 65_537})
    # ~c"Teste", não "Teste" — :public_key espera string() erlang (charlist),
    # não um binary Elixir; achado pelo dialyzer (invalid_contract).
    %{cert: certificate_der} = :public_key.pkix_test_root_cert(~c"Teste", key: private_key)

    %{
      private_key_der: :public_key.der_encode(:RSAPrivateKey, private_key),
      certificate_der: certificate_der
    }
  end
end
