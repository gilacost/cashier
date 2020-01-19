defmodule Checkout do
  alias Checkout.Product

  defstruct items: [], price_rules: %{}, discount: 0

  @type t :: %__MODULE__{
          items: list,
          price_rules: map
        }

  @spec new(list) :: t
  def new(price_rules), do: %Checkout{price_rules: price_rules}

  @spec add_item(t, Product.t()) :: t()
  def add_item(checkout, %Product{} = product) do
    Map.update(
      checkout,
      :items,
      [product],
      &[product | &1]
    )
    |> apply_discounts()
  end

  @spec product_count(%Checkout{}, String.t()) :: integer
  defp product_count(%Checkout{items: items}, code),
    do: Enum.count(items, &(&1.code == code))

  defp apply_discounts(%Checkout{price_rules: price_rules} = checkout) do
    checkout = %{checkout | discount: 0}

    Enum.reduce(price_rules, checkout, fn {code, discount}, checkout ->
      count = product_count(checkout, code)
      Discount.apply(discount, [count, code, checkout])
    end)
  end

  @spec total(t) :: float
  def total(%Checkout{items: items, discount: discount}) do
    Enum.reduce(items, 0, &(&1.price + &2)) - discount
  end
end
