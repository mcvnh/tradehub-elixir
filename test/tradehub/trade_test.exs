defmodule TradehubTest.TradeTest do
  use ExUnit.Case, async: false
  doctest Tradehub.Trade

  setup do
    env = Application.get_all_env(:tradehub)
    on_exit(fn -> Application.put_all_env([{:tradehub, env}]) end)
  end

  test "expect failures" do
    Application.put_env(:tradehub, :http_client, TradehubTest.NetTimeoutMock)

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.get_orders!("")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.get_order!("")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.positions!("")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.positions_sorted_size!("swth_eth1")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.positions_sorted_risk!("swth_eth1", "")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.positions_sorted_pnl!("swth_eth1")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.position!("", "swth_eth1")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.position!("", "swth_eth1")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.leverage!("", "swth_eth1")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.trades!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.trades_by_account!("")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Trade.liquidations!()
    end
  end
end
