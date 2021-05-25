defmodule Tradehub.Tx.CreateSubAccount do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "subaccount/MsgCreateSubAccountV1"

  # TODO
  @type t :: %__MODULE__{
          sub_address: String.t(),
          originator: String.t()
        }

  defstruct [:sub_address, :originator]

  def validate!(message) do
    if blank?(message.sub_address), do: raise(MsgInvalid, message: "Sub address is required")
    if blank?(message.originator), do: raise(MsgInvalid, message: "Originator is required")

    message
  end
end
