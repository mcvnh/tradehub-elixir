defmodule Tradehub.MixProject do
  use Mix.Project

  @source_url "https://github.com/anhmv/tradehub-elixir"
  @version "0.1.16"

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
    autostart_ws = Application.fetch_env!(:tradehub, :autostart_websocket)

    extra_applications = [:logger, :crypto, :httpoison, :websockex, :libsecp256k1]
    mod = if autostart_ws, do: {Tradehub.App, []}, else: []

    [
      mod: mod,
      extra_applications: extra_applications
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libsecp256k1, ">= 0.1.10"},
      {:basefiftyeight, "~> 0.1.0"},
      {:pbkdf2_elixir, ">= 1.3.0"},
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
        Authenticated: [
          Tradehub.Tx,
          Tradehub.Tx.ActivateSubAccount,
          Tradehub.Tx.AddLiquidity,
          Tradehub.Tx.CancelAllOrders,
          Tradehub.Tx.CancelOrder,
          Tradehub.Tx.ClaimPoolRewards,
          Tradehub.Tx.CreateOrder,
          Tradehub.Tx.CreateSubAccount,
          Tradehub.Tx.CreateValidator,
          Tradehub.Tx.DelegateTokens,
          Tradehub.Tx.EditOrder,
          Tradehub.Tx.RedelegatingTokens,
          Tradehub.Tx.RemoveLiquidity,
          Tradehub.Tx.SendToken,
          Tradehub.Tx.SetLeverage,
          Tradehub.Tx.SetMargin,
          Tradehub.Tx.StakePoolToken,
          Tradehub.Tx.Type,
          Tradehub.Tx.UnbondingTokens,
          Tradehub.Tx.UnstakePoolToken,
          Tradehub.Tx.UpdateProfile,
          Tradehub.Tx.Validator,
          Tradehub.Tx.Withdraw,
          Tradehub.Tx.WithdrawDelegatorRewards
        ],
        Public: [
          Tradehub.Exchange,
          Tradehub.Fee,
          Tradehub.Protocol,
          Tradehub.Statistics,
          Tradehub.Ticker,
          Tradehub.Trade
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
