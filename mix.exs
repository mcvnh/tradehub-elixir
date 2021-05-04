defmodule Tradehub.MixProject do
  use Mix.Project

  def project do
    [
      name: "Tradehub",
      app: :tradehub,
      description: "Tradehub SDK for Elixir",
      version: "0.1.4",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
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
      extra_applications: [:logger, :httpoison, :websockex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8.0"},
      {:jason, "~> 1.2.2"},
      {:websockex, "~> 0.4.3"},
      {:phoenix_pubsub, "~> 2.0"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
end
