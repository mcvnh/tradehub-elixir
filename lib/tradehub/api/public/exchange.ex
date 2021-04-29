defmodule Tradehub.Public.Exchange do
  alias Tradehub.Model

  @tokens Application.fetch_env!(:tradehub, :public_exchange_tokens)
  @token Application.fetch_env!(:tradehub, :public_exchange_token)

  @markets Application.fetch_env!(:tradehub, :public_exchange_markets)
  @market Application.fetch_env!(:tradehub, :public_exchange_market)

  @orderbook Application.fetch_env!(:tradehub, :public_exchange_orderbook)

  @oracle_result Application.fetch_env!(:tradehub, :public_exchange_oracle_result)
  @oracle_results Application.fetch_env!(:tradehub, :public_exchange_oracle_results)

  @insurance_balance Application.fetch_env!(:tradehub, :public_exchange_insurance_fund_balance)


  def get_tokens do
    Tradehub.get_list(@tokens, Model.Token)
  end

  def get_tokens! do
    Tradehub.get_list!(@tokens, Model.Token)
  end

  def get_token(token_symbol) do
    Tradehub.get_one(@token, [params: %{token: String.downcase(token_symbol)}], Model.Token)
  end

  def get_token!(token_symbol) do
    Tradehub.get_one!(@token, [params: %{token: String.downcase(token_symbol)}], Model.Token)
  end

  def get_markets do
    Tradehub.get_list(@markets, Model.Market)
  end

  def get_markets! do
    Tradehub.get_list!(@markets, Model.Market)
  end

  def get_market(market) do
    Tradehub.get_one(@market, [params: %{market: String.downcase(market)}], Model.Market)
  end

  def get_market!(market) do
    Tradehub.get_one!(@market, [params: %{market: String.downcase(market)}], Model.Market)
  end

  def get_orderbook(market, limit \\ 50) do
    result = Tradehub.get(@orderbook, [],[params: %{market: String.downcase(market), limit: limit}])
    case result do
      {:ok, response} ->
        orderbook = cast_orderbook_response(response)
        {:ok, orderbook}
      _ -> result
    end
  end

  def get_orderbook!(market, limit \\ 50) do
    response = Tradehub.get!(@orderbook, [],[params: %{market: String.downcase(market), limit: limit}])
    cast_orderbook_response(response)
  end

  def get_oracle_results() do
    result = Tradehub.get(@oracle_results)
    case result do
      {:ok, response} ->
        response
        |> Map.get(:body)
        |> Map.values
        |> Enum.map(fn x -> parse(x, Model.OracleResult) end)
      _ -> result
    end
  end

  def get_oracle_results!() do
    Tradehub.get!(@oracle_results)
    |> Map.get(:body)
    |> Map.values
    |> Enum.map(fn x -> parse(x, Model.OracleResult) end)
  end


  def get_oracle_result(id) do
    Tradehub.get_one(@oracle_result, [params: %{id: String.upcase(id)}], Model.OracleResult)
  end

  def get_oracle_result!(id) do
    Tradehub.get_one!(@oracle_result, [params: %{id: String.upcase(id)}], Model.OracleResult)
  end


  # TODO
  def get_insurance_balance do
    Tradehub.get_one(@insurance_balance, [], Model.Coin)
  end

  # TODO
  def get_insurance_balance! do
    Tradehub.get_one!(@insurance_balance, [], Model.Coin)
  end


  defp cast_orderbook_response(response) do
    orderbook = %Model.Orderbook{}
    orderbook = Map.put(orderbook, :bids, Map.get(response.body, "bids", []) |> Enum.map(fn x -> parse(x, Model.OrderbookRecord) end))
    orderbook = Map.put(orderbook, :asks, Map.get(response.body, "asks", []) |> Enum.map(fn x -> parse(x, Model.OrderbookRecord) end))
    orderbook
  end

  defp parse(dict, cast_to_model) do
    dict = dict |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    struct(cast_to_model, dict)
  end
end
