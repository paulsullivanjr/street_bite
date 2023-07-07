defmodule StreetBite.Repo.Migrations.CreateFoodTrucks do
  use Ecto.Migration

  def change do
    create table(:food_trucks) do
      add :location_id, :integer
      add :applicant, :string
      add :facility_type, :string
      add :cnn, :integer
      add :location_description, :string
      add :address, :string
      add :blocklot, :string
      add :block, :string
      add :lot, :string
      add :status, :string
      add :food_items, :text
      add :schedule, :text
      add :days_hours, :string
      add :x, :decimal
      add :y, :decimal
      add :latitude, :decimal
      add :longitude, :decimal
      add :fire_prevention_district, :integer
      add :police_district, :integer
      add :supervisor_district, :integer
      add :zip_code, :integer

      timestamps()
    end

    create unique_index(:food_trucks, [:location_id])
  end
end
