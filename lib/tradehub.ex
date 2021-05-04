defmodule Tradehub do
  @moduledoc """
  This modules mainly focusing on defining custom types for the Tradehub response.
  """

  @type text :: String.t()
  @type address :: String.t()

  @type profile :: %{
          address: address,
          last_seen_block: text,
          last_seen_time: text,
          twitter: text,
          username: text
        }

  @type coin :: %{amount: text, denom: text}
  @type account :: %{
          height: text,
          result:
            account_result :: %{
              type: text,
              value:
                account_result_value :: %{
                  account_number: text,
                  address: text,
                  coins: list(coin),
                  public_key:
                    public_key :: %{
                      type: text,
                      value: text
                    },
                  sequence: text
                }
            }
        }

  @type token :: %{
          name: text,
          symbol: text,
          denom: text,
          decimals: text,
          blockchain: text,
          chain_id: text,
          asset_id: text,
          is_active: text,
          is_collateral: text,
          lockproxy_hash: text,
          delegated_supply: text,
          originator: text
        }

  @type order :: %{
          address: text,
          allocated_margin_amount: text,
          allocated_margin_denom: text,
          available: text,
          block_created_at: text,
          block_height: text,
          filled: text,
          id: text,
          initiator: text,
          is_liquidation: text,
          is_post_only: text,
          is_reduce_only: text,
          market: text,
          order_id: text,
          order_status: text,
          order_type: text,
          price: text,
          quantity: text,
          side: text,
          stop_price: text,
          time_in_force: text,
          trigger_type: text,
          triggered_block_height: text,
          type: text,
          username: text
        }

  @type market :: %{
          base: text,
          base_name: text,
          base_precision: text,
          closed_block_height: text,
          created_block_height: text,
          description: text,
          display_name: text,
          expiry_time: text,
          impact_size: text,
          index_oracle_id: text,
          initial_margin_base: text,
          initial_margin_step: text,
          is_active: text,
          is_settled: text,
          last_price_protected_band: text,
          lot_size: text,
          maintenance_margin_ratio: text,
          maker_fee: text,
          mark_price_band: text,
          market_type: text,
          max_liquidation_order_duration: text,
          max_liquidation_order_ticket: text,
          min_quantity: text,
          name: text,
          quote: text,
          quote_name: text,
          quote_precision: text,
          risk_step_size: text,
          taker_fee: text,
          tick_size: text,
          type: text
        }

  @type oracle :: %{
          block_height: text,
          data: text,
          oracle_id: text,
          timestamp: text
        }

  @type orderbook_record :: %{price: text, quantity: text}
  @type orderbook :: %{
          asks: list(orderbook_record),
          bids: list(orderbook_record)
        }

  @type candlestick :: %{
          close: text,
          high: text,
          id: integer,
          low: text,
          market: text,
          open: text,
          quote_volume: text,
          resolution: integer,
          time: text,
          volume: text
        }

  @type ticker_prices :: %{
          block_height: integer,
          fair: text,
          fair_index_delta_avg: text,
          index: text,
          index_updated_at: text,
          last: text,
          last_updated_at: text,
          mark: text,
          mark_avg: text,
          market: text,
          marking_strategy: text,
          settlement: text
        }

  @type market_stats :: %{
          day_high: text,
          day_low: text,
          day_open: text,
          day_close: text,
          day_volume: text,
          day_quote_volume: text,
          index_price: text,
          mark_price: text,
          last_price: text,
          market: text,
          market_type: text,
          open_interest: text
        }

  @type protocol_status :: %{
          id: integer,
          jsonrpc: text,
          result:
            protocol_status_result :: %{
              node_info:
                node_info :: %{
                  channels: text,
                  id: text,
                  listen_addr: text,
                  moniker: text,
                  network: text,
                  other:
                    node_info :: %{
                      rpc_address: text,
                      tx_index: text
                    },
                  protocol_version:
                    protocol_version :: %{
                      app: text,
                      block: text,
                      p2p: text
                    },
                  version: text
                },
              sync_info:
                sync_info :: %{
                  catching_up: boolean,
                  earliest_app_hash: text,
                  earliest_block_hash: text,
                  earliest_block_height: text,
                  earliest_block_time: text,
                  latest_app_hash: text,
                  latest_block_hash: text,
                  latest_block_height: text,
                  latest_block_time: text
                },
              validator_info:
                validator_info :: %{
                  address: text,
                  pub_key:
                    pub_key :: %{
                      type: text,
                      value: text
                    },
                  voting_power: text
                }
            }
        }

  @type validator :: %{
          BondStatus: text,
          Commission:
            commission :: %{
              commission_rates:
                comission_rates :: %{
                  max_change_rate: text,
                  max_rate: text,
                  rate: text
                },
              update_time: text
            },
          ConsAddress: text,
          ConsAddressByte: text,
          ConsPubKey: text,
          DelegatorShares: text,
          Description:
            validator_description :: %{
              details: text,
              identity: text,
              moniker: text,
              security_contact: text,
              website: text
            },
          Jailed: boolean,
          MinSelfDelegation: text,
          OperatorAddress: text,
          Status: text,
          Tokens: text,
          UnbondingCompletionTime: text,
          UnbondingHeight: integer,
          WalletAddress: text
        }

  @type delegation_rewards :: %{
          height: integer,
          result:
            delegation_rewards_result :: %{
              rewards:
                list(
                  delegation_result_rewards :: %{
                    validator_address: text,
                    reward: list(Tradehub.coin())
                  }
                ),
              total: list(coin)
            }
        }

  @type block :: %{
          block_height: text,
          time: text,
          count: text,
          proposer_address: text
        }

  @type transaction :: %{
          address: text,
          block_time: text,
          code: text,
          gas_limit: text,
          gas_used: text,
          hash: text,
          height: text,
          id: text,
          memo: text,
          msg: text,
          msg_type: text,
          username: text
        }

  @type protocol_balance :: %{
          available: text,
          denom: text,
          order: text,
          position: text
        }

  @type transfer_record :: %{
          address: text,
          amount: text,
          block_height: text,
          blockchain: text,
          contract_hash: text,
          denom: text,
          fee_address: text,
          fee_amount: text,
          id: text,
          status: text,
          symbol: text,
          timestamp: text,
          token_name: text,
          transaction_hash: text,
          transfer_type: text
        }

  @type rich_holder :: %{
          address: text,
          amount: text,
          denom: text,
          username: text
        }

  @type position :: %{
          address: text,
          allocated_margin_amount: text,
          allocated_margin_denom: text,
          closed_block_height: text,
          closed_block_time: text,
          created_block_height: text,
          entry_price: text,
          lots: text,
          market: text,
          realized_pnl: text,
          type: text,
          updated_block_height: text,
          username: text
        }

  @type leverage :: %{
          type: text,
          market: text,
          address: text,
          leverage: text
        }

  @type trade :: %{
          block_created_at: text,
          block_height: text,
          id: text,
          liquidation: text,
          maker_address: text,
          maker_fee_amount: text,
          maker_fee_denom: text,
          maker_id: text,
          maker_side: text,
          maker_username: text,
          market: text,
          price: text,
          quantity: text,
          taker_address: text,
          taker_fee_amount: text,
          taker_fee_denom: text,
          taker_id: text,
          taker_side: text,
          taker_username: text
        }

  @type account_trade :: %{
          base_precision: text,
          quote_precision: text,
          fee_precision: text,
          order_id: text,
          market: text,
          side: text,
          quantity: text,
          price: text,
          fee_amount: text,
          fee_denom: text,
          address: text,
          block_height: text,
          block_created_at: text,
          id: text
        }

  @network Application.fetch_env!(:tradehub, :network)
  @api if @network == :testnet, do: Tradehub.Network.Testnet, else: Tradehub.Network.Mainnet

  @doc false
  def get(url, options \\ [], headers \\ []) do
    @api.get(url, headers, options)
  end
end
