defmodule TradehubTest.ProtocolTest do
  use ExUnit.Case, async: false
  # doctest Tradehub.Protocol

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
    rewards = Tradehub.Protocol.delegation_rewards!("tswth17y4r3p4dvzrvml3fqe5p05l7y077e4cy8s7ruj")

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

    IO.inspect(rewards)
  end

  test "GET delegation rewards should return an error message when something invalid" do
    msg = Tradehub.Protocol.delegation_rewards!("tswth")

    assert String.valid?(msg)
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
