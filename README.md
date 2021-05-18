# Tradehub

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![.github/workflows/main.yml](https://github.com/anhmv/tradehub-elixir/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/anhmv/tradehub-elixir/actions/workflows/main.yml)
[![Coverage Status](https://coveralls.io/repos/github/anhmv/tradehub-elixir/badge.svg?branch=master)](https://coveralls.io/github/anhmv/tradehub-elixir?branch=master)
[![Hex pm](https://img.shields.io/hexpm/v/tradehub.svg?style=flat)](https://hex.pm/packages/tradehub)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/tradehub.svg?style=flat)](https://hex.pm/packages/tradehub)

---

Tradehub Elixir is an API wrapper package written for the Elixir language.
Its purpose is to provide an easy way to help Elixir developers can interact with all aspects of the Tradehub blockchain

> The code found in this repository is unaudited and incomplete. I do not responsible for any losses incurred when using this code.

## General

Switcheo Tradehub is a blockchain protocol built on top of [Tendermint](https://tendermint.com) which allows for fair,
efficient, and transparent trading on platforms such as Demex. The protocol designed to allow anyone to create a market
for any underlying. Head over to its [landing page](https://www.switcheo.com/), and its official
[API documetation](https://docs.switcheo.org) for more details.

Go to [Tradehub Faucet](https://t.me/the_tradehub_bot) get receive free Testnet tokens.

## Installation

The package can be installed by adding `tradehub` to your dependencies in `mix.exs`.

``` elixir
def deps do
  [
    {:tradehub, "~> 0.1.10"}
  ]
end
```

## Basic Usage

Configure Tradehub network in your `config.exs`.

``` elixir
config :tradehub,
  network: :testnet # :mainnet
  rest: "https://tradescan.switcheo.org/", # default
  ws: "wss://ws.dem.exchange/ws" # default
  wallet: '[YOUR_MNEMONIC]'
```

Make a simple REST call to get the block time of the chain.

``` elixir
iex(1)> Tradehub.Protocol.block_time
```

Get information of a wallet.

``` elixir
iex(1)> wallet = Tradehub.Wallet.from_mnemonic! Application.fetch_env!(:tradehub, :wallet)
iex(2)> wallet
...(2)> |> Map.get(:address)
...(2)> |> Tradehub.Account.account!
```

``` elixir
%{
  height: "468693",
  result: %{
    type: "cosmos-sdk/Account",
    value: %{
      account_number: "24",
      address: "tswth17y4r3p4dvzrvml3fqe5p05l7y077e4cy8s7ruj",
      coins: [
        %{amount: "100000000", denom: "btc"},
        %{amount: "100000000000000000000", denom: "eth"},
        %{amount: "1000000000000", denom: "iusd"},
        %{amount: "99997200000000", denom: "swth"}
      ],
      public_key: %{
        type: "tendermint/PubKeySecp256k1",
        value: "AnYEQWwhUipTNb6ivNbW1E7SVnmndkC4DHf9UzozeEPx"
      },
      sequence: "28"
    }
  }
}
```

## Websocket

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
  * [x] Handling of authentication
  * [ ] Private endpoints <- doing
