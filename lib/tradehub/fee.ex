defmodule Tradehub.Fee do
  @moduledoc """
  The utility module to request information about transaction fees
  """

  import Tradehub.Raising

  @doc """
  Get a list of transaction fees that been configured for a specific message

  ## Returns

  - an object type `Tradehub.txns_fees()` as expected.
  - an error when someting goes wrong with the connection.

  ## Examples

      iex> Tradehub.Fee.txns_fees

  """

  @spec txns_fees :: {:ok, Tradehub.txns_fees()} | {:error, HTTPoison.Error.t()}
  @spec txns_fees! :: Tradehub.txns_fees()

  def txns_fees do
    request = Tradehub.get("get_txns_fees")

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:txns_fees)

  @doc """
  Get the latest fees of the given denom.

  ## Returns

  - an object type `Tradehub.withdrawal_fee()` as expected.
  - a string when the denom is invalid or something went wrong in the API side.
  - an error when someting goes wrong with the connection.

  ## Examples

      iex> Tradehub.Fee.current_fee("swth")

  """

  @spec current_fee(denom :: String.t()) ::
          {:ok, Tradehub.withdrawal_fee()} | String.t() | {:error, HTTPoison.Error.t()}
  @spec current_fee!(denom :: String.t()) :: Tradehub.withdrawal_fee() | String.t()

  def current_fee(withdrawal_token) do
    request = Tradehub.get("https://fees.switcheo.org/fees", params: %{denom: String.downcase(withdrawal_token)})

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:current_fee, withdrawal_token)
end
