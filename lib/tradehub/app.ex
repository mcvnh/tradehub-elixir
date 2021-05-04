defmodule Tradehub.App do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {
        Phoenix.PubSub,
        name: Tradehub.PubSub, adapter_name: Phoenix.PubSub.PG2
      },
      Tradehub.Stream
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
