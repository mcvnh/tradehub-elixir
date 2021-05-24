defmodule Tradehub.Exchange do
  @moduledoc """
  This module allows developers to interact with the public endpoints mainly focusing on the
  exchange information.
  """

  import Tradehub.Raising

  @doc """
  Requests all known tokens on the Tradehub chain.

  ## Examples

      iex> Tradehub.Exchange.tokens

  """

  @spec tokens :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.token())}
  @spec tokens! :: list(Tradehub.token())

  def tokens do
    case Tradehub.get("get_tokens") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:tokens)

  @doc """
  Request information about a token

  ## Examples

      iex> Tradehub.Exchange.token("swth")

  """

  @spec token(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.token()}
  @spec token!(String.t()) :: Tradehub.token()

  def token(denom) do
    case Tradehub.get("get_token", params: %{token: String.downcase(denom)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:token, denom)

  @doc """
  Requests all markets or filtered markets

  ## Examples

      iex> Tradehub.Exchange.markets

  """

  @typedoc """
  Query params for `/get_markets` endpoint

  - **market_type** - type of the market, `futures` or `spot`
  - **is_active** - if only active markets should be returned
  - **is_settled** - if only settled markets should be returned

  """
  @type market_options :: %{
          market_type: :future | :spot,
          is_active: boolean(),
          is_settled: boolean()
        }

  @spec markets(%{}) :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.market())}
  @spec markets(market_options()) :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.market())}
  @spec markets!(market_options()) :: list(Tradehub.market())

  def markets(market_options \\ %{}) do
    request = Tradehub.get("get_markets", params: market_options)

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:markets)
  raising(:markets, market_options)

  @doc """
  Request information about a market

  ## Examples

      iex> Tradehub.Exchange.market("swth_eth1")

  """

  @spec market(String.t()) :: {:ok, Tradehub.market()} | {:error, HTTPoison.Error.t()}
  @spec market!(String.t()) :: Tradehub.market()

  def market(market) do
    case Tradehub.get("get_market", params: %{market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:market, market)

  @doc """
  Get the latest orderbook of given market

  ## Parameters

  - **market**: a market ticker used by the chain, e.g `swth_eth1`
  - **limit**: number of results per side (asks, bids)

  ## Examples

      iex> Tradehub.Exchange.orderbook("swth_eth1")

  """

  @spec orderbook(String.t(), integer) :: {:ok, Tradehub.orderbook()} | {:error, HTTPoison.Error.t()}
  @spec orderbook!(String.t(), integer) :: Tradehub.orderbook()

  def orderbook(market, limit \\ 50) do
    request = Tradehub.get("get_orderbook", params: %{market: String.downcase(market), limit: limit})

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:orderbook, market)
  raising(:orderbook, market, limit)

  @doc """
  Requests oracle informations of the Tradehub

  ## Examples

      iex> Tradehub.Exchange.oracle_results

  """

  @type oracle_id :: String.t()
  @type id_to_oracle :: %{oracle_id => Tradehub.oracle()}

  @spec oracle_results :: {:ok, id_to_oracle} | {:error, HTTPoison.Error.t()}
  @spec oracle_results! :: id_to_oracle

  def oracle_results() do
    case Tradehub.get("get_oracle_results") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:oracle_results)

  @doc """
  Requests oracle information about a given oracle id

  ## Examples

      iex> Tradehub.Exchange.oracle_result("SIDXBTC")

  """

  @spec oracle_result(oracle_id) :: {:ok, Tradehub.oracle()} | {:error, HTTPoison.Error.t()}
  @spec oracle_result!(oracle_id) :: Tradehub.oracle()

  def oracle_result(oracle_id) do
    case Tradehub.get("get_oracle_result", params: %{id: String.upcase(oracle_id)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:oracle_result, oracle_id)

  @doc """
  Get insurance fund balances of the chain.

  ## Examples

      iex> Tradehub.Exchange.insurance_balances

  """

  @spec insurance_balances :: {:ok, list(Tradehub.amount())} | {:error, HTTPoison.Error.t()}
  @spec insurance_balances! :: list(Tradehub.amount())

  def insurance_balances do
    case Tradehub.get("get_insurance_balance") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:insurance_balances)
end
