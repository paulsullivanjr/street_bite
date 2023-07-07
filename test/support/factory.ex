defmodule StreetBite.Factory do
  @moduledoc """
  ExMachina factory
  """
  use ExMachina.Ecto, repo: StreetBite.Repo

  def food_truck_factory do
    %StreetBite.FoodTruck{
      location_description: sequence(:location_description, &"Location #{&1}"),
      food_items: sequence(:food_items, &"Food Type #{&1}"),
      status: "status",
      applicant: "applicant",
      facility_type: "facility_type"
    }
  end
end
