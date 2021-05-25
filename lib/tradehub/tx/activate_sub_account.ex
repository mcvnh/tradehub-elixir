defmodule Tradehub.Tx.ActivateSubAccount do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "subaccount/MsgActivateSubAccountV1"

  # TODO
  @type t :: %__MODULE__{
          expected_main_account: String.t(),
          originator: String.t()
        }

  defstruct [:expected_main_account, :originator]

  def validate!(message) do
    if blank?(message.expected_main_account), do: raise(MsgInvalid, message: "Expected main account is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
