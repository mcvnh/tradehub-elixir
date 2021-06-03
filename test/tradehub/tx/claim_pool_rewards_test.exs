defmodule TradehubTest.Tx.ClaimPoolRewardsTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.ClaimPoolRewards

  import Tradehub.Tx.ClaimPoolRewards

  setup do
    {
      :ok,
      payload: %ClaimPoolRewards{
        pool_id: "1",
        originator: "1"
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | pool_id: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | originator: ""}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
