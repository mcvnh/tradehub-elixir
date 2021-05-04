defmodule Tradehub.Net do
  @moduledoc false

  use HTTPoison.Base

  @network Application.get_env(:tradehub, :network, "https://tradescan.switcheo.org/")

  def process_request_url(url) do
    @network <> url
  end

  def process_response_body(body) do
    body
    |> Jason.decode!(keys: :atoms!)
  end
end
