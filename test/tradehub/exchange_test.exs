defmodule TradehubTest.ExchangeTest do
  use ExUnit.Case, async: false
  # doctest Tradehub.Exchange

  test "GET tokens should returns a valid response" do
    tokens = Tradehub.Exchange.tokens!()

    tokens
    |> Enum.each(fn it -> assert_token!(it) end)
  end

  test "GET token should returns a valid response" do
    token = Tradehub.Exchange.token!("swth")

    assert_token!(token)
  end

  test "GET token should returns an error message if token denom not invalid" do
    token = Tradehub.Exchange.token!("foobar")

    assert String.valid?(token)
  end

  test "GET markets should returns a valid response" do
    markets = Tradehub.Exchange.markets!()

    markets
    |> Enum.each(fn it -> assert_market!(it) end)

    markets = Tradehub.Exchange.markets!(%{market_type: :spot})

    markets
    |> Enum.each(fn it -> assert_market!(it) end)
  end

  test "GET market should returns a valid response" do
    market = Tradehub.Exchange.market!("swth_eth1")

    assert_market!(market)
  end

  test "GET market should returns an error message if token denom not invalid" do
    market = Tradehub.Exchange.market!("")

    assert String.valid?(market)
  end

  test "GET orderbook should returns a valid response" do
    orderbook = Tradehub.Exchange.orderbook!("swth_eth1", 20)

    assert is_map(orderbook)
    assert is_list(orderbook.asks)
    assert is_list(orderbook.bids)

    orderbook.asks
    |> Enum.each(fn x ->
      assert String.valid?(x.price)
      assert String.valid?(x.quantity)
    end)

    orderbook.bids
    |> Enum.each(fn x ->
      assert String.valid?(x.price)
      assert String.valid?(x.quantity)
    end)
  end

  test "GET orderbook should returns empty bids asks if market is invalid" do
    orderbook = Tradehub.Exchange.orderbook!("for_bar")

    assert is_map(orderbook)
    assert is_list(orderbook.asks)
    assert is_list(orderbook.bids)

    assert Enum.count(orderbook.asks) == 0
    assert Enum.count(orderbook.bids) == 0
  end

  test "GET oracle results should returns a valid response" do
    oracles = Tradehub.Exchange.oracle_results!()

    assert is_map(oracles)

    oracles
    |> Map.keys()
    |> Enum.each(fn key ->
      oracle = oracles[key]

      assert String.valid?(oracle.block_height)
      assert String.valid?(oracle.data)
      assert String.valid?(oracle.oracle_id)
      assert is_integer(oracle.timestamp)
    end)
  end

  test "GET oracle result should returns a valid response" do
    oracle = Tradehub.Exchange.oracle_result!("DETH")

    assert String.valid?(oracle.block_height)
    assert String.valid?(oracle.data)
    assert String.valid?(oracle.oracle_id)
    assert is_integer(oracle.timestamp)
  end

  test "GET oracle result should returns an error message when oracle id invalid" do
    oracle = Tradehub.Exchange.oracle_result!("FOOBAR")

    assert String.valid?(oracle)
  end

  test "GET insurance balances should returns a valid response" do
    balances = Tradehub.Exchange.insurance_balances!()

    assert is_list(balances)

    balances
    |> Enum.each(fn x ->
      assert String.valid?(x.denom)
      assert String.valid?(x.amount)
    end)
  end

  # Helper function
  defp assert_token!(obj) do
    assert String.valid?(obj.name)
    assert String.valid?(obj.symbol)
    assert String.valid?(obj.denom)
    assert String.valid?(obj.blockchain)
    assert String.valid?(obj.asset_id)
    assert String.valid?(obj.lock_proxy_hash)
    assert String.valid?(obj.delegated_supply)
    assert String.valid?(obj.originator)

    assert is_integer(obj.decimals)
    assert is_integer(obj.chain_id)

    assert is_boolean(obj.is_active)
    assert is_boolean(obj.is_collateral)
  end

  defp assert_market!(obj) do
    assert String.valid?(obj.base)
    assert String.valid?(obj.base_name)
    assert is_integer(obj.base_precision)
    assert is_integer(obj.closed_block_height)
    assert is_integer(obj.created_block_height)
    assert String.valid?(obj.description)
    assert String.valid?(obj.display_name)
    assert String.valid?(obj.expiry_time)
    assert String.valid?(obj.impact_size)
    assert String.valid?(obj.index_oracle_id)
    assert String.valid?(obj.initial_margin_base)
    assert String.valid?(obj.initial_margin_step)
    assert is_boolean(obj.is_active)
    assert is_boolean(obj.is_settled)
    assert is_integer(obj.last_price_protected_band)
    assert String.valid?(obj.lot_size)
    assert String.valid?(obj.maintenance_margin_ratio)
    assert String.valid?(obj.maker_fee)
    assert is_integer(obj.mark_price_band)
    assert String.valid?(obj.market_type)
    assert is_integer(obj.max_liquidation_order_duration)
    assert String.valid?(obj.max_liquidation_order_ticket)
    assert String.valid?(obj.min_quantity)
    assert String.valid?(obj.name)
    assert String.valid?(obj.quote)
    assert String.valid?(obj.quote_name)
    assert is_integer(obj.quote_precision)
    assert String.valid?(obj.risk_step_size)
    assert String.valid?(obj.taker_fee)
    assert String.valid?(obj.tick_size)
    assert String.valid?(obj.type)
  end
end
