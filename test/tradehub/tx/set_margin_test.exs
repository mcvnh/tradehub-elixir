defmodule TradehubTest.Tx.SetMarginTest do
  use ExUnit.Case, async: true

  alias Tradehub.Tx.MsgInvalid
  alias Tradehub.Tx.SetMargin

  import Tradehub.Tx.SetMargin

  setup do
    {
      :ok,
      payload: %SetMargin{
        market: "swth_eth1",
        margin: "11",
        originator: "tswth"
      }
    }
  end

  test "expects failure when missing market", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | market: nil})
    end
  end

  test "expects failure when missing margin", %{payload: payload} do
    assert_raise MsgInvalid, fn ->
      validate!(%{payload | margin: nil})
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
