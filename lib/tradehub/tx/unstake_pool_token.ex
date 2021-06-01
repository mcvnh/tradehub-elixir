defmodule Tradehub.Tx.UnstakePoolToken do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          denom: String.t(),
          amount: String.t(),
          originator: String.t()
        }

  defstruct [
    :denom,
    :amount,
    :originator
  ]

  @spec type :: String.t()
  # TODO
  def type, do: "liquiditypool/UnstakePoolToken"

  def validate!(message) do
    if blank?(message.denom), do: raise(MsgInvalid, message: "Denom is required")
    if blank?(message.amount), do: raise(MsgInvalid, message: "Amount is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
