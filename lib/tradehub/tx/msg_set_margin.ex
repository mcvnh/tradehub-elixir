defmodule Tradehub.Tx.MsgSetMargin do
  use Tradehub.Tx.Type

  def type, do: "leverage/MsgSetMargin"

  @type t :: %__MODULE__{
          market: String.t(),
          margin: String.t(),
          originator: String.t()
        }

  defstruct [:market, :margin, :originator]

  def validate!(message) do
    if blank?(message.market), do: raise(Tradehub.Tx.MsgInvalid, message: "Market is required")
    if blank?(message.margin), do: raise(Tradehub.Tx.MsgInvalid, message: "Margin is required")
    if blank?(message.originator), do: raise(Tradehub.Tx.MsgInvalid, message: "Originator is required")

    message
  end
end
