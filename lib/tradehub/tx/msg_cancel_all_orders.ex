defmodule Tradehub.Tx.MsgCancelAllOrders do
  use Tradehub.Tx.Type

  def type, do: "order/MsgCancelAll"

  @type t :: %__MODULE__{
          market: String.t(),
          originator: String.t()
        }

  defstruct [:market, :originator]

  def validate!(message) do
    if blank?(message.market), do: raise(Tradehub.Tx.MsgInvalid, message: "Market is required")
    if blank?(message.originator), do: raise(Tradehub.Tx.MsgInvalid, message: "Originator is required")

    message
  end
end
