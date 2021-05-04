defmodule Tradehub.Test do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    Phoenix.PubSub.subscribe(Tradehub.PubSub, "market_stats")
    {:ok, state}
  end

  def handle_info(%{channel: "market_stats", result: result}, state) do
    IO.inspect(result)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    IO.puts("DEFAULT")
    {:noreply, state}
  end
end
