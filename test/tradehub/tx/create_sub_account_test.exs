defmodule TradehubTest.Tx.CreateSubAccountTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.CreateSubAccount

  import Tradehub.Tx.CreateSubAccount

  test "expects failure when missing sub address" do
    assert_raise MsgInvalid, fn ->
      validate!(%CreateSubAccount{originator: "tswth"})
    end
  end

  test "expects failure when missing originator" do
    assert_raise MsgInvalid, fn ->
      validate!(%CreateSubAccount{sub_address: "sub_address"})
    end
  end

  test "expects return the given message if validate success" do
    payload = %{sub_address: "sub_address", originator: "tswth"}
    assert validate!(payload) == payload
  end
end
