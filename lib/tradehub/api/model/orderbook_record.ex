defmodule Tradehub.API.Model.OrderbookRecord do
  @derive Jason.Encoder
  defstruct [
    :price,
    :quantity
  ]
end
