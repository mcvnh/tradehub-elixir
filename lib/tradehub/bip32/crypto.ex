defmodule Tradehub.BIP32.Crypto do
  @moduledoc false

  def hash160(data) do
    :crypto.hash(:ripemd160, :crypto.hash(:sha256, data))
  end

  # def sha256(data), do: :crypto.hash(:sha256, data)

  # def sha512(data), do: :crypto.hash(:sha512, data)

  def hmac_sha512(key, data), do: :crypto.hmac(:sha512, key, data)

  defmodule Secp256k1 do
    @moduledoc false

    # SEE: https://en.bitcoin.it/wiki/Private_key
    @n 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141

    def n, do: @n

    def valid_xprv?(key, il) when is_binary(key) and is_binary(il) do
      key = :binary.decode_unsigned(key)
      il = :binary.decode_unsigned(il)
      key > 0 and il in 1..@n
    end

    # def valid_xpub?(key, il) when is_binary(key) and is_binary(il) do
    #   result = :libsecp256k1.ec_pubkey_verify(key)
    #   il = :binary.decode_unsigned(il)
    #   result == :ok and il in 1..@n
    # end

    # def compress_pubkey(<<4::8, x::256, y::256>>) when rem(y, 2) == 0,
    #   do: <<2::8, x::256>>

    # def compress_pubkey(<<4::8, x::256, y::256>>) when rem(y, 2) == 1,
    #   do: <<3::8, x::256>>

    # def compress_pubkey(_), do: {:error, :invalid_uncompressed_pubkey}

    # def decompress_pubkey(<<prefix::8, _rest::binary>> = pubkey) when prefix in [2, 3] do
    #   {:ok, pubkey} = :libsecp256k1.ec_pubkey_decompress(pubkey)
    #   pubkey
    # end

    def derive_pubkey(privkey, type)
        when is_binary(privkey) and type in [:compressed, :uncompressed] do
      {:ok, pubkey} = :libsecp256k1.ec_pubkey_create(privkey, type)
      pubkey
    end

    # def pubkey_tweak_add(pubkey, point) when is_binary(pubkey) and is_binary(point) do
    #   {:ok, result} = :libsecp256k1.ec_pubkey_tweak_add(pubkey, point)
    #   result
    # end
  end
end
