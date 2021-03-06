import Config

config :tradehub,
  autostart_websocket: true,
  http_client: Tradehub.Net,
  network: :mainnet,
  wallet: "second enter wire knee dial save code during ankle grape estate run"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

import_config("#{config_env()}.exs")
