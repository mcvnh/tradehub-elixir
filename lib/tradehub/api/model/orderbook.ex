defmodule Tradehub.Model.Orderbook do
  @derive Jason.Encoder
  defstruct asks: [],
            bids: []
end
