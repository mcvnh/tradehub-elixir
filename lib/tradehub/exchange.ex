defmodule Tradehub.Exchange do
  @moduledoc """
  This module allows developers to interact with the public endpoints mainly focusing on the
  exchange information.
  """

  @token Application.fetch_env!(:tradehub, :public_exchange_token)
  @tokens Application.fetch_env!(:tradehub, :public_exchange_tokens)
  @market Application.fetch_env!(:tradehub, :public_exchange_market)
  @markets Application.fetch_env!(:tradehub, :public_exchange_markets)
  @orderbook Application.fetch_env!(:tradehub, :public_exchange_orderbook)
  @oracle_result Application.fetch_env!(:tradehub, :public_exchange_oracle_result)
  @oracle_results Application.fetch_env!(:tradehub, :public_exchange_oracle_results)
  @insurance_balance Application.fetch_env!(:tradehub, :public_exchange_insurance_fund_balance)

  @spec tokens :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.token)}
  @doc """
  Requests all known tokens on the Tradehub chain.

  ## Examples

      iex> Tradehub.Exchange.tokens

  """
  def tokens do
    case Tradehub.get(@tokens) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec token(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.token}
  @doc """
  Request information about a token

  ## Examples

      iex> Tradehub.Exchange.token("swth")

  """
  def token(denom) do
    case Tradehub.get(@token, params: %{token: String.downcase(denom)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec markets(String.t(), boolean, boolean()) :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.market)}
  @doc """
  Requests all markets or filtered markets

  ## Parameters

  - **market_type** - type of the market, `future` or `spot`
  - **is_active** - if only active markets should be returned
  - **is_settled** - if only settled markets should be returned

  ## Examples

      iex> Tradehub.Exchange.markets
      iex> Tradehub.Exchange.markets("spot")

  """
  def markets(market_type \\ nil, is_active \\ nil, is_settled \\ nil) do
    request = Tradehub.get(@markets, params: %{market_type: market_type, is_active: is_active, is_settled: is_settled})
    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec market(String.t()) :: {:ok, Tradehub.market} | {:error, HTTPoison.Error.t()}
  @doc """
  Request information about a market

  ## Examples

      iex> Tradehub.Exchange.market("swth_eth1")

  """
  def market(market) do
    case Tradehub.get(@market, params: %{market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec orderbook(String.t(), integer) :: {:ok, Tradehub.orderbook} | {:error, HTTPoison.Error.t()}
  @doc """
  Get the latest orderbook of given market

  ## Parameters

  - **market**: a market ticker used by the chain, e.g `swth_eth1`
  - **limit**: number of results per side (asks, bids)

  ## Examples

      iex> Tradehub.Exchange.orderbook("swth_eth1")

  """
  def orderbook(market, limit \\ 50) do
    request = Tradehub.get(@orderbook, params: %{market: String.downcase(market), limit: limit})
    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @type oracle_id :: String.t()
  @type id_to_oracle :: %{oracle_id => Tradehub.oracle}
  @spec oracle_results :: {:ok, id_to_oracle} | {:error, HTTPoison.Error.t()}
  @doc """
  Requests oracle informations of the Tradehub

  ## Examples

      iex> Tradehub.Exchange.oracle_results

  """
  def oracle_results() do
    case Tradehub.get(@oracle_results) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec oracle_result(oracle_id) :: {:ok, Tradehub.oracle} | {:error, HTTPoison.Error.t()}
  @doc """
  Requests oracle information about a given oracle id

  ## Examples

      iex> Tradehub.Exchange.oracle_result("SIDXBTC")

  """
  def oracle_result(oracle_id) do
    case Tradehub.get(@oracle_result, params: %{id: String.upcase(oracle_id)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @spec insurance_balances :: {:ok, list(Tradehub.coin)} | {:error, HTTPoison.Error.t()}
  @doc """
  Get insurance fund balances of the chain.

  ## Examples

      iex> Tradehub.Exchange.insurance_balances

  """
  def insurance_balances do
    case Tradehub.get(@insurance_balance) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end
end
