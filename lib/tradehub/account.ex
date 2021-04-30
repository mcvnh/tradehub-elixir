defmodule Tradehub.Account do
  @moduledoc """
  This module enable a power to help developers interacting with public endpoints that focusing
  on the account and profile information.
  """

  @account Application.fetch_env!(:tradehub, :public_account)
  @profile Application.fetch_env!(:tradehub, :public_account_profile)
  @address Application.fetch_env!(:tradehub, :public_account_address)
  @username_check Application.fetch_env!(:tradehub, :public_account_check_username)


  @spec account(any) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.account}
  @doc """
  Request information about the given `account`.

  This endpoint returns numbers which are NOT human readable values. Consider `base_precision` and
  `quote_precision` to calculate a multiplication factor = 10 ^ (`base_precision` - `quote_precisions`).

  ## Examples

      iex> Tradehub.Account.address("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du")

  """
  def account(account) do
    case Tradehub.get(@account, params: %{account: account}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec profile(Tradehub.address) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.profile}
  @doc """
  Get profile from a TradeHub Wallet.

  ## Examples

      iex> Tradehub.Public.Account.get_profile("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du")

  """
  def profile(account) do
    case Tradehub.get(@profile, params: %{account: account}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec address(Tradehub.text) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.address}
  @doc """
  Request the wallet address which is represented by a username.

  If no address is found an exception with status code 404 will be raised.

  ## Examples

      iex> Tradehub.Account.address("tradehub")

  """
  def address(username) do
    case Tradehub.get(@address, [], params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end


  @spec username?(Tradehub.text) :: {:error, HTTPoison.Error.t()} | {:ok, boolean()}
  @doc """
  Check if the given `username` has been taken.

  ## Examples

      iex> Tradehub.Account.username?("tradehub")

  """
  def username?(username) do
    case Tradehub.get(@username_check, [], params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end
end
