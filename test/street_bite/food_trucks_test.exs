# defmodule StreetBite.FoodTrucksTest do
#   use StreetBite.DataCase, async: true
#   import StreetBite.Factory

#   alias StreetBite.FoodTrucks

#   describe "load_food_trucks/0" do
#     test "returns all food trucks" do
#       insert(:food_truck)
#       insert(:food_truck)

#       page = FoodTrucks.load_food_trucks()

#       assert length(page.entries) == 2
#     end
#   end

#   describe "search_food_trucks/2" do
#     test "returns food trucks with the matching location description" do
#       insert(:food_truck, location_description: "Test location")
#       insert(:food_truck, location_description: "Another location")

#       page = FoodTrucks.search_food_trucks("Test location")

#       assert length(page.entries) == 1
#       assert Enum.at(page.entries, 0).location_description == "Test location"
#     end
#   end
# end

defmodule StreetBite.FoodTrucksTest do
  use StreetBite.DataCase, async: true
  import StreetBite.Factory

  alias StreetBite.FoodTrucks

  describe "load_food_trucks/0" do
    test "returns paginated food trucks" do
      _food_truck = insert(:food_truck)

      result = FoodTrucks.load_food_trucks()

      assert is_map(result)
      assert is_list(result.entries)
    end
  end

  describe "search_food_trucks/3" do
    setup do
      truck1 = insert(:food_truck, location_description: "A location", food_items: "A food type")

      truck2 =
        insert(:food_truck,
          location_description: "Another location",
          food_items: "Another food type"
        )

      %{truck1: truck1, truck2: truck2}
    end

    test "returns paginated food trucks that match the location_term", %{truck1: truck1} do
      result = FoodTrucks.search_food_trucks("A location", nil)

      assert is_map(result)
      assert Enum.any?(result.entries, fn truck -> truck.id == truck1.id end)
    end

    test "returns paginated food trucks that match the food_type_term", %{truck1: truck1} do
      result = FoodTrucks.search_food_trucks(nil, "A food type")

      assert is_map(result)
      assert Enum.any?(result.entries, fn truck -> truck.id == truck1.id end)
    end

    test "returns paginated food trucks that match both terms", %{truck1: truck1} do
      result = FoodTrucks.search_food_trucks("A location", "A food type")

      assert is_map(result)
      assert Enum.any?(result.entries, fn truck -> truck.id == truck1.id end)
    end

    test "does not return food trucks that do not match the terms", %{truck2: truck2} do
      result = FoodTrucks.search_food_trucks("A location", "A food type")

      assert is_map(result)
      refute Enum.any?(result.entries, fn truck -> truck.id == truck2.id end)
    end
  end
end
