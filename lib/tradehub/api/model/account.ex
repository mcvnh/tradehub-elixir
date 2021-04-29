defmodule Tradehub.API.Model.Account do
  alias Tradehub.API.Model

  defmodule CosmosAccount do
    @derive Jason.Encoder
    defstruct [
      :account_number,
      :address,
      :coins,
      :public_key_type,
      :public_key_value,
      :sequence
    ]
  end

  @derive Jason.Encoder
  defstruct [
    :height,
    :type,
    :details
  ]

  def from_response(response) do
    height = Map.get(response, "height")
    result = Map.get(response, "result", %{})
    values = Map.get(result, "value", %{})

    details = %Tradehub.API.Model.Account.CosmosAccount{
      account_number: Map.get(values, "account_number"),
      address: Map.get(values, "address"),
      coins:
        Map.get(values, "coins", [])
        |> Enum.map(fn x ->
          %Model.Coin{
            amount: Map.get(x, "amount"),
            denom: Map.get(x, "denom")
          }
        end),
      public_key_type: Map.get(values, "public_key", %{}) |> Map.get("type"),
      public_key_value: Map.get(values, "public_key", %{}) |> Map.get("value"),
      sequence: Map.get(values, "sequence")
    }

    %Tradehub.API.Model.Account{
      height: height,
      type: Map.get(result, "type"),
      details: details
    }
  end
end
