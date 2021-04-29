defmodule Tradehub.API.Model.Coin do
  @derive Jason.Encoder
  defstruct [
    :amount,
    :denom
  ]
end
