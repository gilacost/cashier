defmodule Checkout do
  @spec new(list) :: map()
  def new(price_rules), do: %{items: [], price_rules: price_rules}
end
