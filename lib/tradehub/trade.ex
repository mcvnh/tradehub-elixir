defmodule Tradehub.Trade do
  @moduledoc """
  This module uses to fetch trade, orders information of the chain.
  """

  @order Application.fetch_env!(:tradehub, :public_trade_order)
  @orders Application.fetch_env!(:tradehub, :public_trade_orders)
  @positions Application.fetch_env!(:tradehub, :public_trade_positions)
  @position Application.fetch_env!(:tradehub, :public_trade_position)

  @positions_sorted_size Application.fetch_env!(:tradehub, :public_trade_positions_sorted_size)
  @positions_sorted_risk Application.fetch_env!(:tradehub, :public_trade_positions_sorted_risk)
  @positions_sorted_pnl Application.fetch_env!(:tradehub, :public_trade_positions_sorted_pnl)
  @leverage Application.fetch_env!(:tradehub, :public_trade_leverage)
  @trades Application.fetch_env!(:tradehub, :public_trade_trades)
  @trades_by_account Application.fetch_env!(:tradehub, :public_trade_trades_by_account)
  @liquidations Application.fetch_env!(:tradehub, :public_trade_liquidations)

  @doc """
  Requests orders of the given account

  ## Examples

      iex> Tradehub.Trade.get_orders("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du")

  """

  @spec get_orders(String.t()) :: {:ok, list(Tradehub.order())} | {:error, HTTPoison.Error.t()}

  def get_orders(account) do
    case Tradehub.get(@orders, params: %{account: String.downcase(account)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests an order details information by its order id

  ## Examples

      iex> Tradehub.Trade.get_order("A186AC5F560BBD4B2C1F9B21C6EF1814F3295EBD863FA3655F74942CDB198530")

  """

  @spec get_order(String.t()) :: {:ok, Tradehub.order()} | {:error, HTTPoison.Error.t()}

  def get_order(order_id) do
    case Tradehub.get(@order, params: %{order_id: String.upcase(order_id)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests avaiable positions of the given account in all markets which the account get involved

  ## Examples

      iex> Tradehub.Trade.positions("swth1hydakm35hta8my0vkwd2dy6gu57tly39k8y9ul")

  """

  @spec positions(String.t()) :: {:ok, list(Tradehub.position())} | {:error, HTTPoison.Error.t()}
  @doc deprecated: "The API does not well documetation, and I do not have much info about this endpoint"

  def positions(account) do
    case Tradehub.get(@positions, params: %{account: String.downcase(account)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get positions sorted by size of the given market.

  ## Examples

      iex> Tradehub.Trade.positions_sorted_size("swth_eth1")

  """

  @spec positions_sorted_size(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, any}
  @doc deprecated: "The API is not well documentation"

  def positions_sorted_size(market) do
    case Tradehub.get(@positions_sorted_size, params: %{market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get positions sorted by risk of the given market.

  ## Examples

      iex> Tradehub.Trade.positions_sorted_risk("swth_eth1", "unknown")

  """

  @spec positions_sorted_risk(String.t(), String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, any}
  @doc deprecated: "The API is not well documentation"

  def positions_sorted_risk(market, direction) do
    case Tradehub.get(@positions_sorted_risk, params: %{market: String.downcase(market), direction: direction}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get positions sorted by pnl of the given market.

  ## Examples

      iex> Tradehub.Trade.positions_sorted_pnl("swth_eth1")

  """

  @spec positions_sorted_pnl(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, any}
  @doc deprecated: "The API is not well documentation"

  def positions_sorted_pnl(market) do
    case Tradehub.get(@positions_sorted_pnl, params: %{market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests the position of the given account in a particular market

  ## Examples

      iex> Tradehub.Trade.position("swth1hydakm35hta8my0vkwd2dy6gu57tly39k8y9ul", "swth_eth1")

  """

  @spec position(String.t(), String.t()) :: {:ok, Tradehub.position()} | {:error, HTTPoison.Error.t()}

  def position(account, market) do
    case Tradehub.get(@position, params: %{account: String.downcase(account), market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get leverage of the given account in a specific market

  ## Examples

      iex> Tradehub.Trade.leverage("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du", "eth_h21")

  """

  @spec leverage(String.t(), String.t()) :: {:ok, Tradehub.leverage()} | {:error, HTTPoison.Error.t()}

  def leverage(account, market) do
    case Tradehub.get(@leverage, params: %{account: String.downcase(account), market: String.downcase(market)}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests recent trades of the market or filtered by the specific params

  ## Parameters

  - **market**: market ticker used by the chain, e.g `swth_eth1`
  - **before_id**: filter trades before id
  - **after_id**: filter trades after id
  - **order_by**: TODO
  - **limit**: limit the responsed results, max is 200

  ## Examples

      iex> Tradehub.Trade.trades

  """

  @spec trades(nil, nil, nil, nil, nil) :: {:ok, list(Tradehub.trade())} | {:error, HTTPoison.Error.t()}
  @spec trades(String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ok, list(Tradehub.trade())} | {:error, HTTPoison.Error.t()}

  def trades(market \\ nil, before_id \\ nil, after_id \\ nil, order_by \\ nil, limit \\ nil) do
    case Tradehub.get(@trades,
           params: %{market: market, before_id: before_id, after_id: after_id, order_by: order_by, limit: limit}
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests recent trades by the given account

  ## Parameters

  - **account**: the account
  - **before_id**: filter trades before id
  - **after_id**: filter trades after id
  - **order_by**: TODO
  - **limit**: limit the responsed results, max is 200

  ## Examples

      iex> Tradehub.Trade.trades_by_account("swth1hydakm35hta8my0vkwd2dy6gu57tly39k8y9ul")

  """

  @spec trades_by_account(String.t(), nil, nil, nil, nil) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}
  @spec trades_by_account(String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}

  def trades_by_account(account, before_id \\ nil, after_id \\ nil, order_by \\ nil, limit \\ nil) do
    case Tradehub.get(@trades_by_account,
           params: %{account: account, before_id: before_id, after_id: after_id, order_by: order_by, limit: limit}
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests recent liquidations

  ## Parameters

  - **before_id**: filter trades before id
  - **after_id**: filter trades after id
  - **order_by**: TODO
  - **limit**: limit the responsed results, max is 200

  ## Examples

      iex> Tradehub.Trade.liquidations

  """

  @spec liquidations(nil, nil, nil, nil) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}
  @spec liquidations(String.t(), String.t(), String.t(), String.t()) ::
          {:ok, list(Tradehub.account_trade())} | {:error, HTTPoison.Error.t()}

  def liquidations(before_id \\ nil, after_id \\ nil, order_by \\ nil, limit \\ nil) do
    case Tradehub.get(@liquidations,
           params: %{before_id: before_id, after_id: after_id, order_by: order_by, limit: limit}
         ) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end
end
