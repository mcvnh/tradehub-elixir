defmodule Tradehub.Tx.MsgCancelOrder do
  use Tradehub.Tx.Type

  def type, do: "order/MsgCancelOrder"

  @type t :: %__MODULE__{
          id: String.t(),
          originator: String.t()
        }

  defstruct [:id, :originator]

  def validate!(message) do
    if blank?(message.id), do: raise("Order ID is required")
    if blank?(message.id), do: raise("Originator is required")

    message
  end
end
