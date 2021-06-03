defmodule TradehubTest.Tx.RemoveLiquidityTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.RemoveLiquidity

  import Tradehub.Tx.RemoveLiquidity

  setup do
    {
      :ok,
      payload: %RemoveLiquidity{
        pool_id: "1",
        shares: "1",
        originator: "1"
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | pool_id: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | shares: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | originator: ""}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
