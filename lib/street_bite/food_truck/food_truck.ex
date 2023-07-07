defmodule StreetBite.FoodTruck do
  @moduledoc """
  FoodTruck schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "food_trucks" do
    field :address, :string
    field :applicant, :string
    field :block, :string
    field :blocklot, :string
    field :cnn, :integer
    field :days_hours, :string
    field :facility_type, :string
    field :food_items, :string
    field :location_description, :string
    field :location_id, :integer
    field :lot, :string
    field :schedule, :string
    field :status, :string
    field :x, :decimal
    field :y, :decimal
    field :latitude, :decimal
    field :longitude, :decimal
    field :fire_prevention_district, :integer
    field :police_district, :integer
    field :supervisor_district, :integer
    field :zip_code, :integer

    timestamps()
  end

  @doc false
  def changeset(food_truck, attrs) do
    food_truck
    |> cast(attrs, [
      :location_id,
      :applicant,
      :facility_type,
      :cnn,
      :location_description,
      :address,
      :blocklot,
      :block,
      :lot,
      :status,
      :food_items,
      :schedule,
      :days_hours
    ])
    |> validate_required([
      :location_id,
      :applicant,
      :facility_type,
      :cnn,
      :location_description,
      :address,
      :blocklot,
      :block,
      :lot,
      :status,
      :food_items,
      :schedule,
      :days_hours
    ])
  end
end
