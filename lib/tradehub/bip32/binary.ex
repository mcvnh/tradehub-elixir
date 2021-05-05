defmodule Tradehub.BIP32.Binary do
  @moduledoc false

  def take(binary, count)
      when is_binary(binary) and is_integer(count) and count in 0..byte_size(binary) do
    <<bin::bytes-size(count), _rest::binary>> = binary
    bin
  end

  def unsigned_sum(bin1, bin2), do: :binary.decode_unsigned(bin1) + :binary.decode_unsigned(bin2)
end
