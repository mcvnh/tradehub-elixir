defmodule Tradehub.Tx.MsgCancelOrder do
  use Tradehub.Tx.Type

  def type, do: "order/MsgCancelOrder"

  @type t :: %__MODULE__{
          id: String.t(),
          originator: String.t()
        }

  defstruct [:id, :originator]

  def validate!(message) do
    if blank?(message.id), do: raise(Tradehub.Tx.MsgInvalid, message: "Order ID is required")
    if blank?(message.originator), do: raise(Tradehub.Tx.MsgInvalid, message: "Originator is required")

    message
  end
end
