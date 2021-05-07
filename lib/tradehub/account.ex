defmodule Tradehub.Account do
  @moduledoc """
  This module enable a power to help developers interacting with public endpoints that focusing
  on the account and profile information.
  """

  import Tradehub.Raising

  @doc """
  Request information about the given `account`.

  This endpoint returns numbers which are NOT human readable values. Consider `base_precision` and
  `quote_precision` to calculate a multiplication factor = 10 ^ (`base_precision` - `quote_precisions`).

  ## Examples

      iex> Tradehub.Account.account("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      {:ok,
        %{
          height: "0",
          result: %{
            type: "cosmos-sdk/Account",
            value: %{
              account_number: "0",
              address: "",
              coins: [],
              public_key: nil,
              sequence: "0"
            }
          }
        }}

  """

  @spec account(any) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.account()}
  @spec account!(any) :: Tradehub.account()

  def account(account) do
    case Tradehub.get("get_account", params: %{account: account}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:account, account)

  @doc """
  Get profile from a TradeHub Wallet.

  ## Examples

      iex> Tradehub.Account.profile("tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t")
      {:ok,
        %{
          address: "tswth174cz08dmgluavwcz2suztvydlptp4a8f8t5h4t",
          last_seen_block: "0",
          last_seen_time: "1970-01-01T00:00:00Z",
          twitter: "",
          username: ""
        }}

  """

  @spec profile(Tradehub.address()) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.profile()}
  @spec profile!(Tradehub.address()) :: Tradehub.profile()

  def profile(account) do
    case Tradehub.get("get_profile", params: %{account: account}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:profile, account)

  @doc ~S"""
  Request the wallet address which is represented by a username.

  If no address is found an exception with status code 404 will be raised.

  ## Examples

      iex> Tradehub.Account.address("tradehub")
      {:ok, "\n"}

  """

  @spec address(Tradehub.text()) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.address()}
  @spec address!(Tradehub.text()) :: Tradehub.address()

  def address(username) do
    case Tradehub.get("get_address", params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:address, username)

  @doc """
  Check if the given `username` has been taken.

  ## Examples

      iex> Tradehub.Account.username?("tradehub")
      false

  """

  @spec username?(Tradehub.text()) :: boolean()

  def username?(username) do
    case Tradehub.get("username_check", params: %{username: username}) do
      {:ok, response} -> response.body
      _ -> false
    end
  end
end
