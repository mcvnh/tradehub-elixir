defmodule Tradehub.Tx.MsgUpdateProfile do
  use Tradehub.Tx.Type

  def type, do: "profile/MsgUpdateProfile"

  @type t :: %__MODULE__{
          username: String.t(),
          twitter: String.t(),
          originator: String.t()
        }

  defstruct [:username, :twitter, :originator]

  def validate!(message) do
    if blank?(message.originator), do: raise("Please address a originator")

    message
  end
end
