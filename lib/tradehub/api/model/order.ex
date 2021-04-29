defmodule Tradehub.Model.Order do
  @derive Jason.Encoder
  defstruct [
    :address,
    :allocated_margin_amount,
    :allocated_margin_denom,
    :available,
    :block_created_at,
    :block_height,
    :filled,
    :id,
    :initiator,
    :is_liquidation,
    :is_post_only,
    :is_reduce_only,
    :market,
    :order_id,
    :order_status,
    :order_type,
    :price,
    :quantity,
    :side,
    :stop_price,
    :time_in_force,
    :trigger_type,
    :triggered_block_height,
    :type,
    :username
  ]
end
