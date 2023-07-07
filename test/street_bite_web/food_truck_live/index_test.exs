defmodule StreetBiteWeb.FoodTruckLive.IndexTest do
  use StreetBiteWeb.ConnCase
  import Phoenix.LiveViewTest
  import StreetBite.Factory

  describe "mount/3" do
    test "loads and assigns empty food_trucks", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      assert html =~ "No food trucks found"
      assert view |> element("input[name='location_search']") |> render() =~ "Search"
    end
  end

  describe "handle_params/3" do
    test "loads food trucks", %{conn: conn} do
      food_truck = insert(:food_truck)
      {:ok, view, _html} = live(conn, "/")

      assert render(view) =~ food_truck.location_description
    end
  end

  describe "handle_event/3" do
    test "navigates to different pages", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      send(view.pid, {:handle_event, "nav", %{"page" => "2"}})

      assert render(view) =~ "2"
    end

    test "searches for food trucks", %{conn: conn} do
      food_truck = insert(:food_truck)
      {:ok, view, _html} = live(conn, "/")

      send(
        view.pid,
        {:handle_event, "search", %{"location_search" => food_truck.location_description}}
      )

      assert render(view) =~ food_truck.location_description
    end
  end
end
