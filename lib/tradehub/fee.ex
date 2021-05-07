defmodule Tradehub.Fee do
  @doc """
  Requests a lists of transaction fees that been configured for particular message types

  ## Examples

      iex> Tradehub.Fee.txns_fees

  """

  @spec txns_fees :: {:ok, Tradehub.txns_fees()} | {:error, HTTPoison.Error.t()}

  def txns_fees do
    case Tradehub.get("get_txns_fees") do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Requests the current fees of the given withdrawal token denom.

  ## Examples

      iex> Tradehub.Fee.current_fee("swth")

  """

  @spec current_fee(denom :: String.t()) :: {:ok, Tradehub.withdrawal_fee()} | {:error, HTTPoison.Error.t()}

  def current_fee(withdrawal_token) do
    case HTTPoison.get("https://fees.switcheo.org/fees", [], params: %{denom: String.downcase(withdrawal_token)}) do
      {:ok, response} -> {:ok, response.body |> Jason.decode!(keys: :atoms)}
      other -> other
    end
  end
end
