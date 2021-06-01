defmodule Tradehub.Tx.RedelegatingTokens do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          delegator_address: String.t(),
          validator_src_address: String.t(),
          validator_dst_address: String.t(),
          amount: Tradehub.amount()
        }

  defstruct delegator_address: nil,
            validator_src_address: nil,
            validator_dst_address: nil,
            amount: nil

  @spec type :: String.t()
  def type, do: "cosmos-sdk/MsgBeginRedelegate"

  def validate!(message) do
    if blank?(message.delegator_address), do: raise(MsgInvalid, message: "Delegator address is required")
    if blank?(message.validator_src_address), do: raise(MsgInvalid, message: "Source validator address is required")
    if blank?(message.validator_dst_address), do: raise(MsgInvalid, message: "Target validator address is required")

    if blank?(message.amount), do: raise(MsgInvalid, message: "Amount is required")
    if blank?(message.amount.amount), do: raise(MsgInvalid, message: "Amount is required")
    if blank?(message.amount.denom), do: raise(MsgInvalid, message: "Denom is required")

    message
  end
end
