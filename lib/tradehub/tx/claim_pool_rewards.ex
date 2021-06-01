defmodule Tradehub.Tx.ClaimPoolRewards do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          pool_id: String.t(),
          originator: String.t()
        }

  defstruct [
    :pool_id,
    :originator
  ]

  @spec type :: String.t()
  def type, do: "liquiditypool/ClaimPoolRewards"

  def validate!(message) do
    if blank?(message.pool_id), do: raise(MsgInvalid, message: "Pool ID is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
