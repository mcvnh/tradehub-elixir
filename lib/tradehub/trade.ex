defmodule Tradehub.Trade do
  @moduledoc """
  This module uses to fetch trade, orders information of the chain.
  """

  import Tradehub.Raising

  @doc """
  Requests orders of the given account

  ## Examples

      iex> Tradehub.Trade.get_orders("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du")

  """

  @spec get_orders(String.t()) :: {:ok, list(Tradehub.order())} | {:error, HTTPoison.Error.t()}
  @spec get_orders!(String.t()) :: list(Tradehub.order())

  def get_orders(account) do
    case Tradehub.get("get_orders", params: %{account: String.downcase(account)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:get_orders, account)

  @doc """
  Requests an order details information by its order id

  ## Examples

      iex> Tradehub.Trade.get_order("A186AC5F560BBD4B2C1F9B21C6EF1814F3295EBD863FA3655F74942CDB198530")

  """

  @spec get_order(String.t()) :: {:ok, Tradehub.order()} | {:error, HTTPoison.Error.t()}
  @spec get_order!(String.t()) :: Tradehub.order()

  def get_order(order_id) do
    case Tradehub.get("get_order", params: %{order_id: String.upcase(order_id)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:get_order, order_id)

  @doc """
  Requests avaiable positions of the given account in all markets which the account get involved

  ## Examples

      iex> Tradehub.Trade.positions("swth1hydakm35hta8my0vkwd2dy6gu57tly39k8y9ul")

  """

  @spec positions(String.t()) :: {:ok, list(Tradehub.position())} | {:error, HTTPoison.Error.t()}
  @spec positions!(String.t()) :: list(Tradehub.position())

  @doc deprecated: "The API does not well documetation, and I do not have much info about this endpoint"

  def positions(account) do
    case Tradehub.get("get_positions", params: %{account: String.downcase(account)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:positions, account)

  @doc """
  Get positions sorted by size of the given market.

  ## Examples

      iex> Tradehub.Trade.positions_sorted_size("swth_eth1")

  """

  @doc deprecated: "The API is not well documentation"

  @spec positions_sorted_size(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, any}
  @spec positions_sorted_size!(String.t()) :: any

  def positions_sorted_size(market) do
    case Tradehub.get("get_positions_sorted_by_size", params: %{market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:positions_sorted_size, market)

  @doc """
  Get positions sorted by risk of the given market.

  ## Examples

      iex> Tradehub.Trade.positions_sorted_risk("swth_eth1", "unknown")

  """

  @doc deprecated: "The API is not well documentation"

  @spec positions_sorted_risk(String.t(), String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, any}
  @spec positions_sorted_risk!(String.t(), String.t()) :: any

  def positions_sorted_risk(market, direction) do
    case Tradehub.get("get_positions_sorted_by_risk", params: %{market: String.downcase(market), direction: direction}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:positions_sorted_risk, market, direction)

  @doc """
  Get positions sorted by pnl of the given market.

  ## Examples

      iex> Tradehub.Trade.positions_sorted_pnl("swth_eth1")

  """

  @doc deprecated: "The API is not well documentation"

  @spec positions_sorted_pnl(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, any}
  @spec positions_sorted_pnl!(String.t()) :: any

  def positions_sorted_pnl(market) do
    case Tradehub.get("get_positions_sorted_by_pnl", params: %{market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:positions_sorted_pnl, market)

  @doc """
  Requests the position of the given account in a particular market

  ## Examples

      iex> Tradehub.Trade.position("swth1hydakm35hta8my0vkwd2dy6gu57tly39k8y9ul", "swth_eth1")

  """

  @spec position(String.t(), String.t()) :: {:ok, Tradehub.position()} | {:error, HTTPoison.Error.t()}
  @spec position!(String.t(), String.t()) :: Tradehub.position()

  def position(account, market) do
    case Tradehub.get("get_position", params: %{account: String.downcase(account), market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:position, account, market)

  @doc """
  Get leverage of the given account in a specific market

  ## Examples

      iex> Tradehub.Trade.leverage("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du", "eth_h21")

  """

  @spec leverage(String.t(), String.t()) :: {:ok, Tradehub.leverage()} | {:error, HTTPoison.Error.t()}
  @spec leverage!(String.t(), String.t()) :: Tradehub.leverage()

  def leverage(account, market) do
    case Tradehub.get("get_leverage", params: %{account: String.downcase(account), market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:leverage, account, market)

  @doc """
  Requests recent trades of the market or filtered by the specific params

  ## Examples

      iex> Tradehub.Trade.trades

  """

  @typedoc """
  Query params for the `/get_trades` endpoint.

  - **market**: market ticker used by the chain, e.g `swth_eth1`
  - **before_id**: filter trades before id
  - **after_id**: filter trades after id
  - **order_by**: TODO
  - **limit**: limit the responsed results, max is 200

  """
  @type trade_options :: %{
          market: String.t(),
          before_id: String.t(),
          after_id: String.t(),
          order_by: String.t(),
          limit: String.t()
        }

  @spec trades(%{}) :: {:ok, list(Tradehub.trade())} | {:error, HTTPoison.Error.t()}
  @spec trades(trade_options()) :: {:ok, list(Tradehub.trade())} | {:error, HTTPoison.Error.t()}
  @spec trades!(trade_options()) :: list(Tradehub.trade())

  def trades(trade_options \\ %{}) do
    case Tradehub.get("get_trades", params: trade_options) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:trades)
  raising(:trades, trade_options)

  @doc """
  Requests recent trades by the given account

  ## Examples

      iex> Tradehub.Trade.trades_by_account("swth1hydakm35hta8my0vkwd2dy6gu57tly39k8y9ul")

  """

  @typedoc """
  Query params for the `/get_trades_by_account` endpoint.

  - **before_id**: filter trades before id
  - **after_id**: filter trades after id
  - **order_by**: TODO
  - **limit**: limit the responsed results, max is 200

  """
  @type trade_account_options :: %{
          before_id: String.t(),
          after_id: String.t(),
          order_by: String.t(),
          limit: String.t()
        }

  @spec trades_by_account(String.t(), %{}) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}
  @spec trades_by_account(String.t(), trade_account_options()) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}
  @spec trades_by_account!(String.t(), trade_account_options()) ::
          list(Tradehub.account_trade())

  def trades_by_account(account, trade_account_options \\ %{}) do
    case Tradehub.get("get_trades_by_account", params: Map.put(trade_account_options, :account, account)) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:trades_by_account, account)
  raising(:trades_by_account, account, trade_account_options)

  @doc """
  Requests recent liquidations

  ## Examples

      iex> Tradehub.Trade.liquidations

  """

  @typedoc """
  Query params for the `/get_liquidations` endpoint.

  - **before_id**: filter trades before id
  - **after_id**: filter trades after id
  - **order_by**: TODO
  - **limit**: limit the responsed results, max is 200

  """
  @type liquidation_options :: %{
          before_id: String.t(),
          after_id: String.t(),
          order_by: String.t(),
          limit: String.t()
        }

  @spec liquidations(%{}) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}
  @spec liquidations(liquidation_options()) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}
  @spec liquidations!(liquidation_options()) ::
          list(Tradehub.account_trade())

  def liquidations(before_id \\ nil, after_id \\ nil, order_by \\ nil, limit \\ nil) do
    case Tradehub.get("get_liquidations",
           params: %{before_id: before_id, after_id: after_id, order_by: order_by, limit: limit}
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:liquidations)
  raising(:liquidations, liquidation_options)
end
