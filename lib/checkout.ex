defmodule Checkout.Product do
  alias __MODULE__

  defstruct code: "", name: "", price: 0

  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: float()
        }

  @products %{
    "GR1" => Checkout.Product.GreenTea,
    "SR1" => Checkout.Product.Strawberries,
    "CR1" => Checkout.Product.Coffe
  }

  @type product_code :: String.t()

  @spec new(product_code) :: {:ok, %Product{}}
  def new(product_code) do
    product =
      @products
      |> Map.get(product_code)
      |> apply(:new, [])

    {:ok, product}
  end

  defmodule GreenTea do
    def new(), do: %Product{code: "GR1", name: "Green Tea", price: 3.11}
  end

  defmodule Strawberries do
    def new(), do: %Product{code: "SR1", name: "Strawberries", price: 5.0}
  end

  defmodule Coffe do
    def new(), do: %Product{code: "CR1", name: "Coffe", price: 11.23}
  end
end

defmodule Checkout do
  alias Checkout.{Product, Discount}

  defstruct items: [], price_rules: %{}, discount: 0

  @type t :: %__MODULE__{
          items: list,
          price_rules: map
        }

  @spec new(list) :: t
  def new(price_rules), do: %Checkout{price_rules: price_rules}

  @spec add_item(t, Product.t()) :: t()
  def add_item(checkout, %Product{} = product) do
    checkout =
      %{checkout | discount: 0}
      |> Map.update(
        :items,
        [product],
        &[product | &1]
      )

    checkout
    |> Discount.get_one_free(product_count(checkout, "GR1"))
    |> Discount.bulk("SR1", product_count(checkout, "SR1"))
    |> Discount.bulk("CR1", product_count(checkout, "CR1"))
  end

  @spec product_count(%Checkout{}, String.t()) :: integer
  defp product_count(%Checkout{items: items}, code),
    do: Enum.count(items, &(&1.code == code))

  @spec total(t) :: float
  def total(%Checkout{items: items, discount: discount}) do
    Enum.reduce(items, 0, &(&1.price + &2)) - discount
  end
end

defmodule Checkout.Discount do
  alias Checkout
  alias Checkout.Product.{GreenTea, Coffe}

  @spec get_one_free(%Checkout{}, integer) :: %Checkout{}
  def get_one_free(%Checkout{} = checkout, count) when count > 1 do
    discount = floor(count / 2) * GreenTea.new().price

    Map.update(checkout, :discount, 0, &(&1 + discount))
  end

  def get_one_free(%Checkout{} = checkout, _count), do: checkout

  @spec bulk(%Checkout{}, String.t(), integer) :: %Checkout{}
  def bulk(%Checkout{} = checkout, code, count) when count > 2 do
    discount =
      case code do
        "SR1" -> count * 0.5
        "CR1" -> count * Coffe.new().price * 1 / 3
      end

    Map.update(checkout, :discount, 0, &(&1 + discount))
  end

  def bulk(%Checkout{} = checkout, _code, _count), do: checkout
end
