defmodule Tradehub.Trade do
  alias Tradehub.Model

  @order Application.fetch_env!(:tradehub, :public_trade_order)
  @orders Application.fetch_env!(:tradehub, :public_trade_orders)
  @positions Application.fetch_env!(:tradehub, :public_trade_positions)

  def get_orders(account) do
    Tradehub.get(@orders, params: %{account: String.downcase(account)})
  end

  def get_order(order_id) do
    Tradehub.get(@order, params: %{order_id: String.upcase(order_id)})
  end
end
