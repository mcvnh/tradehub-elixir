defmodule Tradehub.Tx.CancelOrder do
  @moduledoc """
  Cancel order
  """

  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "order/MsgCancelOrder"

  @type t :: %__MODULE__{
          id: String.t(),
          originator: String.t()
        }

  defstruct [:id, :originator]

  def validate!(message) do
    if blank?(message.id), do: raise(MsgInvalid, message: "Order ID is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
