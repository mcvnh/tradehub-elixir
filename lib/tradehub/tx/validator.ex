defmodule Tradehub.Tx.Validator do
  @moduledoc false

  @callback validate(term()) :: {:ok, term()}
  @callback type :: String.t()
end
