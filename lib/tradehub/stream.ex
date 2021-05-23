defmodule Tradehub.Stream do
  @moduledoc """
  This module enables a power to connect with the official Tradehub Demex websocket gateway and provides
  all functionalities described in this module.

  The module uses Phoenix PubSub to broadcast messages across the system
  """

  use WebSockex
  require Logger

  @ws Application.get_env(:tradehub, :ws, "wss://ws.dem.exchange/ws")

  @doc false
  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(state) do
    WebSockex.start_link(@ws, __MODULE__, state, name: Stream)
  end

  def handle_frame({_type, msg}, state) do
    decode_msg = Jason.decode!(msg, keys: :atoms)

    case Map.has_key?(decode_msg, :channel) do
      true ->
        Logger.debug("Received a message from the channel #{decode_msg.channel}, broadcasting the message to observers")
        Phoenix.PubSub.broadcast(Tradehub.PubSub, decode_msg.channel, decode_msg)
        {:ok, state}

      false ->
        {:ok, state}
    end
  end

  def handle_info(msg, state) do
    Logger.debug("Received non-websocket message: #{IO.inspect(msg)}")
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    Logger.debug("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end

  def handle_cast(msg, state) do
    Logger.debug("Sending frame with payload: #{msg}")
    {:reply, msg, state}
  end

  def handle_ping(ping_frame, state) do
    Logger.debug("Received a ping frame: #{IO.inspect(ping_frame)}")
    {:ok, state}
  end

  def handle_pong(pong_frame, state) do
    Logger.debug("Received a pong frame: #{IO.inspect(pong_frame)}")
    {:ok, state}
  end

  @doc """
  The utility function to subscribe into the channel, and broadcast messages if any to the `Tradehub.PubSub`
  with a specific topic name.

  ## Examples

      iex> Tradehub.Stream.subscribe("market_stats")

  """

  @spec subscribe(String.t()) :: :ok | {:error, reason :: any}

  def subscribe(channel_uri) do
    frame_content = %{
      id: channel_uri,
      method: "subscribe",
      params: %{channels: [channel_uri]}
    }

    frame = {:text, Jason.encode!(frame_content)}

    case WebSockex.send_frame(Stream, frame) do
      :ok ->
        Logger.debug("Starting subscribe messages on channel #{channel_uri}")
        :ok

      other ->
        other
    end
  end

  @doc """
  The utility function to unsubscribe an available channel

  ## Examples

      iex> Tradehub.Stream.unsubscribe("market_stats")

  """

  @spec unsubscribe(String.t()) :: :ok | {:error, reason :: any}
  def unsubscribe(channel_uri) do
    frame_content = %{
      id: channel_uri,
      method: "unsubscribe",
      params: %{channels: [channel_uri]}
    }

    frame = {:text, Jason.encode!(frame_content)}

    case WebSockex.send_frame(Stream, frame) do
      :ok ->
        Logger.debug("Stopping subscribe messages on channel #{channel_uri}")
        :ok

      other ->
        other
    end
  end

  @doc """
  Subscribes to the `account_trades.[account]` channel to request upto 100 trades of the given account.

  A topic named `account_trades.[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "account_trades.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.account_trades("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "account_trades.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec account_trades(String.t()) :: :ok | {:error, reason :: any}

  def account_trades(account), do: subscribe("account_trades.#{account}")

  @doc """
  Subscribes to the `account_trades_by_market.[market].[account]` channel to request trades of the given account within a market.

  A topic named `account_trades_by_market.[market].[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "account_trades_by_market.swth_eth1.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.account_trades_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "account_trades.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec account_trades_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def account_trades_by_market(market, account), do: subscribe("account_trades_by_market.#{market}.#{account}")

  @doc """
  Subscribes to the `balances.[account]` channel of the given account to request latest balance updates.

  A topic named `balances.[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "balances.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.balances("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "balances.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec balances(String.t()) :: :ok | {:error, reason :: any}

  def balances(account), do: subscribe("balances.#{account}")

  @doc """
  Subscribes to the `candlesticks.[market].[resolution]` channel to request latest candlesticks of the market in the resolution timeframe.

  A topic named `candlesticks.[market].[resolution]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "candlesticks.swth_eth1.30"
      iex> Tradehub.Stream.candlesticks("swth_eth1", 30)
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "candlesticks.swth_eth1.30"

  """

  @spec candlesticks(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def candlesticks(market, resolution), do: subscribe("candlesticks.#{market}.#{resolution}")

  @doc """
  Subscribes to the `leverages_by_market.[market].[account]` channel to request latest leverages information of the
  given account within a market.

  A topic named `leverages_by_market.[market].[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "leverages_by_market.swth_eth1.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.leverages_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "leverages_by_market.swth_eth1.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec leverages_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def leverages_by_market(market, account), do: subscribe("leverages_by_market.#{market}.#{account}")

  @doc """
  Subscribes to the `leverages.[account]` channel to request latest leverages information of the given account.

  A topic named `leverages.[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "leverages.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.leverages("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "leverages.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec leverages(String.t()) :: :ok | {:error, reason :: any}

  def leverages(account), do: subscribe("leverages.#{account}")

  @doc """
  Subscribes to the `market_stats` channel to request the latest statistics of the market.

  A topic named `market_stats` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "market_stats"
      iex> Tradehub.Stream.market_stats
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "market_stats"

  """

  @spec market_stats() :: :ok | {:error, reason :: any}

  def market_stats, do: subscribe("market_stats")

  @doc """
  Subscribes to the `books.[market]` channel to request the latest orderbook of the given market.

  A topic named `books.[market]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "books.swth_eth1"
      iex> Tradehub.Stream.books("swth_eth1")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "books.swth_eth1"

  """

  @spec books(String.t()) :: :ok | {:error, reason :: any}

  def books(market), do: subscribe("books.#{market}")

  @doc """
  Subscribes to the `orders_by_market.[market].[account]` channel to request the latest orders of the given account within
  a specific market.

  A topic named `orders_by_market.[market].[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "orders_by_market.swth_eth1.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.orders_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "orders_by_market.swth_eth1.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec orders_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def orders_by_market(market, account), do: subscribe("orders_by_market.#{market}.#{account}")

  @doc """
  Subscribes to the `orders.[account]` channel to request the latest orders of the given account.

  A topic named `orders.[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "orders.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.orders("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "orders.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec orders(String.t()) :: :ok | {:error, reason :: any}

  def orders(account), do: subscribe("orders.#{account}")

  @doc """
  Subscribes to the `positions_by_market.[market].[account]` channel to request the latest positions of the given account
  within a particular market

  A topic named `positions_by_market.[market].[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "positions_by_market.swth_eth1.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.positions_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "positions_by_market.swth_eth1.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec positions_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def positions_by_market(market, account), do: subscribe("positions.#{market}.#{account}")

  @doc """
  Subscribes to the `positions.[account]` channel to request the latest positions of the given account.

  A topic named `positions.[account]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "positions.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"
      iex> Tradehub.Stream.positions("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "positions.tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t"

  """

  @spec positions(String.t()) :: :ok | {:error, reason :: any}

  def positions(account), do: subscribe("positions.#{account}")

  @doc """
  Subscribes to the `recent_trades.[market]` channel to request the recent trades of the given market.

  A topic named `recent_trades.[market]` in the `Tradehub.PubSub` will automatically created to
  handle incomming messages of this subscription.

  ## Examples

      iex> alias Phoenix.PubSub
      iex> PubSub.subscribe Tradehub.PubSub, "recent_trades.swth_eth1"
      iex> Tradehub.Stream.recent_trades("swth_eth1")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe "recent_trades.swth_eth1"

  """

  @spec recent_trades(String.t()) :: :ok | {:error, reason :: any}

  def recent_trades(market), do: subscribe("recent_trades.#{market}")
end
