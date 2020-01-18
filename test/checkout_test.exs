defmodule CheckoutTest do
  use ExUnit.Case
  alias Checkout.Product

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
  end
end
