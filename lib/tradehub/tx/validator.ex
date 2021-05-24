defmodule Tradehub.Tx.Validator do
  @moduledoc """
  The helper module that provides validation methods
  """

  @spec blank?(any) :: boolean()
  def blank?(nil), do: true
  def blank?(""), do: true
  def blank?([]), do: true
  def blank?(_), do: false
end
