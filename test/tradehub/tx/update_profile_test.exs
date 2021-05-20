defmodule TradehubTest.Tx.UpdateProfileTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx

  test "expects failure when missing originator" do
    assert_raise Tx.MsgInvalid, fn ->
      %{} |> Tx.UpdateProfile.compose!()
    end
  end

  test "expects return the given message if validate success" do
    payload = %{originator: "1234", twitter: "hello"}
    assert Tx.UpdateProfile.validate!(payload) == payload
  end
end
