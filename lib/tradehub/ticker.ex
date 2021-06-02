defmodule Tradehub.Ticker do
  @moduledoc """
  Enable features to work with tickers endpoints.
  """

  import Tradehub.Raising

  @typedoc "Candlestick resolution allowed value"
  @type resolution :: 1 | 5 | 30 | 60 | 360 | 1440

  @doc """
  Requests candlesticks for the given market.

  ## Parameters

  - **market**: the market symbols: e.g `swth_eth1`
  - **resolution**: the candlestick period in minutes, possible values are: 1, 5, 30, 60, 360, 1440
  - **from**: the start of time range for data in epoch `seconds`
  - **to**: the end of time range for data in epoch `seconds`

  ## Returns

  - a list of `Tradehub.candlestick()` as expected
  - a string that represents of an error
  - an error if something goes wrong with the connection

  ## Examples

      iex> Tradehub.Ticker.candlesticks("swth_eth1", 5, 1610203000, 1610203000)

  """

  @spec candlesticks(String.t(), resolution(), integer, integer) ::
          {:ok, list(Tradehub.candlestick())} | String.t() | {:error, HTTPoison.Error.t()}
  @spec candlesticks!(String.t(), resolution(), integer, integer) ::
          list(Tradehub.candlestick()) | String.t()

  def candlesticks(market, resolution, from, to) do
    case Tradehub.get(
           "candlesticks",
           params: %{
             market: market,
             resolution: resolution,
             from: from,
             to: to
           }
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:candlesticks, market, resolution, from, to)

  @doc """
  Get recent ticker prices of the given market.

  ## Returns

  - an object of type `Tradehub.ticker_prices()` as expected
  - an error if something goes wrong with the connection

  ## Note

  The `GET /get_prices` endpoint is not completely implemented, it always responses
  an object of type `Tradehub.ticker_prices()` although the market param is invalid

  ## Examples

      iex> Tradehub.Ticker.prices("swth_eth1")

  """

  @spec prices(String.t()) :: {:ok, Tradehub.ticker_prices()} | {:error, HTTPoison.Error.t()}
  @spec prices!(String.t()) :: Tradehub.ticker_prices()

  def prices(market) do
    request =
      Tradehub.get(
        "get_prices",
        params: %{market: market}
      )

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:prices, market)

  @doc """
  Requests latest statistics information about the given market or all markets

  ## Returns

  - a list of `Tradehub.market_stats()` as expected
  - a string that represents of an error
  - an error if something goes wrong with the connection

  ## Examples

      iex> Tradehub.Ticker.market_stats
      iex> Tradehub.Ticker.market_stats("swth_eth1")

  """

  @spec market_stats(nil) ::
          {:ok, list(Tradehub.market_stats())} | String.t() | {:error, HTTPoison.Error.t()}
  @spec market_stats(String.t()) ::
          {:ok, list(Tradehub.market_stats())} | String.t() | {:error, HTTPoison.Error.t()}
  @spec market_stats!(String.t()) :: list(Tradehub.market_stats()) | String.t()

  def market_stats(market \\ nil) do
    request =
      Tradehub.get(
        "get_market_stats",
        params: %{market: market}
      )

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:market_stats)
  raising(:market_stats, market)
end
