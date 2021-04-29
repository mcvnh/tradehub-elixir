defmodule Tradehub.Model.Token do
  @derive Jason.Encoder
  defstruct [
    :name,
    :symbol,
    :denom,
    :decimals,
    :blockchain,
    :chain_id,
    :asset_id,
    :is_active,
    :is_collateral,
    :lockproxy_hash,
    :delegated_supply,
    :originator
  ]
end
