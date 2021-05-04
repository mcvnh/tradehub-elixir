defmodule Tradehub.Network.Testnet do
  @moduledoc false

  use HTTPoison.Base

  def process_request_url(url) do
    "https://test-tradescan.switcheo.org/" <> url
  end

  def process_response_body(body) do
    body
    |> Jason.decode!(keys: :atoms!)
  end
end
