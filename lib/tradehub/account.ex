defmodule Tradehub.Account do
  @moduledoc """
  This module enable a power to help developers interacting with public endpoints that focusing
  on the account and profile information.
  """

  import Tradehub.Raising

  @doc """
  Get account details of the given wallet address

  ## Examples

      iex> Tradehub.Account.account("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")

  """

  @spec account(any) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.account()} | {:ok, %{error: String.t()}}
  @spec account!(any) :: Tradehub.account() | %{error: String.t()}

  def account(account) do
    request = Tradehub.get("get_account", params: %{account: account})

    case request do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  raising(:account, account)

  @doc """
  Get profile details of the given wallet address.

  ## Examples

      iex> Tradehub.Account.profile("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")

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

      iex> Tradehub.Account.address!("tradehub_new_ver_found")
      "\n"

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

      iex> Tradehub.Account.username?("tradehub_new_ver_found")
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
