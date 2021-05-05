import Config

config :tradehub,
  network: "https://tradescan.switcheo.org/",
  ws: "wss://ws.dem.exchange/ws"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

import_config "#{config_env()}.exs"
