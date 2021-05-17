defmodule Tradehub.Tx.MsgCancelAllOrders do
  use Tradehub.Tx.Type

  def type, do: "order/MsgCancelAll"

  @type t :: %__MODULE__{
          market: String.t(),
          originator: String.t()
        }

  defstruct [:market, :originator]

  def validate(params) do
    {:ok, params}
  end
end
