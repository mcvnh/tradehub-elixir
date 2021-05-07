defmodule Tradehub.MixProject do
  use Mix.Project

  def project do
    [
      name: "Tradehub",
      app: :tradehub,
      description: "Tradehub SDK for Elixir",
      version: "0.1.8",
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
      docs: [
        main: "readme",
        authors: ["Anh Mac <anhmv91@gmail.com>"],
        source_url: "https://github.com/anhmv/tradehub-elixir",
        extras: ["README.md"]
      ],
      package: [
        name: "tradehub",
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/anhmv/tradehub-elixir"}
      ]
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
end
