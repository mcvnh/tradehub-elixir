defmodule Tradehub.Tx.Validator do
  @callback validate(term()) :: {:ok, term()}
  @callback type :: String.t()
end
