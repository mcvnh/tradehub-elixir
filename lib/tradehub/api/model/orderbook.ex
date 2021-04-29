defmodule Tradehub.API.Model.Orderbook do
  @derive Jason.Encoder
  defstruct asks: [],
            bids: []
end
