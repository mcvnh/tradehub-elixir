defmodule Tradehub.API do
  @network Application.fetch_env!(:tradehub, :network)
  @api if @network == "testnet", do: Tradehub.Network.Testnet, else: Tradehub.Network.Mainnet

  def start do
    @api.start
  end

  def get(url, headers \\ [], options \\ []) do
    @api.get(url, headers, options)
  end

  def get!(url, headers \\ [], options \\ []) do
    @api.get!(url, headers, options)
  end

  def get_list(endpoint, cast_to_model, options \\ [], headers \\ []) do
    case Tradehub.API.get(endpoint, headers, options) do
      {:ok, response} ->
        items = Enum.map(response.body, fn x -> parse(x, cast_to_model) end)
        {:ok, items}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_list!(endpoint, cast_to_model, options \\ [], headers \\ []) do
    Tradehub.API.get!(endpoint, headers, options)
    |> Map.get(:body)
    |> Enum.map(fn x -> parse(x, cast_to_model) end)
  end

  def get_one(endpoint, options \\ [], cast_to_model, headers \\ []) do
    case Tradehub.API.get(endpoint, headers, options) do
      {:ok, response} ->
        item =
          response
          |> Map.get(:body)
          |> parse(cast_to_model)

        {:ok, item}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_one!(endpoint, options, cast_to_model, headers \\ []) do
    Tradehub.API.get!(endpoint, headers, options)
    |> Map.get(:body)
    |> parse(cast_to_model)
  end

  defp parse(dict, cast_to_model) do
    dict = dict |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    struct(cast_to_model, dict)
  end
end
