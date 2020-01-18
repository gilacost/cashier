defmodule CheckoutTest do
  use ExUnit.Case
  alias Checkout.Product

  @valid_product_codes ["GR1", "SR1", "CR1"]

  describe "checkout" do
    test "new" do
      assert %Checkout{items: [], price_rules: %{}} = Checkout.new(%{})
    end

    test "adds a new product to the checkout items list" do
      {:ok, random_product} =
        @valid_product_codes
        |> Enum.random()
        |> Product.new()

      assert %{items: [random_product]} =
               %{}
               |> Checkout.new()
               |> Checkout.add_item(random_product)
    end

    test "total return the sum of all the product prices in the checkout" do
      {:ok, green_tea} = Product.new("GR1")
      {:ok, coffe} = Product.new("CR1")

      assert 14.34 ==
               %{}
               |> Checkout.new()
               |> Checkout.add_item(coffe)
               |> Checkout.add_item(green_tea)
               |> Checkout.total()
    end
  end

  describe "product" do
    test "new has code, name and price" do
      assert {:ok, %Product{code: _, name: _, price: _}} = Product.new("GR1")
    end

    test "valid products" do
      # TODO get them from env?
      # TODO setup all
      Enum.each(@valid_product_codes, fn code ->
        assert {:ok, %Product{}} = Product.new(code)
      end)
    end
  end
end
