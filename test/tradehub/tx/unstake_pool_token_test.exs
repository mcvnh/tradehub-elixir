defmodule TradehubTest.Tx.UnstakePoolTokenTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.UnstakePoolToken

  import Tradehub.Tx.UnstakePoolToken

  setup do
    {
      :ok,
      payload: %UnstakePoolToken{
        denom: "a",
        amount: "b",
        originator: "c"
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | denom: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | amount: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | originator: ""}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
