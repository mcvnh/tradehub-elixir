defmodule Tradehub.Tx.MsgSendToken do
  use Tradehub.Tx.Type

  def type, do: "cosmos-sdk/MsgSend"

  @type t :: %__MODULE__{
          from_address: String.t(),
          to_address: String.t(),
          amount: list(Tradehub.amount())
        }

  defstruct [:from_address, :to_address, :amount]

  def validate(params) do
    {:ok, params}
  end
end
