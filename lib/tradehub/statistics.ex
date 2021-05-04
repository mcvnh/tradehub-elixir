defmodule Tradehub.Statistics do
  @doc """
  Get rich list of a specific token
  """

  @spec rich_list(String.t()) :: {:ok, list(Tradehub.rich_holder())} | {:error, HTTPoison.Error.t()}

  def rich_list(token) do
    case Tradehub.get(Application.fetch_env!(:tradehub, :public_statistics_rich_list), params: %{token: token}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get top returns profit of the given market
  """

  @spec top_r_profits(String.t()) :: {:ok, String.t()}

  @doc deprecated: "This function is not working yet"
  def top_r_profits(market) do
    {:ok, market}
  end
end
