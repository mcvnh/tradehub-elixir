defmodule TradehubTest.Tx.EditOrderTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.EditOrder

  import Tradehub.Tx.EditOrder

  setup do
    {
      :ok,
      payload: %EditOrder{
        id: "1",
        quantity: "1",
        price: "1",
        stop_price: "1",
        originator: "1"
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | id: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | originator: ""}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
    assert validate!(%{payload | quantity: ""}) == %{payload | quantity: ""}
    assert validate!(%{payload | price: ""}) == %{payload | price: ""}
    assert validate!(%{payload | stop_price: ""}) == %{payload | stop_price: ""}
  end
end
