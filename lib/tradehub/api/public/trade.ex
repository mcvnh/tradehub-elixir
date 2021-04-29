defmodule Tradehub.API.Public.Trade do
  alias Tradehub.API.Model

  @orders Application.fetch_env!(:tradehub, :public_trade_orders)
  @order Application.fetch_env!(:tradehub, :public_trade_order)
  @positions Application.fetch_env!(:tradehub, :public_trade_positions)

  def get_orders(account) do
    Tradehub.API.get_list(@orders, Model.Order, params: %{account: String.downcase(account)})
  end

  def get_orders!(account) do
    Tradehub.API.get_list!(@orders, Model.Order, params: %{account: String.downcase(account)})
  end

  def get_order(order_id) do
    Tradehub.API.get_one(@order, [params: %{order_id: String.upcase(order_id)}], Model.Order)
  end

  def get_order!(order_id) do
    Tradehub.API.get_one!(@order, [params: %{order_id: String.upcase(order_id)}], Model.Order)
  end

  def get_orders(account) do
    Tradehub.API.get_list(@positions, Model.Position, params: %{account: String.downcase(account)})
  end

  def get_orders!(account) do
    Tradehub.API.get_list!(@positions, Model.Position,
      params: %{account: String.downcase(account)}
    )
  end
end
