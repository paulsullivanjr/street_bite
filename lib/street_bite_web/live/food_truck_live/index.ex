defmodule StreetBiteWeb.FoodTruckLive.Index do
  use Phoenix.LiveView

  alias StreetBite.FoodTruck

  def mount(_params, _session, socket) do
    {:ok, assign(socket, food_trucks: [], search: "")}
  end

  def handle_params(_params, _url, socket) do
    {:ok, socket} = load_food_trucks(socket)
    {:noreply, socket}
  end

  def handle_event("nav", %{"page" => page_number}, socket) do
    page_number = String.to_integer(page_number)
    search_term = socket.assigns.search
    location_search = socket.assigns.location_search
    food_search = socket.assigns.food_type_search

    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = StreetBite.FoodTrucks.search_food_trucks(location_search, food_search, page_number)

    assigns = [
      search: search_term,
      food_trucks: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]

    new_socket = assign(socket, assigns)
    {:noreply, new_socket}
  end

  def handle_event(
        "search",
        %{"location_search" => location_term, "food_type_search" => food_type_term},
        socket
      ) do
    location_term = if(location_term == "", do: nil, else: location_term)
    food_type_term = if(food_type_term == "", do: nil, else: food_type_term)

    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = StreetBite.FoodTrucks.search_food_trucks(location_term, food_type_term)

    assigns = [
      location_search: location_term,
      food_type_search: food_type_term,
      food_trucks: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp fetch_data(socket, page_number) do
    page = StreetBite.Repo.paginate(FoodTruck, page: page_number)

    assign(socket,
      food_trucks: page.entries,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      page_size: page.page_size
    )
  end

  defp load_food_trucks(socket) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = StreetBite.FoodTrucks.load_food_trucks()

    assigns = [
      conn: socket,
      search: "",
      food_trucks: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]

    {:ok, assign(socket, assigns)}
  end
end
