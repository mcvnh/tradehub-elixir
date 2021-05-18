defmodule Tradehub.Tx.MsgWithdraw do
  use Tradehub.Tx.Type

  def type, do: "coin/MsgWithdraw"

  @type t :: %__MODULE__{
          to_address: String.t(),
          denom: String.t(),
          amount: String.t(),
          fee_amount: String.t(),
          originator: String.t()
        }

  defstruct [:to_address, :denom, :amount, :fee_amount, :originator]

  def validate!(message) do
    if blank?(message.to_address), do: raise(Tradehub.Tx.MsgInvalid, message: "To address is required")
    if blank?(message.denom), do: raise(Tradehub.Tx.MsgInvalid, message: "Denom is required")
    if blank?(message.amount), do: raise(Tradehub.Tx.MsgInvalid, message: "Amount is required")
    if blank?(message.fee_amount), do: raise(Tradehub.Tx.MsgInvalid, message: "Fee amount is required")
    if blank?(message.originator), do: raise(Tradehub.Tx.MsgInvalid, message: "Originator is required")

    message
  end
end
