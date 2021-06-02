defmodule TradehubTest.StatisticsTest do
  use ExUnit.Case, async: false
  doctest Tradehub.Statistics

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
end
