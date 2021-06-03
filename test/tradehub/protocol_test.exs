defmodule TradehubTest.ProtocolTest do
  use ExUnit.Case, async: false
  doctest Tradehub.Protocol

  setup do
    env = Application.get_all_env(:tradehub)
    on_exit(fn -> Application.put_all_env([{:tradehub, env}]) end)
  end

  test "GET protocol status should returns a valid response" do
    status = Tradehub.Protocol.status!()

    assert_protocol_status(status)
  end

  test "GET block time should works as it expected" do
    time = Tradehub.Protocol.block_time!()

    assert String.valid?(time)
  end

  test "GET validators should returns a list of validators" do
    validators = Tradehub.Protocol.validators!()

    assert is_list(validators)

    validators
    |> Enum.each(fn x -> assert_validator!(x) end)
  end

  test "GET delegation rewards should returns a valid response" do
    rewards = Tradehub.Protocol.delegation_rewards!("swth174cz08dmgluavwcz2suztvydlptp4a8fru98vw")

    assert String.valid?(rewards.height)

    if is_list(rewards.result.rewards) do
      rewards.result.rewards
      |> Enum.each(fn x ->
        assert String.valid?(x.validator_address)

        x.reward
        |> Enum.each(fn y ->
          assert String.valid?(y.amount)
          assert String.valid?(y.denom)
        end)
      end)
    end

    rewards.result.total
    |> Enum.each(fn y ->
      assert String.valid?(y.amount)
      assert String.valid?(y.denom)
    end)
  end

  test "GET delegation rewards should return an error message when something invalid" do
    msg = Tradehub.Protocol.delegation_rewards!("tswth")

    assert String.valid?(msg)
  end

  test "GET blocks should return a valid response" do
    blocks = Tradehub.Protocol.blocks!()

    blocks
    |> Enum.each(fn x ->
      assert String.valid?(x.block_height)
      assert String.valid?(x.time)
      assert String.valid?(x.count)
      assert String.valid?(x.proposer_address)
    end)
  end

  test "GET blocks should returns an error message in case of invalid params" do
    msg = Tradehub.Protocol.blocks!(%{before_id: -1})

    assert String.valid?(msg)
  end

  test "GET transactions should returns a valid response" do
    transactions = Tradehub.Protocol.transactions!()

    transactions
    |> Enum.each(fn x ->
      assert String.valid?(x.address)
      assert String.valid?(x.block_time)
      assert String.valid?(x.code)
      assert String.valid?(x.gas_limit)
      assert String.valid?(x.gas_used)
      assert String.valid?(x.hash)
      assert String.valid?(x.height)
      assert String.valid?(x.id)
      assert String.valid?(x.memo)
      assert String.valid?(x.msg)
      assert String.valid?(x.msg_type)
      assert String.valid?(x.username)
    end)
  end

  test "GET transactions should returns an error message in case of invalid params" do
    msg = Tradehub.Protocol.transactions!(%{end_block: -1})

    assert String.valid?(msg)
  end

  test "GET transaction of a hash should returns a valid response" do
    hash = Tradehub.Protocol.transactions!() |> List.first() |> Map.get(:hash)

    transaction = Tradehub.Protocol.transaction!(hash)

    assert String.valid?(transaction.address)
    assert String.valid?(transaction.block_time)
    assert String.valid?(transaction.code)
    assert String.valid?(transaction.gas_limit)
    assert String.valid?(transaction.gas_used)
    assert String.valid?(transaction.hash)
    assert String.valid?(transaction.height)
    assert String.valid?(transaction.id)
    assert String.valid?(transaction.memo)
    assert String.valid?(transaction.username)

    transaction.msgs
    |> Enum.each(fn x ->
      assert String.valid?(x.msg)
      assert String.valid?(x.msg_type)
    end)
  end

  test "GET transaction should returns an error message in case of invalid hash" do
    msg = Tradehub.Protocol.transaction!("")

    assert String.valid?(msg)
  end

  test "GET transaction types should returns a valid response" do
    types = Tradehub.Protocol.transaction_types!()

    types
    |> Enum.each(fn x ->
      assert String.valid?(x)
    end)
  end

  test "GET total balances should returns a valid response" do
    types = Tradehub.Protocol.total_balances!()

    types
    |> Enum.each(fn x ->
      assert String.valid?(x.available)
      assert String.valid?(x.denom)
      assert String.valid?(x.order)
      assert String.valid?(x.position)
    end)
  end

  test "expect failures" do
    Application.put_env(:tradehub, :http_client, TradehubTest.NetTimeoutMock)

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.status!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.block_time!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.validators!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.delegation_rewards!("tswth17y4r3p4dvzrvml3fqe5p05l7y077e4cy8s7ruj")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.blocks!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.transactions!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.transaction!("")
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.transaction_types!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.total_balances!()
    end

    assert_raise HTTPoison.Error, fn ->
      Tradehub.Protocol.external_transfers!("swth1fdqkq5gc5x8h6a0j9hamc30stlvea6zldprt6q")
    end
  end

  # Helper functions

  defp assert_protocol_status(obj) do
    assert is_integer(obj.id)
    assert String.valid?(obj.jsonrpc)

    assert String.valid?(obj.result.node_info.channels)
    assert String.valid?(obj.result.node_info.id)
    assert String.valid?(obj.result.node_info.listen_addr)
    assert String.valid?(obj.result.node_info.moniker)
    assert String.valid?(obj.result.node_info.network)
    assert String.valid?(obj.result.node_info.other.rpc_address)
    assert String.valid?(obj.result.node_info.other.tx_index)
    assert String.valid?(obj.result.node_info.protocol_version.app)
    assert String.valid?(obj.result.node_info.protocol_version.block)
    assert String.valid?(obj.result.node_info.protocol_version.p2p)
    assert String.valid?(obj.result.node_info.version)
    assert is_boolean(obj.result.sync_info.catching_up)
    assert String.valid?(obj.result.sync_info.earliest_app_hash)
    assert String.valid?(obj.result.sync_info.earliest_block_hash)
    assert String.valid?(obj.result.sync_info.earliest_block_height)
    assert String.valid?(obj.result.sync_info.earliest_block_time)
    assert String.valid?(obj.result.sync_info.latest_app_hash)
    assert String.valid?(obj.result.sync_info.latest_block_hash)
    assert String.valid?(obj.result.sync_info.latest_block_height)
    assert String.valid?(obj.result.sync_info.latest_block_time)
    assert String.valid?(obj.result.validator_info.address)
    assert String.valid?(obj.result.validator_info.pub_key.type)
    assert String.valid?(obj.result.validator_info.pub_key.value)
    assert String.valid?(obj.result.validator_info.voting_power)
  end

  defp assert_validator!(obj) do
    assert String.valid?(obj[:BondStatus])
    assert String.valid?(obj[:Commission].commission_rates().max_change_rate)
    assert String.valid?(obj[:Commission].commission_rates().max_rate)
    assert String.valid?(obj[:Commission].commission_rates().rate)
    assert String.valid?(obj[:Commission].update_time())

    assert String.valid?(obj[:ConsAddress])
    assert String.valid?(obj[:ConsAddressByte])
    assert String.valid?(obj[:ConsPubKey])
    assert String.valid?(obj[:DelegatorShares])
    assert String.valid?(obj[:Description].details())
    assert String.valid?(obj[:Description].identity())
    assert String.valid?(obj[:Description].moniker())
    assert String.valid?(obj[:Description].security_contact())
    assert String.valid?(obj[:Description].website())

    assert is_boolean(obj[:Jailed])
    assert String.valid?(obj[:MinSelfDelegation])
    assert String.valid?(obj[:OperatorAddress])
    assert is_integer(obj[:Status])
    assert String.valid?(obj[:Tokens])
    assert String.valid?(obj[:UnbondingCompletionTime])
    assert is_integer(obj[:UnbondingHeight])
    assert String.valid?(obj[:WalletAddress])
  end
end
