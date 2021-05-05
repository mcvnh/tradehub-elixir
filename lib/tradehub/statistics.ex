defmodule Tradehub.Statistics do
  @moduledoc """
  This module uses to fetch profits information of the chain.
  """

  @doc """
  Get rich list of a specific token

  ## Examples

      iex> Tradehub.Statistics.rich_list("swth")

  """

  @spec rich_list(String.t()) :: {:ok, list(Tradehub.rich_holder())} | {:error, HTTPoison.Error.t()}

  def rich_list(token) do
    case Tradehub.get("get_rich_list", params: %{token: token}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get top returns profit of the given market

  ## Examples

      iex> Tradehub.Statistics.top_r_profits("swth_eth1")

  """

  @spec top_r_profits(String.t()) :: {:ok, String.t()}

  @doc deprecated: "This function is not working yet"
  def top_r_profits(market) do
    {:ok, market}
  end
end
