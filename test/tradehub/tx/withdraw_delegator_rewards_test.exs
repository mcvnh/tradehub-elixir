defmodule TradehubTest.Tx.WithdrawDelegatorRewardsTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.WithdrawDelegatorRewards

  import Tradehub.Tx.WithdrawDelegatorRewards

  setup do
    {
      :ok,
      payload: %WithdrawDelegatorRewards{
        delegator_address: "a",
        validator_address: "b"
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | delegator_address: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | validator_address: ""}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
