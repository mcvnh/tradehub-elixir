defmodule Tradehub.Tx.Type do
  defmacro __using__(_opts) do
    quote do
      @behaviour Tradehub.Tx.Validator

      @spec build(map()) :: map()
      def build(payload) do
        message =
          struct(__MODULE__, payload)
          |> validate
          |> elem(1)
          |> Map.from_struct()
          |> Map.new(fn {k, v} -> {Macro.camelize(Atom.to_string(k)), v} end)

        %{
          type: type(),
          value: message
        }
      end
    end
  end
end
