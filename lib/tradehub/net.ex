defmodule Tradehub.Net do
  @moduledoc false

  use HTTPoison.Base

  @network Application.get_env(:tradehub, :network, "https://tradescan.switcheo.org/")

  def process_request_url(url) do
    @network <> url
  end

  def process_response_body(body) do
    body
    |> decode_response()
  end

  defp decode_response(body) do
    case Jason.decode(body, keys: :atoms) do
      {:ok, data} -> data
      {:error, error} -> error.data
    end
  end
end
