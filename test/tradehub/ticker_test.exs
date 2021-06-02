defmodule TradehubTest.TickerTest do
  use ExUnit.Case, async: false
  doctest Tradehub.Ticker

  setup do
    env = Application.get_all_env(:tradehub)
    on_exit(fn -> Application.put_all_env([{:tradehub, env}]) end)
  end

  test "GET candlestick should return a valid response body" do
    result = Tradehub.Ticker.candlesticks!("swth_eth1", 30, 161_020_300, 170_020_300)

    result
    |> Enum.each(fn x -> assert_candlestick!(x) end)
  end

  test "GET candlestick should return a string that represents an error" do
    result = Tradehub.Ticker.candlesticks!("swth_eth1", 2, 161_020_300, 161_020_300)

    assert String.valid?(result)
  end

  test "GET prices should return a valid response body" do
    result = Tradehub.Ticker.prices!("swth_eth1")

    assert_ticker_prices!(result)
  end

  test "GET prices should return a normal object although the market invalid" do
    result = Tradehub.Ticker.prices!("^.^")

    assert_ticker_prices!(result)
  end

  test "GET market_stats should returns a list of Tradehub.market_stats()" do
    result = Tradehub.Ticker.market_stats!()

    result
    |> Enum.each(fn x -> assert_market_stats!(x) end)
  end

  test "GET market_stats should returns an error message if market is invalid" do
    result = Tradehub.Ticker.market_stats!("hehehe")

    assert String.valid?(result)
  end

  test "expects failures" do
    Application.put_env(:tradehub, :http_client, TradehubTest.NetTimeoutMock)

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Ticker.candlesticks!("swth_eth1", 30, 161_020_300, 170_020_300)
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Ticker.prices!("swth_eth1")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Ticker.market_stats!()
    end
  end

  # Helper functions

  defp assert_market_stats!(obj) do
    assert String.valid?(obj.day_high)
    assert String.valid?(obj.day_low)
    assert String.valid?(obj.day_open)
    assert String.valid?(obj.day_close)
    assert String.valid?(obj.day_volume)
    assert String.valid?(obj.day_quote_volume)
    assert String.valid?(obj.index_price)
    assert String.valid?(obj.mark_price)
    assert String.valid?(obj.last_price)
    assert String.valid?(obj.market)
    assert String.valid?(obj.market_type)
    assert String.valid?(obj.open_interest)
  end

  def assert_ticker_prices!(obj) do
    assert is_integer(obj.block_height)
    assert String.valid?(obj.fair)
    assert String.valid?(obj.fair_index_delta_avg)
    assert String.valid?(obj.index)
    assert String.valid?(obj.index_updated_at)
    assert String.valid?(obj.last)
    assert String.valid?(obj.last_updated_at)
    assert String.valid?(obj.mark)
    assert String.valid?(obj.mark_avg)
    assert String.valid?(obj.market)
    assert String.valid?(obj.marking_strategy)
    assert String.valid?(obj.settlement)
  end

  def assert_candlestick!(obj) do
    assert String.valid?(obj.close)
    assert String.valid?(obj.high)
    assert String.valid?(obj.id)
    assert String.valid?(obj.low)
    assert String.valid?(obj.market)
    assert String.valid?(obj.open)
    assert String.valid?(obj.quote_volume)
    assert String.valid?(obj.resolution)
    assert String.valid?(obj.time)
    assert String.valid?(obj.volume)
  end
end
