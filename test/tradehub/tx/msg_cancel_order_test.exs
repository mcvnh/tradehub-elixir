defmodule TradehubTest.Tx.MsgCancelOrderTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.MsgCancelOrder

  import Tradehub.Tx.MsgCancelOrder

  test "expects failure when missing order id" do
    assert_raise MsgInvalid, fn ->
      validate!(%MsgCancelOrder{originator: "tswth"})
    end
  end

  test "expects failure when missing originator" do
    assert_raise MsgInvalid, fn ->
      validate!(%MsgCancelOrder{id: "KJAKKAJSLDJKSKDJAKJDIUWIOUKLJSLKJF"})
    end
  end

  test "expects return the given message if validate success" do
    payload = %{id: "ALKJSDLKAJDLK", originator: "tswth"}
    assert validate!(payload) == payload
  end
end
