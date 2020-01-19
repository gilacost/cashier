defprotocol Discount do
  def apply(type, params)
end

defmodule Checkout.Discount do
  alias Checkout.Product

  defmodule OneFor do
    defstruct type: :one
  end

  defmodule Bulk.Fixed do
    defstruct from: 3, amount: 0.5
  end

  defmodule Bulk.Percentage do
    defstruct from: 3, fraction: 1 / 3
  end

  defimpl Discount, for: OneFor do
    def apply(_type, [count, code, checkout]) do
      discount = floor(count / 2) * Product.price(code)
      Map.update(checkout, :discount, 0, &(&1 + discount))
    end
  end

  defimpl Discount, for: Bulk.Fixed do
    def apply(%{from: from, amount: amount}, [count, _code, checkout])
        when count > from do
      Map.update(checkout, :discount, 0, &(&1 + count * amount))
    end

    def apply(%{}, [_count, _code, checkout]), do: checkout
  end

  defimpl Discount, for: Bulk.Percentage do
    def apply(%{from: from, fraction: fraction}, [count, code, checkout])
        when count > from do
      discount = count * Product.price(code) * fraction
      Map.update(checkout, :discount, 0, &(&1 + discount))
    end

    def apply(%{}, [_count, _code, checkout]), do: checkout
  end
end
