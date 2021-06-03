defmodule TradehubTest.Tx.CreateValidatorTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.CreateValidator

  import Tradehub.Tx.CreateValidator

  setup do
    {
      :ok,
      payload: %CreateValidator{
        description: %{
          moniker: "a",
          identity: "a",
          website: "a",
          details: "a"
        },
        commission: %{
          rate: "0",
          max_rate: "0",
          max_rate_change: "0"
        },
        min_self_delegation: "0",
        delegator_address: "0",
        validator_address: "0",
        pubkey: "0",
        value: %{
          denom: "swth",
          amount: "0"
        }
      }
    }
  end

  test "expects failures", %{payload: payload} do
    assert_raise MsgInvalid, fn -> validate!(%{payload | description: %{}}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | commission: %{}}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | value: %{}}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | min_self_delegation: nil}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | validator_address: nil}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | delegator_address: nil}) end
    assert_raise MsgInvalid, fn -> validate!(%{payload | pubkey: nil}) end
  end

  test "expect validate success when the payload was fulfilled", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
