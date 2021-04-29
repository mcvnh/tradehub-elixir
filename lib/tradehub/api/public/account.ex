defmodule Tradehub.API.Public.Account do
  alias Tradehub.API.Model

  @account Application.fetch_env!(:tradehub, :public_account)
  @profile Application.fetch_env!(:tradehub, :public_account_profile)
  @address Application.fetch_env!(:tradehub, :public_account_address)
  @username_check Application.fetch_env!(:tradehub, :public_account_check_username)

  def get_account!(account) do
    Tradehub.API.get!(
      @account,
      [],
      params: %{account: account}
    )
    |> Map.get(:body)
    |> Model.Account.from_response()
  end

  def get_profile(account) do
    Tradehub.API.get_one(
      @profile,
      [params: %{account: account}],
      Model.Profile
    )
  end

  def get_profile!(account) do
    Tradehub.API.get_one!(
      @profile,
      [params: %{account: account}],
      Model.Profile
    )
  end

  def get_address(username) do
    case Tradehub.API.get(@address, [], params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_address!(username) do
    Tradehub.API.get!(@address, [], params: %{username: username}).body
  end

  def check_username(username) do
    case Tradehub.API.get(@username_check, [], params: %{username: username}) do
      {:ok, response} -> {:ok, response.body}
      {:error, reason} -> {:error, reason}
    end
  end

  def check_username!(username) do
    Tradehub.API.get!(@username_check, [], params: %{username: username}).body
  end
end
