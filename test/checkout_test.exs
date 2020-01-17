defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  test "greets the world" do
    assert Checkout.hello() == :world
  end
end
