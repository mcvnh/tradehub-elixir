defmodule Tradehub.Fee do
  @moduledoc """
  The utility module to request information about transaction fees
  """

  import Tradehub.Raising

  @doc """
  Requests a lists of transaction fees that been configured for particular message types

  ## Examples

      iex> Tradehub.Fee.txns_fees

      iex> Tradehub.Fee.txns_fees!

  """

  @spec txns_fees :: {:ok, Tradehub.txns_fees()} | {:error, HTTPoison.Error.t()}
  @spec txns_fees! :: Tradehub.txns_fees()

  def txns_fees do
    case Tradehub.get("get_txns_fees") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:txns_fees)

  @doc """
  Requests the current fees of the given withdrawal token denom.

  ## Examples

      iex> Tradehub.Fee.current_fee("swth")

      iex> Tradehub.Fee.current_fee!("swth")

  """

  @spec current_fee(denom :: String.t()) :: {:ok, Tradehub.withdrawal_fee()} | {:error, HTTPoison.Error.t()}
  @spec current_fee!(denom :: String.t()) :: Tradehub.withdrawal_fee()

  def current_fee(withdrawal_token) do
    case HTTPoison.get("https://fees.switcheo.org/fees", [], params: %{denom: String.downcase(withdrawal_token)}) do
      {:ok, response} -> {:ok, response.body |> Jason.decode!(keys: :atoms)}
      other -> other
    end
  end

  raising(:current_fee, withdrawal_token)
end
