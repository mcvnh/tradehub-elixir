defmodule Tradehub.Wallet do
  @moduledoc """
  This module aims to signing, generating, and interacting with a Tradehub account.
  """

  require Logger

  @network Application.get_env(:tradehub, :network, :testnet)

  @type t :: %__MODULE__{
          mnemonic: String.t(),
          private_key: String.t(),
          public_key: String.t(),
          address: String.t(),
          network: atom()
        }

  defstruct mnemonic: "",
            private_key: <<>>,
            public_key: <<>>,
            address: "",
            network: @network

  @doc """
   Look for the private key based on the given mnemonic phrase.

  ## Examples

      iex> Tradehub.Wallet.private_key_from_mnemonic("wrist coyote fuel wet evil tag shoot yellow morning history visit mosquito")
      <<21, 31, 133, 212, 19, 88, 245, 109, 20, 190, 196, 132, 108, 83, 112, 163, 174, 79, 52, 222, 203, 167, 29, 72, 254, 172, 117, 236, 191, 108, 140, 161>>

  """

  @spec private_key_from_mnemonic(String.t()) :: bitstring()

  def private_key_from_mnemonic(mnemonic) do
    mnemonic
    |> Tradehub.Mnemonic.mnemonic_to_seed()
    |> String.upcase()
    |> Base.decode16!()
    |> ExtendedKey.master()
    |> ExtendedKey.derive_path("m/44'/118'/0'/0/0")
    |> Map.get(:key)
  end

  @doc """
  Look for the public key based on the given mnemonic phrase.

  ## Examples

      iex> Tradehub.Wallet.public_key_from_mnemonic("wrist coyote fuel wet evil tag shoot yellow morning history visit mosquito")
      {:ok, <<2, 230, 25, 59, 87, 182, 114, 223, 41, 153, 127, 228, 149, 215, 139, 79, 211, 234, 174, 157, 170, 224, 165, 226, 128, 49, 41, 226, 194, 27, 80, 78, 35>>}

  """

  @spec public_key_from_mnemonic(String.t()) :: {:ok, String.t()} | {:error, String.t()}

  def public_key_from_mnemonic(mnemonic) do
    private_key = private_key_from_mnemonic(mnemonic)

    :libsecp256k1.ec_pubkey_create(private_key, :compressed)
  end

  @doc """
  Look for the public key based on the given private key phrase.

  ## Examples

      iex> Tradehub.Wallet.public_key_from_private_key("151f85d41358f56d14bec4846c5370a3ae4f34decba71d48feac75ecbf6c8ca1")
      {:ok, <<2, 230, 25, 59, 87, 182, 114, 223, 41, 153, 127, 228, 149, 215, 139, 79, 211, 234, 174, 157, 170, 224, 165, 226, 128, 49, 41, 226, 194, 27, 80, 78, 35>>}

  """

  @spec public_key_from_private_key(String.t() | bitstring()) ::
          {:ok, String.t()} | {:error, String.t()}

  def public_key_from_private_key(private_key) do
    {:ok, private_key} = normalize_hex_string(private_key)

    :libsecp256k1.ec_pubkey_create(private_key, :compressed)
  end

  @doc """
  Look for the wallet address based on the given mnemonic phrase within a network.

  ## Examples

      iex> Tradehub.Wallet.address_from_mnemonic("wrist coyote fuel wet evil tag shoot yellow morning history visit mosquito")
      {:ok, "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"}

      iex> Tradehub.Wallet.address_from_mnemonic("wrist coyote fuel wet evil tag shoot yellow morning history visit mosquito", :mainnet)
      {:ok, "swth174cz08dmgluavwcz2suztvydlptp4a8fru98vw"}

  """

  @spec address_from_mnemonic(String.t(), atom()) :: {:ok, String.t()} | {:error, String.t()}

  def address_from_mnemonic(mnemonic, network \\ @network) do
    case public_key_from_mnemonic(mnemonic) do
      {:ok, public_key} ->
        sha = :crypto.hash(:sha256, public_key)
        rip = :crypto.hash(:ripemd160, sha)

        prefix =
          case network do
            :mainnet -> "swth"
            :testnet -> "tswth"
            other -> Atom.to_string(other)
          end

        {:ok, Bech32.encode_from_5bit(prefix, Bech32.convertbits(rip, 8, 5, false))}
    end
  end

  @doc """
  Look for the wallet address based on the given public key within a network.

  ## Examples

      iex> Tradehub.Wallet.address_from_private_key("151f85d41358f56d14bec4846c5370a3ae4f34decba71d48feac75ecbf6c8ca1")
      {:ok, "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"}

      iex> Tradehub.Wallet.address_from_private_key(<<21, 31, 133, 212, 19, 88, 245, 109, 20, 190, 196, 132, 108, 83, 112, 163, 174, 79, 52, 222, 203, 167, 29, 72, 254, 172, 117, 236, 191, 108, 140, 161>>)
      {:ok, "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"}

      iex> Tradehub.Wallet.address_from_private_key("151f85d41358f56d14bec4846c5370a3ae4f34decba71d48feac75ecbf6c8ca1", :mainnet)
      {:ok, "swth174cz08dmgluavwcz2suztvydlptp4a8fru98vw"}

  """

  @spec address_from_private_key(String.t() | bitstring(), atom()) ::
          {:ok, String.t()} | {:error, String.t()}

  def address_from_private_key(private_key, network \\ @network) do
    {:ok, private_key} = normalize_hex_string(private_key)
    {:ok, public_key} = public_key_from_private_key(private_key)

    address_from_public_key(public_key, network)
  end

  @doc """
  Look for the wallet address of based on the given public key within a network.

  ## Examples

      iex> Tradehub.Wallet.address_from_public_key("02e6193b57b672df29997fe495d78b4fd3eaae9daae0a5e2803129e2c21b504e23")
      {:ok, "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"}

      iex> Tradehub.Wallet.address_from_public_key(<<2, 230, 25, 59, 87, 182, 114, 223, 41, 153, 127, 228, 149, 215, 139, 79, 211, 234, 174, 157, 170, 224, 165, 226, 128, 49, 41, 226, 194, 27, 80, 78, 35>>)
      {:ok, "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"}

      iex> Tradehub.Wallet.address_from_public_key("02e6193b57b672df29997fe495d78b4fd3eaae9daae0a5e2803129e2c21b504e23", :mainnet)
      {:ok, "swth174cz08dmgluavwcz2suztvydlptp4a8fru98vw"}

  """

  @spec address_from_public_key(String.t(), atom()) :: {:ok, String.t()} | {:error, String.t()}

  def address_from_public_key(public_key, network \\ @network) do
    {:ok, public_key} = normalize_hex_string(public_key)

    sha = :crypto.hash(:sha256, public_key)
    rip = :crypto.hash(:ripemd160, sha)

    prefix =
      case network do
        :mainnet -> "swth"
        :testnet -> "tswth"
        other -> Atom.to_string(other)
      end

    {:ok, Bech32.encode_from_5bit(prefix, Bech32.convertbits(rip, 8, 5, false))}
  end

  @doc """
  Generate a new Tradehub wallet

  ## Examples

      iex> Tradehub.Wallet.create_wallet

      iex> Tradehub.Wallet.create_wallet(:testnet)

  """

  @spec create_wallet(atom()) :: Tradehub.Wallet.t()

  def create_wallet(network \\ @network) do
    mnemonic = Tradehub.Mnemonic.generate(128)

    private_key =
      private_key_from_mnemonic(mnemonic)
      |> Base.encode16()
      |> String.downcase()

    {:ok, public_key} = public_key_from_private_key(private_key)
    {:ok, address} = address_from_private_key(private_key, network)

    %Tradehub.Wallet{
      mnemonic: mnemonic,
      private_key: private_key,
      public_key: public_key,
      address: address
    }
  end

  @doc """
  Open a wallet based on its private key.

  ## Examples

      iex> Tradehub.Wallet.from_private_key("151f85d41358f56d14bec4846c5370a3ae4f34decba71d48feac75ecbf6c8ca1")

  """

  @spec from_private_key(String.t(), atom()) :: {:ok, Tradehub.Wallet.t()} | {:error, String.t()}

  def from_private_key(private_key, network \\ @network) do
    case public_key_from_private_key(private_key) do
      {:ok, public_key} ->
        {:ok, address} = address_from_private_key(private_key, network)

        wallet = %__MODULE__{
          private_key: private_key,
          public_key: public_key,
          address: address,
          network: network
        }

        {:ok, wallet}
    end
  end

  @doc """
  Open a wallet based on its mnemonic.

  ## Examples

      iex> {:ok, wallet} = Tradehub.Wallet.from_mnemonic("wrist coyote fuel wet evil tag shoot yellow morning history visit mosquito")
      iex> wallet.address
      "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

      iex> {:ok, wallet} = Tradehub.Wallet.from_mnemonic("wrist coyote fuel wet evil tag shoot yellow morning history visit mosquito", :mainnet)
      iex> wallet.address
      "swth174cz08dmgluavwcz2suztvydlptp4a8fru98vw"

  """

  @spec from_mnemonic(String.t(), atom()) :: {:ok, Tradehub.Wallet.t()} | {:error, String.t()}

  def from_mnemonic(mnemonic, network \\ @network) do
    private_key = private_key_from_mnemonic(mnemonic)

    from_private_key(private_key, network)
  end

  @doc """
  Sign the given message by using a wallet private key, and verify the signed messaged by using the wallet public key.

  Due to the nature of blockchain, the message will sign by the curve digital signature algorithm (ECDSA), with curve
  is `secp256k1` and the hash algorithm is `sha256`.

  ## Examples

      iex> wallet = Tradehub.Wallet.create_wallet()
      iex> Tradehub.Wallet.sign(%{message: "hello world"}, wallet)

  """

  @spec sign(map(), %Tradehub.Wallet{}) :: {:ok, String.t()} | {:error, String.t()}

  def sign(message, wallet) do
    message_with_correct_keys_order = encode_object_in_alphanumeric_key_order(message)

    {:ok, private_key} = normalize_hex_string(wallet.private_key)
    {:ok, public_key} = normalize_hex_string(wallet.public_key)

    signature = :crypto.sign(:ecdsa, :sha256, message_with_correct_keys_order, [private_key, :secp256k1])
    verify = :crypto.verify(:ecdsa, :sha256, message_with_correct_keys_order, signature, [public_key, :secp256k1])

    case verify do
      true -> {:ok, signature |> Base.encode64()}
      false -> {:error, "Cannot verify the message"}
    end
  end

  @doc ~S"""
  Encode a map to JSON with all of the keys in alphabetical order (nested included).

  ## Examples

      iex> Tradehub.Wallet.encode_object_in_alphanumeric_key_order(%{b: 1, c: 2, a: 3, d: 4})
      "{\"a\":3,\"b\":1,\"c\":2,\"d\":4}"

      iex> Tradehub.Wallet.encode_object_in_alphanumeric_key_order(%{b: %{e: 1, f: 2}, c: 2, a: 3, d: 4})
      "{\"a\":3,\"b\":{\"e\":1,\"f\":2},\"c\":2,\"d\":4}"

      iex> Tradehub.Wallet.encode_object_in_alphanumeric_key_order("")
      "\"\""

  """

  def encode_object_in_alphanumeric_key_order(obj) when is_map(obj) do
    az_keys = obj |> Map.keys() |> Enum.sort()

    iodata = [
      "{",
      Enum.map(az_keys, fn k ->
        v = obj[k]
        [Jason.encode!(k), ":", encode_object_in_alphanumeric_key_order(v)]
      end)
      |> Enum.intersperse(","),
      "}"
    ]

    IO.iodata_to_binary(iodata)
  end

  def encode_object_in_alphanumeric_key_order(obj), do: Jason.encode!(obj)

  ## Private functions

  defp normalize_hex_string(string) do
    case String.valid?(string) do
      true ->
        string
        |> String.upcase()
        |> Base.decode16()

      false ->
        {:ok, string}
    end
  end
end
