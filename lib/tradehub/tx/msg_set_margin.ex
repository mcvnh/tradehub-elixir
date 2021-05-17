defmodule Tradehub.Tx.MsgSetMargin do
  use Tradehub.Tx.Type

  def type, do: "leverage/MsgSetMargin"

  @type t :: %__MODULE__{
          market: String.t(),
          margin: String.t(),
          originator: String.t()
        }

  defstruct [:market, :margin, :originator]

  def validate(params) do
    {:ok, params}
  end
end
