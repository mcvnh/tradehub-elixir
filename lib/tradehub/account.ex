defmodule Tradehub.Account do
  @moduledoc """
  This module enable a power to help developers interacting with public endpoints that focusing
  on the account and profile information.
  """

  @doc """
  Request information about the given `account`.

  This endpoint returns numbers which are NOT human readable values. Consider `base_precision` and
  `quote_precision` to calculate a multiplication factor = 10 ^ (`base_precision` - `quote_precisions`).

  ## Examples

      iex> Tradehub.Account.address("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du")

  """

  @spec account(any) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.account()}

  def account(account) do
    case Tradehub.get("get_account", params: %{account: account}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Get profile from a TradeHub Wallet.

  ## Examples

      iex> Tradehub.Account.profile("swth1945upvdn2p2sgq7muyhfmygn3fu740jw9l73du")

  """

  @spec profile(Tradehub.address()) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.profile()}

  def profile(account) do
    case Tradehub.get("get_profile", params: %{account: account}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Request the wallet address which is represented by a username.

  If no address is found an exception with status code 404 will be raised.

  ## Examples

      iex> Tradehub.Account.address("tradehub")

  """

  @spec address(Tradehub.text()) :: {:error, HTTPoison.Error.t()} | {:ok, Tradehub.address()}

  def address(username) do
    case Tradehub.get("get_address", params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end

  @doc """
  Check if the given `username` has been taken.

  ## Examples

      iex> Tradehub.Account.username?("tradehub")

  """

  @spec username?(Tradehub.text()) :: {:error, HTTPoison.Error.t()} | {:ok, boolean()}

  def username?(username) do
    case Tradehub.get("username_check", params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      other -> other
    end
  end
end
