defmodule Tradehub.API.Model.OracleResult do
  @derive Jason.Encoder
  defstruct [
    :block_height,
    :data,
    :oracle_id,
    :timestamp
  ]
end
