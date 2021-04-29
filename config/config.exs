use Mix.Config

config :tradehub,
  network: "mainnet",
  mainnet: "https://tradescan.switcheo.org/",
  testnet: "https://test-tradescan.switcheo.org/",
  public_exchange_tokens: "get_tokens",
  public_exchange_token: "get_token",
  public_exchange_markets: "get_markets",
  public_exchange_market: "get_market",
  public_exchange_orderbook: "get_orderbook",
  public_exchange_oracle_results: "get_oracle_results",
  public_exchange_oracle_result: "get_oracle_result",
  public_exchange_insurance_fund_balance: "get_insurance_balance",
  ##
  public_trade_orders: "get_orders",
  public_trade_order: "get_order",
  public_trade_positions: "get_positions",
  public_trade_position: "get_position",
  public_account: "get_account",
  public_account_profile: "get_profile",
  public_account_address: "get_address",
  public_account_check_username: "username_check"
