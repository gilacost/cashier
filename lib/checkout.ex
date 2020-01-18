defmodule Checkout do
  @moduledoc """
  """

  defstruct items: %{}, price_rules: %{}

  @type t :: %__MODULE__{
          items: map,
          price_rules: map
        }

  @spec new(list) :: t
  def new(price_rules), do: %Checkout{price_rules: price_rules}

  @spec add_item(t, String.t()) :: t
  def add_item(checkout, product) do
    Map.update(
      checkout,
      :items,
      [product],
      fn products -> [product | products] end
    )
  end

  defmodule Product do
    defstruct code: "", name: "", price: 0

    @products %{
      "GR1" => Checkout.Product.GreenTea
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
  end
end
