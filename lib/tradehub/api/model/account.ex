defmodule Tradehub.Model.Account do
  alias Tradehub.Model

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

    @type t :: %__MODULE__{
            account_number: String.t(),
            address: Stirng.t(),
            coins: list,
            public_key_type: String.t(),
            public_key_value: String.t(),
            sequence: String.t()
          }
  end

  @derive Jason.Encoder
  defstruct [
    :height,
    :type,
    :details
  ]

  @type t :: %__MODULE__{
          height: String.t(),
          type: String.t(),
          details: CosmosAccount.t() | any()
        }

  def from_response(response) do
    height = Map.get(response, "height")
    result = Map.get(response, "result", %{})
    values = Map.get(result, "value", %{})

    details = %Tradehub.Model.Account.CosmosAccount{
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

    %Tradehub.Model.Account{
      height: height,
      type: Map.get(result, "type"),
      details: details
    }
  end
end
