defmodule TradehubTest.Tx.CancelOrderTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.CancelOrder

  import Tradehub.Tx.CancelOrder

  test "expects failure when missing order id" do
    assert_raise MsgInvalid, fn ->
      validate!(%CancelOrder{originator: "tswth"})
    end
  end

  test "expects failure when missing originator" do
    assert_raise MsgInvalid, fn ->
      validate!(%CancelOrder{id: "KJAKKAJSLDJKSKDJAKJDIUWIOUKLJSLKJF"})
    end
  end

  test "expects return the given message if validate success" do
    payload = %{id: "ALKJSDLKAJDLK", originator: "tswth"}
    assert validate!(payload) == payload
  end
end
