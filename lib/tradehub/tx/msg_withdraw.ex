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

  def validate(params) do
    {:ok, params}
  end
end
