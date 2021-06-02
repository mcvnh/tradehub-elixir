defmodule Tradehub.Statistics do
  @moduledoc """
  This module uses to fetch profits information of the chain.
  """

  import Tradehub.Raising

  @doc """
  Get rich list of a specific token

  ## Examples

      iex> Tradehub.Statistics.rich_list!("swth")

  """

  @spec rich_list(String.t()) :: {:ok, list(Tradehub.rich_holder())} | {:error, HTTPoison.Error.t()}
  @spec rich_list!(String.t()) :: list(Tradehub.rich_holder())

  def rich_list(token) do
    case Tradehub.get("get_rich_list", params: %{token: token}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:rich_list, token)

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
