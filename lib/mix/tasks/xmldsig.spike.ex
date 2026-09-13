defmodule Mix.Tasks.Xmldsig.Spike do
  @shortdoc "Mede o throughput de assinar/verificar uma pacs.008"

  @moduledoc """
  Mede o throughput de assinar e verificar uma pacs.008 realista, sem
  servidor HTTP no caminho:

    1. montar e assinar uma pacs.008 pelo caminho de template canônico
       (sem canonicalização no caminho quente — ver `Isox.Xmldsig.Signer`)
    2. parsear e verificar a assinatura de uma pacs.008 de entrada, com
       canonicalização real (não dá pra confiar que os bytes de terceiro
       já chegam canônicos)
    3. canonicalização isolada (o trecho caro e bem delimitado, candidato
       a NIF/Rustler caso o throughput medido não seja suficiente)

  Throughput por core: mede sequencial num processo só, sem paralelizar —
  o número é o que um core sustenta; multiplicar por cores disponíveis dá
  uma estimativa grosseira do total. **Não fixa meta**: o número aceitável
  depende de onde e como esta lib for usada — cabe a quem integra decidir
  isso com os números medidos na mão, não a esta biblioteca presumir.
  """

  use Mix.Task

  alias Isox.Xmldsig.{Canonicalizer, Signer, Verifier}
  alias Isox.Xmldsig.TestCA

  @impl Mix.Task
  def run(_args) do
    %{private_key_der: private_key_der, certificate_der: certificate_der} =
      TestCA.generate()

    app_hdr = app_hdr_xml()
    document = document_xml()

    signature_xml = Signer.sign(app_hdr, document, private_key_der, certificate_der)
    envelope = assemble_envelope(app_hdr, document, signature_xml)

    unless Verifier.verify(envelope, certificate_der) == :ok do
      Mix.raise("fixture do spike não verifica — não vale medir throughput sobre ela")
    end

    Mix.shell().info("Fixture: #{byte_size(envelope)} bytes (AppHdr + Document + Signature)\n")

    measure("canonicalizar o Document isolado", 3, fn -> Canonicalizer.canonicalize(document) end)

    measure("assinar (caminho de template, sem c14n no caminho quente)", 3, fn ->
      Signer.sign(app_hdr, document, private_key_der, certificate_der)
    end)

    measure("verificar (com canonicalização real)", 3, fn ->
      Verifier.verify(envelope, certificate_der)
    end)
  end

  defp measure(label, seconds, fun) do
    {count, elapsed_us} = run_for(seconds, fun)
    per_second = count / (elapsed_us / 1_000_000)

    Mix.shell().info(
      "#{pad(label)} #{Float.round(per_second, 1)} op/s" <>
        "  (#{count} execuções em #{Float.round(elapsed_us / 1_000_000, 2)}s)"
    )
  end

  defp pad(label), do: String.pad_trailing(label, 55)

  defp run_for(seconds, fun) do
    deadline = System.monotonic_time(:microsecond) + seconds * 1_000_000
    {us, count} = :timer.tc(fn -> loop_until(deadline, fun, 0) end)
    {count, us}
  end

  defp loop_until(deadline, fun, count) do
    fun.()

    if System.monotonic_time(:microsecond) >= deadline do
      count + 1
    else
      loop_until(deadline, fun, count + 1)
    end
  end

  defp app_hdr_xml do
    ~s(<AppHdr xmlns="urn:pix:head.001">) <>
      ~s(<Fr>11111111</Fr><To>22222222</To>) <>
      ~s(<BizMsgIdr>M111111112026091210300abcdefghij</BizMsgIdr>) <>
      ~s(<MsgDefIdr>pacs.008.spi.1.16</MsgDefIdr>) <>
      ~s(<CreDt>2026-09-12T14:30:00.000Z</CreDt>) <>
      ~s(<Sgntr></Sgntr>) <>
      ~s(</AppHdr>)
  end

  # Escrito à mão em vez de vir de Isox.Pacs008.encode/3 só pra
  # manter este spike simples e autocontido; tamanho e profundidade
  # realistas de uma pacs.008 de verdade é o que importa pra medir custo
  # de canonicalização/assinatura, não o conteúdo exato dos campos.
  defp document_xml do
    ~s(<Document xmlns="urn:pix:pacs.008.spi.1.16">) <>
      ~s(<FIToFICstmrCdtTrf>) <>
      ~s(<GrpHdr>) <>
      ~s(<MsgId>M111111112026091210300abcdefghij</MsgId>) <>
      ~s(<CreDtTm>2026-09-12T14:30:00.000Z</CreDtTm>) <>
      ~s(<NbOfTxs>1</NbOfTxs>) <>
      ~s(<SttlmInf><SttlmMtd>CLRG</SttlmMtd></SttlmInf>) <>
      ~s(<PmtTpInf><InstrPrty>NORM</InstrPrty><SvcLvl><Prtry>PAGPRI</Prtry></SvcLvl></PmtTpInf>) <>
      ~s(</GrpHdr>) <>
      ~s(<CdtTrfTxInf>) <>
      ~s(<PmtId><EndToEndId>E111111112026091210300abcdefghij</EndToEndId></PmtId>) <>
      ~s(<IntrBkSttlmAmt Ccy="BRL">150.00</IntrBkSttlmAmt>) <>
      ~s(<AccptncDtTm>2026-09-12T14:30:00.000Z</AccptncDtTm>) <>
      ~s(<ChrgBr>SLEV</ChrgBr>) <>
      ~s(<MndtRltdInf><Tp><LclInstrm><Prtry>MANU</Prtry></LclInstrm></Tp></MndtRltdInf>) <>
      ~s(<Dbtr><Nm>Fulano de Tal</Nm><Id><PrvtId><Othr><Id>12345678901</Id></Othr></PrvtId></Id></Dbtr>) <>
      ~s(<DbtrAcct><Id><Othr><Id>00012345</Id></Othr></Id><Tp><Cd>CACC</Cd></Tp></DbtrAcct>) <>
      ~s(<DbtrAgt><FinInstnId><ClrSysMmbId><MmbId>11111111</MmbId></ClrSysMmbId></FinInstnId></DbtrAgt>) <>
      ~s(<CdtrAgt><FinInstnId><ClrSysMmbId><MmbId>22222222</MmbId></ClrSysMmbId></FinInstnId></CdtrAgt>) <>
      ~s(<Cdtr><Id><PrvtId><Othr><Id>12345678000199</Id></Othr></PrvtId></Id></Cdtr>) <>
      ~s(<CdtrAcct><Id><Othr><Id>00098765</Id></Othr></Id><Tp><Cd>CACC</Cd></Tp></CdtrAcct>) <>
      ~s(<Purp><Cd>IPAY</Cd></Purp>) <>
      ~s(</CdtTrfTxInf>) <>
      ~s(</FIToFICstmrCdtTrf>) <>
      ~s(</Document>)
  end

  defp assemble_envelope(app_hdr, document, signature_xml) do
    app_hdr_with_signature =
      String.replace(app_hdr, "<Sgntr></Sgntr>", "<Sgntr>#{signature_xml}</Sgntr>")

    ~s(<Envelope xmlns="urn:pix:envelope">#{app_hdr_with_signature}#{document}</Envelope>)
  end
end
