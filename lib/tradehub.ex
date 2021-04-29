defmodule Tradehub do
  @moduledoc """
  Documentation for `Tradehub`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Tradehub.hello()
      :world

  """
  def hello do
    :world
  end

  def test do
    net = Application.fetch_env!(:tradehub, :mainnet)
    endpoint = Application.fetch_env!(:tradehub, :public_exchange_tokens)
    HTTPoison.get!("#{net}#{endpoint}")
  end
end
