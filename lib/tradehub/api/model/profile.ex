defmodule Tradehub.Model.Profile do
  defstruct [
    :address,
    :last_seen_block,
    :last_seen_time,
    :twitter,
    :username
  ]

  @type t :: %__MODULE__{
          address: String.t(),
          last_seen_block: String.t(),
          last_seen_time: String.t(),
          twitter: String.t(),
          username: String.t()
        }
end
