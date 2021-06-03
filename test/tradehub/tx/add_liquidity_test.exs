defmodule TradehubTest.Tx.AddLiquidityTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.AddLiquidity

  import Tradehub.Tx.AddLiquidity

  setup do
    {
      :ok,
      payload: %AddLiquidity{
        pool_id: "1",
        amount_a: "1",
        amount_b: "1",
        min_shares: "1",
        originator: "1"
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | pool_id: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | amount_a: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | amount_b: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | min_shares: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | originator: ""}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
