defmodule Tradehub.Network.Mainnet do
  @moduledoc false

  use HTTPoison.Base

  def process_request_url(url) do
    "https://tradescan.switcheo.org/" <> url
  end

  def process_response_body(body) do
    body
    |> Jason.decode!(keys: :atoms!)
  end
end
