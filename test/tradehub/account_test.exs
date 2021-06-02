defmodule TradehubTest.AccountTest do
  use ExUnit.Case, async: false
  doctest Tradehub.Account

  # tswth17y4r3p4dvzrvml3fqe5p05l7y077e4cy8s7ruj

  test "GET account should returns a correct response" do
    account = Tradehub.Account.account!("tswth17y4r3p4dvzrvml3fqe5p05l7y077e4cy8s7ruj")
    assert_account!(account)
  end

  test "GET account should returns an error object if account is invalid" do
    account = Tradehub.Account.account!("tswththisoneneverexistsonthetradehubchain")

    assert String.valid?(account.error)
  end

  test "GET profile should retuens a correct response" do
    profile = Tradehub.Account.profile!("tswth17y4r3p4dvzrvml3fqe5p05l7y077e4cy8s7ruj")
    assert_profile!(profile)
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
