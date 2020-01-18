defmodule CheckoutTest do
  use ExUnit.Case
  alias Checkout.Product

  @valid_product_codes ["GR1", "SR1", "CR1"]

  describe "checkout" do
    test "new" do
      assert %Checkout{items: [], price_rules: []} = Checkout.new([])
    end

    test "adds a new product to the checkout items list" do
      assert %{items: ["item"]} =
               []
               |> Checkout.new()
               |> Checkout.add_item("item")
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
        assert %Product{} = Product.new(code)
      end)

      assert {:ok, %Product{code: _, name: _, price: _}} = Product.new("GR1")
    end
  end
end
