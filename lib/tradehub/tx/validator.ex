defmodule Tradehub.Tx.Validator do
  @moduledoc """
  The helper module that provides validation methods
  """

  @spec blank?(any) :: boolean()
  def blank?(nil), do: true
  def blank?(""), do: true
  def blank?([]), do: true
  def blank?(x) when is_map(x), do: map_size(x) == 0
  def blank?(_), do: false
end
