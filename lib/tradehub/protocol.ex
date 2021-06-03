defmodule Tradehub.Protocol do
  @moduledoc """
  This module provides a set of functionalities to retreive information from the tradehub protocol.
  """

  import Tradehub.Raising

  @doc """
  Requests Cosmos RPC status endpoint

  ## Examples

      iex> Tradehub.Protocol.status

  """

  @spec status :: {:ok, Tradehub.protocol_status()} | {:error, HTTPoison.Error.t()}
  @spec status! :: Tradehub.protocol_status()

  def status do
    case Tradehub.get("get_status") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:status)

  @doc """
  Get the block time in format HH:MM:SS.ZZZZZZ.

  ## Examples

      iex> Tradehub.Protocol.block_time

  """

  @spec block_time :: {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  @spec block_time! :: String.t()

  def block_time do
    case Tradehub.get("get_block_time") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:block_time)

  @doc """
  Get all validators, includes active, unbonding, and unbonded validators.

  ## Examples

      iex> Tradehub.Protocol.validators

  """

  @spec validators :: {:ok, list(Tradehub.validator())} | {:error, HTTPoison.Error.t()}
  @spec validators! :: list(Tradehub.validator())

  def validators do
    case Tradehub.get("get_all_validators") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:validators)

  @doc """
  Requests delegation rewards of the given account

  ## Examples

      iex> Tradehub.Protocol.delegation_rewards("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")

  """

  @spec delegation_rewards(String.t()) ::
          {:ok, Tradehub.delegation_rewards()} | String.t() | {:error, HTTPoison.Error.t()}
  @spec delegation_rewards!(String.t()) :: Tradehub.delegation_rewards() | String.t()

  def delegation_rewards(account) do
    case Tradehub.get(
           "get_delegation_rewards",
           params: %{account: account}
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:delegation_rewards, account)

  @doc """
  Requests latest blocks or specific blocks that match the requested parameters.

  ## Examples

      iex> Tradehub.Protocol.blocks

  """

  @typedoc """
  Query params for `/get_blocks` endpoint.

  - **before_id**: before block height
  - **after_id**: after block height
  - **order_by**: not specified yet
  - **proposer**: tradehub validator consensus starting with `swthvalcons1` on mainnet and `tswthvalcons1` on testnet
  - **limit**: limit the responded result, values greater than 200 have no effect and a maximum of 200 results are returned.
  """
  @type block_options :: %{
          before_id: String.t(),
          after_id: String.t(),
          order_by: String.t(),
          proposer: String.t(),
          limit: integer()
        }

  @spec blocks(%{}) :: {:ok, list(Tradehub.block())} | String.t() | {:error, HTTPoison.Error.t()}
  @spec blocks(block_options()) :: {:ok, list(Tradehub.block())} | String.t() | {:error, HTTPoison.Error.t()}
  @spec blocks!(block_options()) :: list(Tradehub.block()) | String.t()

  def blocks(block_options \\ %{}) do
    case Tradehub.get("get_blocks", params: block_options) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:blocks)
  raising(:blocks, block_options)

  @doc """
  Requests latest transactions or filtered transactions based on the filter params.

  ## Examples

      iex> Tradehub.Protocol.transactions

  """

  @typedoc """
  Query params for `/get_transactions` endpoint.

  - **address**: tradehub switcheo address starts with `swth1` on mainnet and `tswth1` on testnet.
  - **msg_type**: filtered by `msg_type`, allowed values can be fetch with `Tradehub.Protocol.transaction_types`
  - **height**: filter transactions at a specific height
  - **start_block**: filter transactions after block
  - **end_block**: filter transactions before block
  - **before_id**: filter transactions before id
  - **after_id**: filter transactions after id
  - **order_by**: TODO
  - **limit**: limit by 200, values above 200 have no effects.
  """
  @type transaction_options :: %{
          address: String.t(),
          msg_type: String.t(),
          height: String.t(),
          start_block: String.t(),
          end_block: String.t(),
          before_id: String.t(),
          after_id: String.t(),
          order_by: String.t(),
          limit: String.t()
        }

  @spec transactions(%{}) ::
          {:ok, list(Tradehub.transaction())} | String.t() | {:error, HTTPoison.Error.t()}
  @spec transactions(transaction_options) ::
          {:ok, list(Tradehub.transaction())} | String.t() | {:error, HTTPoison.Error.t()}
  @spec transactions!(transaction_options) :: list(Tradehub.transaction()) | String.t()

  def transactions(transaction_options \\ %{}) do
    case Tradehub.get("get_transactions", params: transaction_options) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:transactions)
  raising(:transactions, transaction_options)

  @doc """
  Get a transaction by providing a hash

  ## Examples

      iex> Tradehub.Protocol.transaction("A93BEAC075562D4B6031262BDDE8B9A720346A54D8570A881E3671FEB6E6EFD4")

  """

  @spec transaction(String.t()) :: {:ok, Tradehub.transaction_details()} | String.t() | {:error, HTTPoison.Error.t()}
  @spec transaction!(String.t()) :: Tradehub.transaction_details() | String.t()

  def transaction(hash) do
    case Tradehub.get(
           "get_transaction",
           params: %{hash: hash}
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:transaction, hash)

  @doc """
  Requests available transaction types on Tradehub

  ## Examples

      iex> Tradehub.Protocol.transaction_types

  """

  @spec transaction_types :: {:ok, list(String.t())} | {:error, HTTPoison.Error.t()}
  @spec transaction_types! :: list(String.t())

  def transaction_types do
    case Tradehub.get("get_transaction_types") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:transaction_types)

  @doc """
  Get total of available balances of token on the chain.

  ## Examples

      iex> Tradehub.Protocol.total_balances

  """

  @spec total_balances :: {:ok, list(Tradehub.protocol_balance())} | {:error, HTTPoison.Error.t()}
  @spec total_balances! :: list(Tradehub.protocol_balance())

  def total_balances do
    case Tradehub.get("get_total_balances") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:total_balances)

  @doc """
  Get external transfers (both withdraws and deposits) of an account from other blockchains.

  ## Examples

      iex> Tradehub.Protocol.external_transfers("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")

  """

  @spec external_transfers(String.t()) :: {:ok, list(Tradehub.transfer_record())} | {:error, HTTPoison.Error.t()}
  @spec external_transfers!(String.t()) :: list(Tradehub.transfer_record())

  def external_transfers(account) do
    case Tradehub.get(
           "get_external_transfers",
           params: %{account: account}
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:external_transfers, account)
end
