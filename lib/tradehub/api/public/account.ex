defmodule Tradehub.Public.Account do
  @moduledoc """
  Account / Profile information
  """
  alias Tradehub.Model

  @account Application.fetch_env!(:tradehub, :public_account)
  @profile Application.fetch_env!(:tradehub, :public_account_profile)
  @address Application.fetch_env!(:tradehub, :public_account_address)
  @username_check Application.fetch_env!(:tradehub, :public_account_check_username)

  @doc """
  Request information about the given `account`.

  This endpoint returns numbers which are NOT human readable values. Consider `base_precision` and
  `quote_precision` to calculate a multiplication factor = 10 ^ (`base_precision` - `quote_precisions`).
  """
  @spec get_account(any) :: {:error, HTTPoison.Error.t()} | Tradehub.Model.Account.t()
  def get_account(account) do
    case Tradehub.get(@account, [], params: %{account: account}) do
      {:ok, response} ->
        response
        |> Map.get(:body)
        |> Model.Account.from_response()

      other ->
        other
    end
  end

  @spec get_account!(any) :: Tradehub.Model.Account.t()
  def get_account!(account) do
    Tradehub.get!(
      @account,
      [],
      params: %{account: account}
    )
    |> Map.get(:body)
    |> Model.Account.from_response()
  end

  @doc """
  Request profile information of the given `account`
  """
  @spec get_profile(any) :: {:error, HTTPoison.Error.t()} | {:ok, Model.Profile.t()}
  def get_profile(account) do
    Tradehub.get_one(
      @profile,
      [params: %{account: account}],
      Model.Profile
    )
  end

  @spec get_profile!(any) :: Model.Profile.t()
  def get_profile!(account) do
    Tradehub.get_one!(
      @profile,
      [params: %{account: account}],
      Model.Profile
    )
  end

  @doc """
  Request the wallet address which is represented by a username.

  If no address is found an exception with status code 404 will be raised.
  """
  @spec get_address(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, String.t()}
  def get_address(username) do
    case Tradehub.get(@address, [], params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec get_address!(String.t()) :: String.t()
  def get_address!(username) do
    Tradehub.get!(@address, [], params: %{username: username}).body
  end

  @doc """
  Check if the given `username` has been taken.
  """
  @spec check_username(String.t()) :: {:error, HTTPoison.Error.t()} | {:ok, boolean()}
  def check_username(username) do
    case Tradehub.get(@username_check, [], params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec check_username!(String.t()) :: boolean()
  def check_username!(username) do
    Tradehub.get!(@username_check, [], params: %{username: username}).body
  end
end
