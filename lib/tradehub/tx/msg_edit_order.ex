defmodule Tradehub.Tx.MsgEditOrder do
  use Tradehub.Tx.Type

  def type, do: "order/MsgEditOrder"

  # TODO
  @type t :: %__MODULE__{
          id: String.t(),
          quantity: String.t(),
          price: String.t(),
          stop_price: String.t(),
          originator: String.t()
        }

  defstruct [:id, :quantity, :price, :stop_price, :originator]

  def validate!(message) do
    if blank?(message.id), do: raise("Order ID is required")

    if blank?(message.originator), do: raise("Originator is required")

    message
  end
end
