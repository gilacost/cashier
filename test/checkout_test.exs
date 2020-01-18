defmodule CheckoutTest do
  use ExUnit.Case

  describe "checkout" do
    test "new" do
      assert %Checkout{items: [], price_rules: []} = Checkout.new([])
    end

    test "adds a new product to the checkout items list" do
      assert %{items: [%Product{}]}
    end
  end
end
