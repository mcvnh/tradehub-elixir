import Config

config :tradehub,
  http_client: Tradehub.Net,
  network: :mainnet,
  rest: "https://tradescan.switcheo.org/",
  ws: "wss://ws.dem.exchange/ws",
  wallet: "second enter wire knee dial save code during ankle grape estate run"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

import_config("#{config_env()}.exs")
