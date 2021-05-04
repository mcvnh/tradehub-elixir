defmodule Tradehub.Exchange do
  @moduledoc """
  This module allows developers to interact with the public endpoints mainly focusing on the
  exchange information.
  """

  @doc """
  Requests all known tokens on the Tradehub chain.

  ## Examples

      iex> Tradehub.Exchange.tokens

  """

  @spec tokens :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.token())}

  def tokens do
    case Tradehub.get("get_tokens") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Request information about a token

  ## Examples

      iex> Tradehub.Exchange.token("swth")

  """

  @spec token(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.token()}

  def token(denom) do
    case Tradehub.get("get_token", params: %{token: String.downcase(denom)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

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

  @spec markets(nil, nil, nil) :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.market())}
  @spec markets(String.t(), boolean, boolean()) :: {:error, HTTPoison.Error.t()} | {:ok, list(Tradehub.market())}

  def markets(market_type \\ nil, is_active \\ nil, is_settled \\ nil) do
    request =
      Tradehub.get("get_markets", params: %{market_type: market_type, is_active: is_active, is_settled: is_settled})

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Request information about a market

  ## Examples

      iex> Tradehub.Exchange.market("swth_eth1")

  """

  @spec market(String.t()) :: {:ok, Tradehub.market()} | {:error, HTTPoison.Error.t()}

  def market(market) do
    case Tradehub.get("get_market", params: %{market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get the latest orderbook of given market

  ## Parameters

  - **market**: a market ticker used by the chain, e.g `swth_eth1`
  - **limit**: number of results per side (asks, bids)

  ## Examples

      iex> Tradehub.Exchange.orderbook("swth_eth1")

  """

  @spec orderbook(String.t(), integer) :: {:ok, Tradehub.orderbook()} | {:error, HTTPoison.Error.t()}

  def orderbook(market, limit \\ 50) do
    request = Tradehub.get("get_orderbook", params: %{market: String.downcase(market), limit: limit})

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests oracle informations of the Tradehub

  ## Examples

      iex> Tradehub.Exchange.oracle_results

  """

  @type oracle_id :: String.t()
  @type id_to_oracle :: %{oracle_id => Tradehub.oracle()}
  @spec oracle_results :: {:ok, id_to_oracle} | {:error, HTTPoison.Error.t()}

  def oracle_results() do
    case Tradehub.get("get_oracle_results") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests oracle information about a given oracle id

  ## Examples

      iex> Tradehub.Exchange.oracle_result("SIDXBTC")

  """

  @spec oracle_result(oracle_id) :: {:ok, Tradehub.oracle()} | {:error, HTTPoison.Error.t()}

  def oracle_result(oracle_id) do
    case Tradehub.get("get_oracle_result", params: %{id: String.upcase(oracle_id)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get insurance fund balances of the chain.

  ## Examples

      iex> Tradehub.Exchange.insurance_balances

  """

  @spec insurance_balances :: {:ok, list(Tradehub.coin())} | {:error, HTTPoison.Error.t()}

  def insurance_balances do
    case Tradehub.get("get_insurance_balance") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end
end
