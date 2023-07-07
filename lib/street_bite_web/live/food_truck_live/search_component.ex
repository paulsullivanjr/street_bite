defmodule StreetBiteWeb.FoodTruckLive.SearchComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, search: "", search_food_type: "")}
  end

  def handle_event("search", %{"search" => search_query}, socket) do
    {:noreply, assign(socket, :search, search_query)}
  end

  def handle_params(%{"search" => search}, _uri, socket) do
    {:noreply, assign(socket, :search, search)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <form phx-submit="search">
        <input
          type="text"
          name="location_search"
          placeholder="Search by location"
          phx-target={@myself}
        />
        <input
          type="text"
          name="food_type_search"
          value={@search_food_type}
          phx-target={@myself}
          placeholder="Search by Food Type"
        />

        <button
          type="submit"
          class="px-4 py-2 bg-blue-600 text-white rounded shadow hover:bg-blue-700 focus:outline-none"
        >
          Search
        </button>
      </form>
    </div>
    """
  end
end
