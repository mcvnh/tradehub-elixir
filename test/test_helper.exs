ExUnit.start()

defmodule TradehubTest.NetTimeoutMock do
  @moduledoc false

  use HTTPoison.Base

  def process_response_body(_body) do
    {:error, :timeout}
  end

  def process_request_options(options) do
    options ++ [timeout: 0, recv_timeout: 0]
  end
end
