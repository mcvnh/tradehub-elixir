defmodule Tradehub.Tx.EditOrder do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
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
    if blank?(message.id), do: raise(MsgInvalid, message: "Order ID is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
