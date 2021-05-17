defmodule Tradehub.Tx.MsgEditOrder do
  use Tradehub.Tx.Type

  def type, do: "order/MsgEditOrder"

  @type t :: %__MODULE__{
          id: String.t(),
          quantity: String.t(),
          price: String.t(),
          stop_price: String.t(),
          originator: String.t()
        }

  defstruct [:id, :quantity, :price, :stop_price, :originator]

  def validate(params) do
    {:ok, params}
  end
end
