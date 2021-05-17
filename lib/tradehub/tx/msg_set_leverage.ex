defmodule Tradehub.Tx.MsgSetLeverage do
  use Tradehub.Tx.Type

  def type, do: "leverage/MsgSetLeverage"

  @type t :: %__MODULE__{
          market: String.t(),
          leverage: String.t(),
          originator: String.t()
        }

  defstruct [:market, :leverage, :originator]

  def validate(params) do
    {:ok, params}
  end
end
