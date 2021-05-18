defmodule TradehubTest.Tx.MsgSetLeverageTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.MsgSetLeverage

  import Tradehub.Tx.MsgSetLeverage

  setup do
    {
      :ok,
      payload: %MsgSetLeverage{
        market: "swth_eth1",
        leverage: "11",
        originator: "tswth"
      }
    }
  end

  test "expects failure when missing market", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | market: nil})
    end
  end

  test "expects failure when missing leverage", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | leverage: nil})
    end
  end

  test "expects failure when originator", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | originator: ""})
    end
  end

  test "expects return the given message if validate success", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
