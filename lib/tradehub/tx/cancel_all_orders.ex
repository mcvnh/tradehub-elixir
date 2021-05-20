defmodule Tradehub.Tx.CancelAllOrders do
  @moduledoc """
  Cancel all orders
  """

  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "order/MsgCancelAll"

  @type t :: %__MODULE__{
          market: String.t(),
          originator: String.t()
        }

  defstruct [:market, :originator]

  def validate!(message) do
    if blank?(message.market), do: raise(MsgInvalid, message: "Market is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
