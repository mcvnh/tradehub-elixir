defmodule TradehubTest.Tx.ActivateSubAccountTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.ActivateSubAccount

  import Tradehub.Tx.ActivateSubAccount

  test "expects failure when missing main account" do
    assert_raise MsgInvalid, fn ->
      validate!(%ActivateSubAccount{originator: "tswth"})
    end
  end

  test "expects failure when missing originator" do
    assert_raise MsgInvalid, fn ->
      validate!(%ActivateSubAccount{expected_main_account: "main_account"})
    end
  end

  test "expects return the given message if validate success" do
    payload = %{expected_main_account: "main_account", originator: "tswth"}
    assert validate!(payload) == payload
  end
end
