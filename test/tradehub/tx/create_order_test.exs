defmodule TradehubTest.Tx.CreateOrderTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.CreateOrder

  import Tradehub.Tx.CreateOrder

  setup do
    {
      :ok,
      limit: %CreateOrder{
        market: "swth_eth1",
        side: :buy,
        quantity: "1",
        price: "100",
        type: :limit,
        originator: "tswth"
      },
      market: %CreateOrder{
        market: "swth_eth1",
        side: :buy,
        quantity: "1",
        type: :market,
        originator: "tswth"
      },
      stop_limit: %CreateOrder{
        market: "swth_eth1",
        side: :buy,
        quantity: "1",
        type: :"stop-limit",
        price: "100",
        stop_price: "105",
        trigger_type: "unknown",
        originator: "tswth"
      },
      stop_market: %CreateOrder{
        market: "swth_eth1",
        side: :buy,
        quantity: "1",
        type: :"stop-market",
        trigger_type: "unknown",
        originator: "tswth"
      }
    }
  end

  # test "expects failure when missing market", %{payload: payload} do
  #   assert_raise MsgInvalid, fn ->
  #     validate!(%{payload | market: nil})
  #   end
  # end

  # test "expects failure when missing margin", %{payload: payload} do
  #   assert_raise MsgInvalid, fn ->
  #     validate!(%{payload | margin: nil})
  #   end
  # end

  test "expects failure when missing market", %{limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | market: ""})
    end
  end

  test "expects failure when market does not in downcase", %{limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | market: "Swth_Eth1"})
    end
  end

  test "expects failure when missing side", %{limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | side: nil})
    end
  end

  test "expects failure when missing price", %{limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | price: nil})
    end
  end

  test "expects failure when missing stop price for stop limit order", %{stop_limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | stop_price: nil})
    end
  end

  test "expects failure when missing trigger type for stop limit order", %{stop_limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | trigger_type: nil})
    end
  end

  test "expects failure when missing trigger type for stop market order", %{stop_market: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | trigger_type: nil})
    end
  end

  test "expects failure when missing order type", %{limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | type: nil})
    end
  end

  test "expects failure when missing originator", %{limit: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | originator: ""})
    end
  end

  test "expects return the given message if validate success on limit order", %{limit: payload} do
    assert validate!(payload) == payload
  end

  test "expects return the given message if validate success on market order", %{market: payload} do
    assert validate!(payload) == payload
  end

  test "expects return the given message if validate success on stop-limit order", %{stop_limit: payload} do
    assert validate!(payload) == payload
  end

  test "expects return the given message if validate success on stop-market order", %{stop_market: payload} do
    assert validate!(payload) == payload
  end
end
