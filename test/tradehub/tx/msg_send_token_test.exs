defmodule TradehubTest.Tx.MsgSendTokenTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.MsgSendToken

  import Tradehub.Tx.MsgSendToken

  setup do
    {
      :ok,
      payload: %MsgSendToken{
        from_address: "address_1",
        to_address: "address_2",
        amount: [%{denom: "swth", amount: 1000}]
      }
    }
  end

  test "expects failure when missing from address", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | from_address: nil})
    end
  end

  test "expects failure when missing to address", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | to_address: nil})
    end
  end

  test "expects failure when missing amount", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | amount: []})
    end
  end

  test "expects return the given message if validate success", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
