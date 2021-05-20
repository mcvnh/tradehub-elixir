defmodule Tradehub.Tx.SendToken do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "cosmos-sdk/MsgSend"

  @type t :: %__MODULE__{
          from_address: String.t(),
          to_address: String.t(),
          amount: list(Tradehub.amount())
        }

  defstruct [:from_address, :to_address, :amount]

  def validate!(message) do
    if blank?(message.from_address), do: raise(MsgInvalid, message: "From address is required")
    if blank?(message.to_address), do: raise(MsgInvalid, message: "To address is required")
    if blank?(message.amount), do: raise(MsgInvalid, message: "Amount is required")

    message
  end
end
