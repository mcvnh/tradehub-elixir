defmodule Tradehub.Tx.AddLiquidity do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          pool_id: String.t(),
          amount_a: String.t(),
          amount_b: String.t(),
          min_shares: String.t(),
          originator: String.t()
        }

  defstruct [
    :pool_id,
    :amount_a,
    :amount_b,
    :min_shares,
    :originator
  ]

  @spec type :: String.t()
  def type, do: "liquiditypool/AddLiquidity"

  def validate!(message) do
    if blank?(message.pool_id), do: raise(MsgInvalid, message: "Pool ID is required")
    if blank?(message.amount_a), do: raise(MsgInvalid, message: "Amount A is required")
    if blank?(message.amount_b), do: raise(MsgInvalid, message: "Amount B is required")
    if blank?(message.min_shares), do: raise(MsgInvalid, message: "Min shares is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
