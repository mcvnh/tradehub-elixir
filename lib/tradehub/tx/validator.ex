defmodule Tradehub.Tx.Validator do
  @moduledoc false

  @callback validate!(term()) :: term()
  @callback type :: String.t()

  def blank?(nil), do: true
  def blank?(""), do: true
  def blank?([]), do: true
  def blank?(_), do: false
end
