defmodule TradehubTest.Tx.StakePoolTokenTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.StakePoolToken

  import Tradehub.Tx.StakePoolToken

  setup do
    {
      :ok,
      payload: %StakePoolToken{
        denom: "a",
        amount: "b",
        duration: "c",
        originator: "d"
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | denom: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | amount: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | duration: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | originator: ""}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
