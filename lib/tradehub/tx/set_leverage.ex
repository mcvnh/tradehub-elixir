defmodule Tradehub.Tx.SetLeverage do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "leverage/MsgSetLeverage"

  @type t :: %__MODULE__{
          market: String.t(),
          leverage: String.t(),
          originator: String.t()
        }

  defstruct [:market, :leverage, :originator]

  def validate!(message) do
    if blank?(message.market), do: raise(MsgInvalid, message: "Market is required")
    if blank?(message.leverage), do: raise(MsgInvalid, message: "Leverage is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
