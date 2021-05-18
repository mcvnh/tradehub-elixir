defmodule TradehubTest.Tx.MsgUpdateProfileTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx

  test "expects failure when missing originator" do
    assert_raise Tx.MsgInvalid, fn ->
      %{} |> Tx.MsgUpdateProfile.compose!()
    end
  end

  test "expects return the given message if validate success" do
    payload = %{originator: "1234", twitter: "hello"}
    assert Tx.MsgUpdateProfile.validate!(payload) == payload
  end
end
