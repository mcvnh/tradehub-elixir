# Tradehub

[![.github/workflows/main.yml](https://github.com/anhmv/tradehub-elixir/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/anhmv/tradehub-elixir/actions/workflows/main.yml) [![Hex pm](https://img.shields.io/hexpm/v/tradehub.svg?style=flat)](https://hex.pm/packages/tradehub) [![hex.pm downloads](https://img.shields.io/hexpm/dt/tradehub.svg?style=flat)](https://hex.pm/packages/tradehub)

---

Welcome to the Tradehub SDK for Elixir language. The goal of building this project is to empower
developers by offering an client that is easily to interact with all aspects of the Switheo Tradehub
blockchain, and the [DEMEX](https://app.dem.exchange/) decentralized exchange via its REST/Websocket endpoints.

> The code found in this repository is unaudited and incomplete. Switcheo is not responsible for any losses incurred when using this code.

## General

Switcheo Tradehub is a blockchain protocol built on top of [Tendermint](https://tendermint.com) which allows for fair, efficient, and transparent trading on platforms such as Demex. The protocol
designed to allow anyone to create a market for any underlying. Head over to its
[landing page](https://www.switcheo.com/), and its official [API documetation](https://docs.switcheo.org) more details.

Head over to [Tradehub Faucet](https://t.me/the_tradehub_bot) get receive free TestNet tokens.

## Installation

The package can be installed by adding `tradehub` to your dependencies in `mix.exs`.

``` elixir
def deps do
  [
    {:tradehub, "~> 0.1.3"}
  ]
end
```

## Basic Usage

Configure Tradehub network in your `config.exs` [OPTIONAL].

``` elixir
config :tradehub,
  network: "https://tradescan.switcheo.org/", # default value
  ws: "wss://ws.dem.exchange/ws" # default value
```

Make a simple REST call to get the block time of the chain.

``` elixir
iex(1)> Tradehub.Protocol.block_time
```

## Websocket subscribe

This example will do a subscription onto the channel `market_stats`, and print out the received messages.

``` elixir
defmodule WatchMarketStats do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  def init(stack) do
    # Start listening on the `market_stats` channel
    Tradehub.Stream.market_stats()

    # Register myself as the client to handle message from the channel
    Phoenix.PubSub.subscribe(Tradehub.PubSub, "market_stats")

    {:ok, stack}
  end

  # Handle latest message from the `market_stats` channel
  def handle_info(msg, state) do
    IO.puts("Receive message -- #{inspect(msg)}")

    {:noreply, state}
  end
end
```

``` elixir
iex(1)> WatchMarketStats.start_link {}
```

Full documentation can be found at [https://hexdocs.pm/tradehub](https://hexdocs.pm/tradehub).

## Features

* [ ] Implementation of all general information endpoints
  * [x] Public endpoints
  * [x] Websocket
  * [ ] Handling of authentication and private endpoints
