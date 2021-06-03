defmodule TradehubTest.Tx.RedelegatingTokensTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.RedelegatingTokens

  import Tradehub.Tx.RedelegatingTokens

  setup do
    {
      :ok,
      payload: %RedelegatingTokens{
        delegator_address: "a",
        validator_src_address: "b",
        validator_dst_address: "e",
        amount: %{
          amount: "c",
          denom: "d"
        }
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | delegator_address: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | validator_src_address: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | validator_dst_address: ""}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | amount: %{}}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | amount: %{amount: "1", denom: ""}}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | amount: %{amount: "", denom: "0"}}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
