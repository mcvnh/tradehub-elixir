defmodule Tradehub.Tx.WithdrawDelegatorRewards do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          delegator_address: String.t(),
          validator_address: String.t()
        }

  defstruct delegator_address: nil,
            validator_address: nil

  @spec type :: String.t()
  def type, do: "cosmos-sdk/MsgWithdrawDelegationReward"

  def validate!(message) do
    if blank?(message.delegator_address), do: raise(MsgInvalid, message: "Delegator address is required")
    if blank?(message.validator_address), do: raise(MsgInvalid, message: "Validator address is required")

    message
  end
end
