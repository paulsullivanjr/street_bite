defmodule StreetBite.FoodTrucks do
  @moduledoc """
  FoodTrucks context
  """
  import Ecto.Query

  alias StreetBite.FoodTruck
  alias StreetBite.Repo

  @spec load_food_trucks() :: %Scrivener.Page{entries: list(FoodTruck.t())}
  def load_food_trucks do
    StreetBite.Repo.paginate(FoodTruck)
  end

  def search_food_trucks(location_term, food_type_term, page \\ 1) do
    FoodTruck
    |> add_location_search(location_term)
    |> add_food_type_search(food_type_term)
    |> Repo.paginate(page: page)
  end

  defp add_location_search(query, nil), do: query

  defp add_location_search(query, location_term),
    do: where(query, [ft], ilike(ft.location_description, ^"%#{location_term}%"))

  defp add_food_type_search(query, nil), do: query

  defp add_food_type_search(query, food_type_term),
    do: where(query, [ft], ilike(ft.food_items, ^"%#{food_type_term}%"))
end
