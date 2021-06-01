defmodule Tradehub.Tx.RemoveLiquidity do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          pool_id: String.t(),
          shares: String.t(),
          originator: String.t()
        }

  defstruct [
    :pool_id,
    :shares,
    :originator
  ]

  @spec type :: String.t()
  def type, do: "liquiditypool/RemoveLiquidity"

  def validate!(message) do
    if blank?(message.pool_id), do: raise(MsgInvalid, message: "Pool ID is required")
    if blank?(message.shares), do: raise(MsgInvalid, message: "Min shares is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
