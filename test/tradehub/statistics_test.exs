defmodule TradehubTest.StatisticsTest do
  use ExUnit.Case, async: false
  doctest Tradehub.Statistics

  setup do
    env = Application.get_all_env(:tradehub)
    on_exit(fn -> Application.put_all_env([{:tradehub, env}]) end)
  end

  test "GET rich_list should returns a valid repsonse" do
    richers = Tradehub.Statistics.rich_list!("swth")

    richers
    |> Enum.each(fn x ->
      assert String.valid?(x.address)
      assert String.valid?(x.amount)
      assert String.valid?(x.denom)
      assert String.valid?(x.username)
    end)
  end

  test "expects failures" do
    Application.put_env(:tradehub, :http_client, TradehubTest.NetTimeoutMock)

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Statistics.rich_list!("swth")
    end
  end
end
