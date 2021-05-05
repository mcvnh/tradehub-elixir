defmodule Tradehub.BIP32.Keypath do
  @moduledoc false

  @hardened_key_start 0x80000000

  def to_list("m"), do: {:xprv, []}
  def to_list("M"), do: {:xpub, []}
  def to_list("m/" <> path), do: {:xprv, to_list(path)}
  def to_list("M/" <> path), do: {:xpub, to_list(path)}

  def to_list(path) when is_binary(path) do
    path
    |> String.split("/")
    |> Enum.map(&convert_to_integer/1)
  end

  defp convert_to_integer(item) do
    if String.ends_with?(item, ["h", "H", "\'"]) do
      item
      |> String.split_at(-1)
      |> elem(0)
      |> String.to_integer()
      |> Kernel.+(@hardened_key_start)
    else
      String.to_integer(item)
    end
  end
end
