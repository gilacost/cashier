defmodule Checkout.Product do
  alias __MODULE__
  # TODO not found exception
  # TODO invert dependency
  # TODO callbacks for product
  # TODO default discount rule
  #
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
  alias Checkout.Product

  defstruct items: [], price_rules: %{}

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
  end

  @spec total(t) :: float
  def total(%Checkout{items: items}) do
    Enum.reduce(items, 0, &(&1.price + &2))
  end
end
