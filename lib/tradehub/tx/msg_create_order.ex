defmodule Tradehub.Tx.MsgCreateOrder do
  @moduledoc """
  The payload message of the `order/CreateOrder` private endpoint.
  """

  use Tradehub.Tx.Type

  @typedoc "The shopping side of the order."
  @type side :: :buy | :sell

  @typedoc "Order types supported by the Tradeub"
  @type(order_type :: :limit, :market, :stop_limit, :stop_market)

  @typedoc "Time in force"
  @type time_in_force :: :gtc | :fok | :ioc

  @typedoc """
  Payload message
  """
  @type t :: %__MODULE__{
          market: String.t(),
          side: side(),
          quantity: integer(),
          price: String.t(),
          type: order_type(),
          time_in_force: time_in_force(),
          stop_price: String.t(),
          trigger_type: String.t(),
          is_post_only: boolean(),
          is_reduce_only: boolean(),
          originator: Tradehub.Wallet.address()
        }

  defstruct market: "",
            side: nil,
            quantity: "1",
            price: nil,
            type: :limit,
            time_in_force: :gtc,
            stop_price: nil,
            trigger_type: nil,
            is_post_only: false,
            is_reduce_only: false,
            originator: nil

  def type, do: "order/MsgCreateOrder"

  @doc """
  Validate the payload.
  """
  @spec validate(t()) :: {:ok, t()}
  def validate(message) do
    {:ok, message}
  end
end
