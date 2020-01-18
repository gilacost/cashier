defmodule Checkout do
  @moduledoc """
  """

  defstruct items: %{}, price_rules: %{}

  @type t :: %__MODULE__{
          items: list,
          price_rules: list
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
end
