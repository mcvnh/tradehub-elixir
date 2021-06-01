defmodule Tradehub.Tx.CreateValidator do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type description :: %{
          moniker: String.t(),
          identity: String.t(),
          website: String.t(),
          details: String.t()
        }

  @type commission :: %{
          rate: String.t(),
          max_rate: String.t(),
          max_rate_change: String.t()
        }

  @type t :: %__MODULE__{
          description: description(),
          commission: commission(),
          min_self_delegation: String.t(),
          delegator_address: String.t(),
          validator_address: String.t(),
          pubkey: String.t(),
          value: Tradehub.amount()
        }

  defstruct description: %{},
            commission: %{},
            min_self_delegation: nil,
            delegator_address: nil,
            validator_address: nil,
            pubkey: nil,
            value: nil

  @spec type :: String.t()
  def type, do: "cosmos-sdk/MsgCreateValidator"

  def validate!(message) do
    if blank?(message.description), do: raise(MsgInvalid, message: "Description is required")
    if blank?(message.description.monkier), do: raise(MsgInvalid, message: "Monkier is required")
    if blank?(message.description.identify), do: raise(MsgInvalid, message: "Identify is required")
    if blank?(message.description.website), do: raise(MsgInvalid, message: "Website is required")
    if blank?(message.description.details), do: raise(MsgInvalid, message: "Description details is required")

    if blank?(message.commission), do: raise(MsgInvalid, message: "Commission is required")
    if blank?(message.commission.rate), do: raise(MsgInvalid, message: "Commission is required")
    if blank?(message.commission.max_rate), do: raise(MsgInvalid, message: "Commission is required")
    if blank?(message.commission.max_rate_change), do: raise(MsgInvalid, message: "Commission is required")

    if blank?(message.min_self_delegation), do: raise(MsgInvalid, message: "Min self delegation is required")
    if blank?(message.delegator_address), do: raise(MsgInvalid, message: "Delegator address is required")
    if blank?(message.validator_address), do: raise(MsgInvalid, message: "Validator address is required")
    if blank?(message.pubkey), do: raise(MsgInvalid, message: "Public key is required")

    if blank?(message.value), do: raise(MsgInvalid, message: "Value is required")
    if blank?(message.value.amount), do: raise(MsgInvalid, message: "Amount is required")
    if blank?(message.value.denom), do: raise(MsgInvalid, message: "Denom is required")

    message
  end
end
