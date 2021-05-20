defmodule TradehubTest.Tx.WithdrawTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.Withdraw

  import Tradehub.Tx.Withdraw

  setup do
    {
      :ok,
      payload: %Withdraw{
        to_address: "to_address",
        denom: "swth",
        amount: "100000000",
        fee_amount: "10000000",
        originator: "tswth1111"
      }
    }
  end

  test "expects failure when missing to address", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | to_address: nil})
    end
  end

  test "expects failure when missing denom", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | denom: nil})
    end
  end

  test "expects failure when missing amount", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | amount: nil})
    end
  end

  test "expects failure when missing fee amount", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | fee_amount: nil})
    end
  end

  test "expects failure when originator", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | originator: ""})
    end
  end

  test "expects return the given message if validate success", %{payload: payload} do
    assert validate!(payload) == payload
  end
end
