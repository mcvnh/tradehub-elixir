defmodule Tradehub.Tx.Type do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import Tradehub.Tx.Validator

      @behaviour Tradehub.Tx.Validator

      @spec validate!(__MODULE__.t()) :: __MODULE__.t()
      @spec compose(map()) :: map()

      def compose(payload) do
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
