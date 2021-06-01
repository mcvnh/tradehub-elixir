defmodule Tradehub.Tx.DelegateTokens do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          delegator_address: String.t(),
          validator_address: String.t(),
          amount: Tradehub.amount()
        }

  defstruct delegator_address: nil,
            validator_address: nil,
            amount: nil

  @spec type :: String.t()
  def type, do: "cosmos-sdk/MsgDelegate"

  def validate!(message) do
    if blank?(message.delegator_address), do: raise(MsgInvalid, message: "Delegator address is required")
    if blank?(message.validator_address), do: raise(MsgInvalid, message: "Validator address is required")

    if blank?(message.amount), do: raise(MsgInvalid, message: "Amount is required")
    if blank?(message.amount.amount), do: raise(MsgInvalid, message: "Amount is required")
    if blank?(message.amount.denom), do: raise(MsgInvalid, message: "Denom is required")

    message
  end
end
