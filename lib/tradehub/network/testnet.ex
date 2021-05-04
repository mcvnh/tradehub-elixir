defmodule Tradehub.Network.Testnet do
  @moduledoc false

  use HTTPoison.Base

  @testnet Application.fetch_env!(:tradehub, :testnet)

  def process_request_url(url) do
    @testnet <> url
  end

  def process_response_body(body) do
    body
    |> Jason.decode!(keys: :atoms!)
  end
end
