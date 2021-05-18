defmodule TradehubTest.Tx.MsgCancelAllOrdersTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.MsgCancelAllOrders

  import Tradehub.Tx.MsgCancelAllOrders

  test "expects failure when missing market" do
    assert_raise MsgInvalid, fn ->
      validate!(%MsgCancelAllOrders{originator: "tswth"})
    end
  end

  test "expects failure when missing originator" do
    assert_raise MsgInvalid, fn ->
      validate!(%MsgCancelAllOrders{market: "swth_eth1"})
    end
  end

  test "expects return the given message if validate success" do
    payload = %{market: "swth_eth1", originator: "tswth"}
    assert validate!(payload) == payload
  end
end
