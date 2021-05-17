defmodule Tradehub.Tx.MsgCancelOrder do
  use Tradehub.Tx.Type

  def type, do: "order/MsgCancelOrder"

  @type t :: %__MODULE__{
          id: String.t(),
          originator: String.t()
        }

  defstruct [:id, :originator]

  def validate(params) do
    {:ok, params}
  end
end
