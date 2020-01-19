defmodule Cashier.Product do
  alias __MODULE__
  defstruct code: "", name: "", price: 0

  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: float()
        }

  @type code :: String.t()

  @products %{
    "GR1" => %{name: "Green Tea", price: 3.11},
    "SR1" => %{name: "Strawberries", price: 5.0},
    "CR1" => %{name: "Coffee", price: 11.23}
  }

  @spec new(code) :: {:ok, %Product{}} | {:error, :not_found}
  def new(code) do
    @products
    |> Map.get(code)
    |> case do
      %{} = product ->
        product =
          Product
          |> struct(product)
          |> Map.put(:code, code)

        {:ok, product}

      nil ->
        {:error, :not_found}
    end
  end

  @spec price(code) :: float | nil
  def price(code), do: Map.get(@products, code)[:price]
end
