defmodule Tradehub.Tx.StakePoolToken do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @type t :: %__MODULE__{
          denom: String.t(),
          amount: String.t(),
          # seconds
          duration: String.t(),
          originator: String.t()
        }

  defstruct [
    :denom,
    :amount,
    :duration,
    :originator
  ]

  @spec type :: String.t()
  def type, do: "liquiditypool/StakePoolToken"

  def validate!(message) do
    if blank?(message.denom), do: raise(MsgInvalid, message: "Denom is required")
    if blank?(message.amount), do: raise(MsgInvalid, message: "Amount is required")
    if blank?(message.duration), do: raise(MsgInvalid, message: "Duration is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
