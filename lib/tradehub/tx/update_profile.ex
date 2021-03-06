defmodule Tradehub.Tx.UpdateProfile do
  use Tradehub.Tx.Type
  alias Tradehub.Tx.MsgInvalid

  @spec type :: String.t()
  def type, do: "profile/MsgUpdateProfile"

  @type t :: %__MODULE__{
          username: String.t(),
          twitter: String.t(),
          originator: String.t()
        }

  defstruct [:username, :twitter, :originator]

  def validate!(message) do
    if blank?(message.originator), do: raise(MsgInvalid, message: "Please address a originator")

    message
  end
end
