defmodule TradehubTest.FeeTest do
  use ExUnit.Case, async: false
  # doctest Tradehub.Fee

  test "GET txns_fees should responses a valid result" do
    result = Tradehub.Fee.txns_fees!()

    assert_txns_fees!(result)
  end

  test "GET current_fee should responses a valid result" do
    result = Tradehub.Fee.current_fee!("swth")

    assert_withdrawal_fee!(result)
  end

  test "GET current_fee should responses an error as string when param is incorrect" do
    result = Tradehub.Fee.current_fee!("swth_hehe")

    assert String.valid?(result)
  end

  # Helper functions

  defp assert_txns_fees!(obj) do
    assert String.valid?(obj.height)
    assert is_list(obj.result)

    result = obj.result

    result
    |> Enum.each(fn x ->
      assert String.valid?(x.msg_type)
      assert String.valid?(x.fee)
    end)
  end

  defp assert_withdrawal_fee!(obj) do
    assert is_integer(obj.prev_update_time)
    assert String.valid?(obj.details.deposit.fee)
    assert String.valid?(obj.details.withdrawal.fee)
  end
end
