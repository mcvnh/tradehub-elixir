defmodule TradehubTest.AccountTest do
  use ExUnit.Case, async: false
  doctest Tradehub.Account

  setup do
    env = Application.get_all_env(:tradehub)
    on_exit(fn -> Application.put_all_env([{:tradehub, env}]) end)
  end

  test "GET account should returns a correct response" do
    account = Tradehub.Account.account!("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")
    assert_account!(account)
  end

  test "GET account should returns an error object if account is invalid" do
    account = Tradehub.Account.account!("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6x")

    assert String.valid?(account.error)
  end

  test "GET profile should retuens a correct response" do
    profile = Tradehub.Account.profile!("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")
    assert_profile!(profile)
  end

  test "expects failures" do
    Application.put_env(:tradehub, :http_client, TradehubTest.NetTimeoutMock)

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Account.account!("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Account.profile!("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Account.address!("anhmv")
    end

    assert Tradehub.Account.username?("anhmv") == false
  end

  # Helper functions

  defp assert_account!(obj) do
    assert String.valid?(obj.height)
    assert String.valid?(obj.result.type)
    assert String.valid?(obj.result.value.account_number)
    assert String.valid?(obj.result.value.address)
    assert String.valid?(obj.result.value.sequence)

    assert String.valid?(obj.result.value.public_key.type)
    assert String.valid?(obj.result.value.public_key.value)

    assert is_list(obj.result.value.coins)

    obj.result.value.coins
    |> Enum.each(fn x ->
      assert String.valid?(x.amount)
      assert String.valid?(x.denom)
    end)
  end

  defp assert_profile!(obj) do
    assert String.valid?(obj.address)
    assert String.valid?(obj.last_seen_block)
    assert String.valid?(obj.last_seen_time)
    assert String.valid?(obj.twitter)
    assert String.valid?(obj.username)
  end
end
