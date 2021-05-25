defmodule Tradehub.MixProject do
  use Mix.Project

  @source_url "https://github.com/anhmv/tradehub-elixir"
  @version "0.1.14"

  def project do
    [
      name: "Tradehub",
      app: :tradehub,
      description: "Elixir wrapper for the Switcheo Tradehub API",
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Tradehub.App, []},
      extra_applications: [:logger, :crypto, :httpoison, :websockex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:pbkdf2_elixir, ">= 1.3.0"},
      {:extended_key, "~> 0.3.0"},
      {:bech32, "~> 1.0.0"},
      {:httpoison, "~> 1.8.0"},
      {:jason, "~> 1.2.2"},
      {:websockex, "~> 0.4.3"},
      {:phoenix_pubsub, "~> 2.0"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp docs do
    [
      main: "readme",
      authors: ["Anh Mac <anhmv91@gmail.com>"],
      source_url: @source_url,
      extras: ["README.md"],
      groups_for_modules: [
        Account: [Tradehub.Wallet, Tradehub.Account],
        Public: [
          Tradehub.Exchange,
          Tradehub.Fee,
          Tradehub.Trade,
          Tradehub.Ticker,
          Tradehub.Statistics,
          Tradehub.Protocol
        ],
        Authenticated: [
          Tradehub.Tx,
          Tradehub.Tx.Type,
          Tradehub.Tx.Validator,
          Tradehub.Tx.CreateOrder,
          Tradehub.Tx.EditOrder,
          Tradehub.Tx.CancelOrder,
          Tradehub.Tx.CancelAllOrders,
          Tradehub.Tx.SetLeverage,
          Tradehub.Tx.SetMargin,
          Tradehub.Tx.SendToken,
          Tradehub.Tx.Withdraw,
          Tradehub.Tx.UpdateProfile
        ],
        WebSocket: [Tradehub.Stream]
      ]
    ]
  end

  defp package do
    [
      name: "tradehub",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
