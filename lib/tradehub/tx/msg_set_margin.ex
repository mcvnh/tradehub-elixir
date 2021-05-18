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
    if blank?(message.market), do: raise("Market is required")
    if blank?(message.margin), do: raise("Margin is required")
    if blank?(message.originator), do: raise("Originator is required")

    message
  end
end
