defmodule Tradehub.BIP32 do
  @moduledoc false

  alias Tradehub.BIP32.{Crypto, Binary, Keypath}
  alias Tradehub.BIP32.Crypto.Secp256k1

  @hardened_key_start 0x80000000

  # SEE: https://en.bitcoin.it/wiki/List_of_address_prefixes
  @mainnet_xpub_version <<0x04, 0x88, 0xB2, 0x1E>>
  @mainnet_xprv_version <<0x04, 0x88, 0xAD, 0xE4>>
  @testnet_xpub_version <<0x04, 0x35, 0x87, 0xCF>>
  @testnet_xprv_version <<0x04, 0x35, 0x83, 0x94>>

  @type key :: %__MODULE__{
          version: binary(),
          key: binary(),
          chain_code: binary(),
          parent_fingerprint: binary(),
          depth: integer(),
          child_num: integer()
        }
  defstruct [:version, :key, :chain_code, :parent_fingerprint, :depth, :child_num]

  defguardp is_xpub(version) when version in [@mainnet_xpub_version, @testnet_xpub_version]
  defguardp is_xprv(version) when version in [@mainnet_xprv_version, @testnet_xprv_version]
  defguardp is_hardened(index) when index >= @hardened_key_start
  defguardp is_normal(index) when index >= 0 and index < @hardened_key_start

  @doc ~S"""
  Generates HD wallet seed with specified byte size
  """
  @spec seed(byte_size :: integer()) :: binary()
  def seed(byte_size \\ 32), do: :crypto.strong_rand_bytes(byte_size)

  @doc ~S"""
  Generates private master extended key with given seed and network
  ## Examples
      iex> seed = Base.decode16!("81D0E7581BF0C55B2941B2295EB4FD1F9C52D080F8D58A3DB634DE80200BA238")
      iex> Tradehub.BIP32.master(seed)
      %Tradehub.BIP32{
        chain_code: <<219, 39, 154, 114, 218, 155, 234, 37, 227,
          62, 178, 45, 188, 99, 205, 47, 231, 116, 197, 153, 65,
          210, 122, 59, 183, 217, 163, 153, 181, 126, 212, 49>>,
        child_num: 0,
        depth: 0,
        key: <<186, 255, 178, 91, 225, 143, 38, 20, 157, 136, 154,
          47, 67, 94, 33, 236, 13, 194, 187, 72, 112, 195, 171, 7,
          88, 186, 159, 98, 88, 53, 41, 136>>,
        parent_fingerprint: <<0, 0, 0, 0>>,
        version: <<4, 136, 173, 228>>
      }
  """
  @spec master(seed :: binary(), network :: :mainnet | :testnet) :: key() | {:error, term()}
  def master(seed, network \\ :mainnet)

  def master(seed, network) when byte_size(seed) in 16..64 do
    <<key::bytes-size(32), chain_code::bytes-size(32)>> = Crypto.hmac_sha512("Bitcoin seed", seed)

    %__MODULE__{
      version: version(:xprv, network),
      key: key,
      chain_code: chain_code,
      parent_fingerprint: <<0::32>>,
      depth: 0,
      child_num: 0
    }
  end

  def master(_seed, _network), do: {:error, :invalid_seed}

  @doc ~S"""
  Derives child extended key with given key path,
  hardened can be represented with `H`, `h` or `'`, e.g. `m/0H/1/2H/2/1000000000`
  ## Examples
    Derive private extended key

      iex> seed = Base.decode16!("81D0E7581BF0C55B2941B2295EB4FD1F9C52D080F8D58A3DB634DE80200BA238")
      iex> master = Tradehub.BIP32.master(seed)
      iex> Tradehub.BIP32.derive_path(master, "m/0")
      %Tradehub.BIP32{
        chain_code: <<81, 134, 58, 230, 254, 116, 95, 133, 120,
          201, 148, 202, 21, 162, 172, 251, 172, 207, 11, 123, 23,
          163, 17, 104, 229, 164, 4, 203, 82, 235, 182, 98>>,
        child_num: 0,
        depth: 1,
        key: <<221, 183, 68, 24, 208, 227, 114, 203, 222, 172, 41,
          97, 113, 120, 208, 123, 220, 241, 248, 18, 174, 129, 46,
          20, 141, 240, 111, 137, 78, 163, 176, 38>>,
        parent_fingerprint: <<197, 217, 101, 7>>,
        version: <<4, 136, 173, 228>>
      }

    Derives public extended key

      iex> seed = Base.decode16!("81D0E7581BF0C55B2941B2295EB4FD1F9C52D080F8D58A3DB634DE80200BA238")
      iex> master = Tradehub.BIP32.master(seed)
      iex> Tradehub.BIP32.derive_path(master, "M/0")
      %Tradehub.BIP32{
        chain_code: <<81, 134, 58, 230, 254, 116, 95, 133, 120,
          201, 148, 202, 21, 162, 172, 251, 172, 207, 11, 123, 23,
          163, 17, 104, 229, 164, 4, 203, 82, 235, 182, 98>>,
        child_num: 0,
        depth: 1,
        key: <<3, 105, 136, 100, 17, 127, 136, 122, 182, 104, 212,
          103, 97, 101, 215, 37, 57, 133, 58, 22, 120, 242, 32,
          192, 179, 205, 202, 61, 143, 32, 166, 96, 204>>,
        parent_fingerprint: <<197, 217, 101, 7>>,
        version: <<4, 136, 178, 30>>
      }
  """
  @spec derive_path(master :: key(), path :: String.t()) :: key() | {:error, term()}
  def derive_path(%__MODULE__{version: version} = master, path) when is_xprv(version) do
    case Keypath.to_list(path) do
      {:xprv, keypath} ->
        do_derive_path(master, keypath)

      {:xpub, keypath} ->
        master
        |> do_derive_path(keypath)
        |> neuter()
    end
  end

  def derive_path(%__MODULE__{version: version} = master, path) when is_xpub(version) do
    case Keypath.to_list(path) do
      {:xprv, _} -> {:error, :parent_pubkey_to_child_privkey}
      {:xpub, keypath} -> do_derive_path(master, keypath)
    end
  end

  @doc ~S"""
  Derives a child extended key with a given index
  ## Examples
      iex> seed = Base.decode16!("81D0E7581BF0C55B2941B2295EB4FD1F9C52D080F8D58A3DB634DE80200BA238")
      iex> master = Tradehub.BIP32.master(seed)
      iex> Tradehub.BIP32.derive_child(master, 0)
      %Tradehub.BIP32{
        chain_code: <<81, 134, 58, 230, 254, 116, 95, 133, 120,
          201, 148, 202, 21, 162, 172, 251, 172, 207, 11, 123, 23,
          163, 17, 104, 229, 164, 4, 203, 82, 235, 182, 98>>,
        child_num: 0,
        depth: 1,
        key: <<221, 183, 68, 24, 208, 227, 114, 203, 222, 172, 41,
          97, 113, 120, 208, 123, 220, 241, 248, 18, 174, 129, 46,
          20, 141, 240, 111, 137, 78, 163, 176, 38>>,
        parent_fingerprint: <<197, 217, 101, 7>>,
        version: <<4, 136, 173, 228>>
      }
  """
  @spec derive_child(parent :: key(), child_index :: integer()) :: key() | {:error, term()}
  def derive_child(
        %__MODULE__{depth: depth, version: version} = parent,
        child_index
      )
      when depth < 255 do
    with {:ok, child_key, child_chain_code} <- child_key_and_chain_code(parent, child_index) do
      %__MODULE__{
        version: version,
        key: child_key,
        chain_code: child_chain_code,
        parent_fingerprint: parent_fingerprint(parent),
        depth: depth + 1,
        child_num: child_index
      }
    end
  end

  def derive_child(%__MODULE__{}, _child_index), do: {:error, :invalid_depth}

  @doc ~S"""
  Generates a new extended public key from extended private key. If the input key is
  already an extended public key, the key will be returned unaltered
  ## Examples
      iex> seed = Base.decode16!("81D0E7581BF0C55B2941B2295EB4FD1F9C52D080F8D58A3DB634DE80200BA238")
      iex> master = Tradehub.BIP32.master(seed)
      iex> Tradehub.BIP32.neuter(master)
      %Tradehub.BIP32{
        chain_code: <<219, 39, 154, 114, 218, 155, 234, 37, 227,
          62, 178, 45, 188, 99, 205, 47, 231, 116, 197, 153, 65,
          210, 122, 59, 183, 217, 163, 153, 181, 126, 212, 49>>,
        child_num: 0,
        depth: 0,
        key: <<2, 50, 31, 41, 0, 12, 128, 135, 180, 205, 101, 152,
          78, 96, 157, 22, 33, 235, 18, 207, 180, 81, 232, 138,
          182, 66, 20, 211, 165, 7, 176, 30, 79>>,
        parent_fingerprint: <<0, 0, 0, 0>>,
        version: <<4, 136, 178, 30>>
      }
  """
  @spec neuter(key :: key()) :: key()
  def neuter(%__MODULE__{version: version, key: key} = extended_key) when is_xprv(version) do
    extended_key
    |> Map.put(:version, version(:xpub, network(extended_key)))
    |> Map.put(:key, Secp256k1.derive_pubkey(key, :compressed))
  end

  def neuter(%__MODULE__{version: version} = extkey) when is_xpub(version), do: extkey

  @doc ~S"""
  Encodes an extended key to string
  ## Examples
      iex> seed = Base.decode16!("81D0E7581BF0C55B2941B2295EB4FD1F9C52D080F8D58A3DB634DE80200BA238")
      iex> master = Tradehub.BIP32.master(seed)
      iex> Tradehub.BIP32.to_string(master)
      "xprv9s21ZrQH143K4EucrSWAiD6LAFAv7W3DaVp5Zv8LohRYqTM7hPLCQrxsvvv6DoD8Awb64daXUmYLufQhZv9BjckFgqLP6He9HfSMFHQzmM6"
  """
  @spec to_string(key :: key()) :: String.t()
  def to_string({:error, error}), do: {:error, error}

  def to_string(%__MODULE__{} = extended_key) do
    extended_key
    |> serialize()
    |> B58.version_encode58_check!()
  end

  @doc ~S"""
  Generates BIP32 instance from given key string
  ## Examples
      iex> Tradehub.BIP32.from_string("xpub6934X9tFysrrNCTyWyFPkXPJRRY6r32gBYxAdaXCqqMhoPTEiwU9dxx4Hyc3PURqGE2sZBVq5m6gAYdr9cJoqZfB4vxZ4iFAtDNmacdccDn")
      %Tradehub.BIP32{
        chain_code: <<198, 248, 135, 0, 62, 141, 53, 185, 57, 202,
          175, 125, 253, 73, 139, 246, 205, 111, 67, 194, 153,
          100, 132, 144, 106, 181, 125, 11, 98, 78, 126, 33>>,
        child_num: 0,
        depth: 1,
        key: <<3, 56, 201, 189, 255, 96, 60, 207, 74, 104, 151,
          220, 159, 3, 155, 27, 1, 50, 33, 253, 125, 240, 201, 9,
          55, 77, 5, 200, 44, 30, 112, 6, 104>>,
        parent_fingerprint: <<156, 35, 137, 101>>,
        version: <<4, 136, 178, 30>>
      }
  """
  @spec from_string(key_string :: String.t()) :: key()
  def from_string(key_string) when is_binary(key_string) do
    key_string
    |> B58.version_decode58_check!()
    |> deserialize()
  end

  @doc """
  Checks if the key is xpub
  """
  @spec public?(key :: key()) :: boolean()
  def public?(%__MODULE__{version: version}) when is_xpub(version), do: true
  def public?(%__MODULE__{}), do: false

  @doc """
  Checks if the key is xprv
  """
  @spec private?(key :: key()) :: boolean()
  def private?(%__MODULE__{version: version}) when is_xprv(version), do: true
  def private?(%__MODULE__{}), do: false

  @doc """
  Checks if the key is hardened key
  """
  @spec hardened?(key :: key()) :: boolean()
  def hardened?(%__MODULE__{child_num: child_num}) when is_hardened(child_num), do: true
  def hardened?(%__MODULE__{}), do: false

  @doc """
  Checks if the key is normal key
  """
  @spec normal?(key :: key()) :: boolean()
  def normal?(%__MODULE__{child_num: child_num}) when is_normal(child_num), do: true
  def normal?(%__MODULE__{}), do: false

  @doc """
  Returns the network of the key
  """
  @spec network(key :: key()) :: :mainnet | :testnet
  def network(%__MODULE__{version: version}) when version in [@mainnet_xprv_version, @mainnet_xpub_version],
    do: :mainnet

  def network(%__MODULE__{version: version}) when version in [@testnet_xprv_version, @testnet_xpub_version],
    do: :testnet

  defp deserialize(
         <<version::bytes-size(4), depth::8, fingerprint::bytes-size(4), child_num::32, chain_code::bytes-size(32),
           key_data::bytes-size(33)>>
       ) do
    key =
      case is_xprv(version) do
        true -> :binary.part(key_data, 1, byte_size(key_data) - 1)
        false -> key_data
      end

    %__MODULE__{
      version: version,
      key: key,
      chain_code: chain_code,
      child_num: child_num,
      parent_fingerprint: fingerprint,
      depth: depth
    }
  end

  defp deserialize(_), do: {:error, :invalid_data}

  defp serialize(%{
         version: version,
         key: key,
         chain_code: chain_code,
         parent_fingerprint: fingerprint,
         depth: depth,
         child_num: child_num
       }) do
    key_data =
      case is_xprv(version) do
        true -> <<0, key::bytes-size(32)>>
        false -> key
      end

    <<version::bytes-size(4), depth::8, fingerprint::bytes-size(4), child_num::32, chain_code::bytes-size(32),
      key_data::bytes-size(33)>>
  end

  # Private parent key → private child key - hardened child
  # Private parent key → private child key - normal child
  defp child_key_and_chain_code(
         %{
           version: version,
           key: parent_key
         } = parent,
         child_index
       )
       when is_xprv(version) do
    {:ok, il, child_chain_code} = il_and_ir(parent, child_index)
    child_key = <<rem(Binary.unsigned_sum(il, parent_key), Secp256k1.n())::256>>

    if Secp256k1.valid_xprv?(child_key, il) do
      {:ok, child_key, child_chain_code}
    else
      {:error, :invalid_child}
    end
  end

  # Public parent key → public child key - hardened child
  # Public parent key → public child key - normal child
  # defp child_key_and_chain_code(
  #        %{
  #          version: version,
  #          key: parent_key
  #        } = parent,
  #        child_index
  #      )
  #      when is_xpub(version) do
  #   derive_child_key = fn parent_key, il ->
  #     parent_key
  #     |> Secp256k1.decompress_pubkey()
  #     |> Secp256k1.pubkey_tweak_add(il)
  #     |> Secp256k1.compress_pubkey()
  #   end

  #   with {:ok, il, child_chain_code} <- il_and_ir(parent, child_index),
  #        child_key when is_binary(child_key) <- derive_child_key.(parent_key, il),
  #        true <- Secp256k1.valid_xpub?(child_key, il) do
  #     {:ok, child_key, child_chain_code}
  #   end
  # end

  defp parent_fingerprint(%{key: key, version: version}) when is_xprv(version) do
    key
    |> Secp256k1.derive_pubkey(:compressed)
    |> Crypto.hash160()
    |> Binary.take(4)
  end

  defp parent_fingerprint(%{key: key, version: version}) when is_xpub(version) do
    key
    |> Crypto.hash160()
    |> Binary.take(4)
  end

  defp i_data(%{version: version, key: parent_key}, child_index)
       when is_hardened(child_index) and is_xprv(version),
       do: <<0, parent_key::bytes-size(32), child_index::32>>

  defp i_data(%{version: version, key: parent_key}, child_index)
       when is_normal(child_index) and is_xprv(version) do
    pubkey = Secp256k1.derive_pubkey(parent_key, :compressed)
    <<pubkey::bytes-size(33), child_index::32>>
  end

  defp i_data(%{version: version}, child_index)
       when is_hardened(child_index) and is_xpub(version),
       do: {:error, :HCKD_from_public}

  defp i_data(%{version: version, key: parent_key}, child_index)
       when is_normal(child_index) and is_xpub(version),
       do: <<parent_key::bytes-size(33), child_index::32>>

  defp il_and_ir(%{chain_code: parent_chain_code} = parent, child_index) do
    case i_data(parent, child_index) do
      data when is_binary(data) ->
        <<il::bytes-size(32), ir::bytes-size(32)>> = Crypto.hmac_sha512(parent_chain_code, data)
        {:ok, il, ir}

      {:error, error} ->
        {:error, error}
    end
  end

  defp do_derive_path({:error, error}, _), do: {:error, error}
  defp do_derive_path(key, []), do: key

  defp do_derive_path(key, [child_index | rest]) do
    key
    |> derive_child(child_index)
    |> do_derive_path(rest)
  end

  defp version(:xprv, :mainnet), do: @mainnet_xprv_version
  defp version(:xpub, :mainnet), do: @mainnet_xpub_version
  defp version(:xprv, :testnet), do: @testnet_xprv_version
  defp version(:xpub, :testnet), do: @testnet_xpub_version
end
