defmodule Tradehub.Tx.Type do
  @moduledoc """
  The abstract module for type defination.
  """

  @doc """
  This function trying to validate the given payload and returns the payload itself, if no errors found.
  Or else, an `Tradehub.Tx.MsgInvalid` error will be raised.
  """

  @callback validate!(term()) :: term()

  @doc """
  Define the type of the transaction.
  """
  @callback type :: String.t()

  defmacro __using__(_opts) do
    quote do
      import Tradehub.Tx.Validator

      @behaviour Tradehub.Tx.Type

      @spec validate!(__MODULE__.t()) :: __MODULE__.t()
      @spec compose!(map()) :: Tradehub.Tx.message()

      @doc "Given the payload message as map/dictionary, validation, and convert to the raw message"
      def compose!(payload) do
        message =
          struct(__MODULE__, payload)
          |> validate!
          |> Map.from_struct()

        %{
          type: type(),
          value: message
        }
      end
    end
  end
end
