defmodule CheckoutTest do
  use ExUnit.Case

  describe "checkout" do
    test "new" do
      assert %{items: [], price_rules: []} = Checkout.new([])
    end
  end
end
