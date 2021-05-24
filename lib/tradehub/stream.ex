defmodule Tradehub.Stream do
  @moduledoc """
  This module enables a power to connect with the official Tradehub Demex websocket gateway and provides
  all functionalities described in this module.

  The module uses Phoenix PubSub to broadcast messages across the system
  """

  use WebSockex
  require Logger

  @ws Application.get_env(:tradehub, :ws, "wss://ws.dem.exchange/ws")

  defmacro __using__(opts) do
    topics = Keyword.get(opts, :topics)

    quote do
      use GenServer

      def start_link() do
        GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
      end

      def init(state) do
        unquote(topics)
        |> Enum.each(fn topic -> Tradehub.Stream.subscribe(topic) end)

        {:ok, state}
      end

      def terminate(_reason, state) do
        IO.puts("#{__MODULE__} going down...")

        unquote(topics)
        |> Enum.each(fn topic -> Tradehub.Stream.unsubscribe(topic) end)

        :normal
      end
    end
  end

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
        Phoenix.PubSub.broadcast(Tradehub.PubSub, decode_msg.channel, msg)
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
    Logger.debug("Sending #{type} frame with payload: #{IO.inspect(msg)}")
    {:reply, frame, state}
  end

  def handle_cast(msg, state) do
    Logger.debug("Sending frame with payload: #{IO.inspect(msg)}")
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

  def subscribe(topic) do
    frame_content = %{
      id: topic,
      method: "subscribe",
      params: %{channels: [topic]}
    }

    frame = {:text, Jason.encode!(frame_content)}

    case WebSockex.send_frame(Stream, frame) do
      :ok ->
        Phoenix.PubSub.subscribe(Tradehub.PubSub, topic)
        Logger.debug("Starting subscribe messages on channel #{topic}")
        topic

      other ->
        other
    end
  end

  @doc """
  The utility function to unsubscribe an available channel

  ## Examples

      iex> Tradehub.Stream.unsubscribe("market_stats")

  """

  @spec unsubscribe(topic :: String.t()) :: :ok | {:error, reason :: any}
  def unsubscribe(topic) do
    frame_content = %{
      id: topic,
      method: "unsubscribe",
      params: %{channels: [topic]}
    }

    frame = {:text, Jason.encode!(frame_content)}

    case WebSockex.send_frame(Stream, frame) do
      :ok ->
        Logger.debug("Stopping subscribe messages on channel #{topic}")
        :ok

      other ->
        other
    end
  end

  @doc """
  Subscribes to the `account_trades.[account]` channel to request upto 100 trades of the given account.

  ## Examples

      iex> topic = Tradehub.Stream.account_trades("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec account_trades(String.t()) :: :ok | {:error, reason :: any}

  def account_trades(account), do: subscribe("account_trades.#{account}")

  @doc """
  Subscribes to the `account_trades_by_market.[market].[account]` channel to request trades of the given account within a market.

  ## Examples

      iex> topic = Tradehub.Stream.account_trades_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec account_trades_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def account_trades_by_market(market, account), do: subscribe("account_trades_by_market.#{market}.#{account}")

  @doc """
  Subscribes to the `balances.[account]` channel of the given account to request latest balance updates.

  ## Examples

      iex> topic = Tradehub.Stream.balances("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec balances(String.t()) :: :ok | {:error, reason :: any}

  def balances(account), do: subscribe("balances.#{account}")

  @doc """
  Subscribes to the `candlesticks.[market].[resolution]` channel to request latest candlesticks of the market in the resolution timeframe.

  ## Examples

      iex> topic = Tradehub.Stream.candlesticks("swth_eth1", 30)
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec candlesticks(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def candlesticks(market, resolution), do: subscribe("candlesticks.#{market}.#{resolution}")

  @doc """
  Subscribes to the `leverages_by_market.[market].[account]` channel to request latest leverages information of the
  given account within a market.

  ## Examples

      iex> topic = Tradehub.Stream.leverages_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec leverages_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def leverages_by_market(market, account), do: subscribe("leverages_by_market.#{market}.#{account}")

  @doc """
  Subscribes to the `leverages.[account]` channel to request latest leverages information of the given account.

  ## Examples

      iex> topic = Tradehub.Stream.leverages("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec leverages(String.t()) :: :ok | {:error, reason :: any}

  def leverages(account), do: subscribe("leverages.#{account}")

  @doc """
  Subscribes to the `market_stats` channel to request the latest statistics of the market.

  ## Examples

      iex> topic = Tradehub.Stream.market_stats
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec market_stats() :: :ok | {:error, reason :: any}

  def market_stats, do: subscribe("market_stats")

  @doc """
  Subscribes to the `books.[market]` channel to request the latest orderbook of the given market.

  ## Examples

      iex> topic = Tradehub.Stream.books("swth_eth1")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec books(String.t()) :: :ok | {:error, reason :: any}

  def books(market), do: subscribe("books.#{market}")

  @doc """
  Subscribes to the `orders_by_market.[market].[account]` channel to request the latest orders of the given account within
  a specific market.

  ## Examples

      iex> topic = Tradehub.Stream.orders_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec orders_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def orders_by_market(market, account), do: subscribe("orders_by_market.#{market}.#{account}")

  @doc """
  Subscribes to the `orders.[account]` channel to request the latest orders of the given account.

  ## Examples

      iex> topic = Tradehub.Stream.orders("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec orders(String.t()) :: :ok | {:error, reason :: any}

  def orders(account), do: subscribe("orders.#{account}")

  @doc """
  Subscribes to the `positions_by_market.[market].[account]` channel to request the latest positions of the given account
  within a particular market

  ## Examples

      iex> topic = Tradehub.Stream.positions_by_market("swth_eth1", "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic
  """

  @spec positions_by_market(String.t(), String.t()) :: :ok | {:error, reason :: any}

  def positions_by_market(market, account), do: subscribe("positions.#{market}.#{account}")

  @doc """
  Subscribes to the `positions.[account]` channel to request the latest positions of the given account.

  ## Examples

      iex> topic = Tradehub.Stream.positions("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec positions(String.t()) :: :ok | {:error, reason :: any}

  def positions(account), do: subscribe("positions.#{account}")

  @doc """
  Subscribes to the `recent_trades.[market]` channel to request the recent trades of the given market.

  ## Examples

      iex> topic = Tradehub.Stream.recent_trades("swth_eth1")
      iex> Process.info(self(), :messages)
      iex> Tradehub.Stream.unsubscribe topic

  """

  @spec recent_trades(String.t()) :: :ok | {:error, reason :: any}

  def recent_trades(market), do: subscribe("recent_trades.#{market}")
end
