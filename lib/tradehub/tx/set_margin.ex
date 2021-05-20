defmodule Tradehub.Tx.SetMargin do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "leverage/MsgSetMargin"

  @type t :: %__MODULE__{
          market: String.t(),
          margin: String.t(),
          originator: String.t()
        }

  defstruct [:market, :margin, :originator]

  def validate!(message) do
    if blank?(message.market), do: raise(MsgInvalid, message: "Market is required")
    if blank?(message.margin), do: raise(MsgInvalid, message: "Margin is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
