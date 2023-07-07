defmodule StreetBite.DataImporter do
  @moduledoc """
  This module handles the import of data from CSV files.
  """

  require Logger
  alias StreetBite.Repo
  alias StreetBite.FoodTruck

  @doc """
  Reads all files in the configured data directory and imports them.
  """

  def import_from_directory do
    dir = data_dir()

    if File.dir?(dir) do
      Logger.info("Starting data import")

      dir
      |> File.ls!()
      |> Enum.each(&import_from_csv/1)
    else
      Logger.error("Data directory does not exist: #{dir}")
    end
  end

  @doc """
  Imports food truck data from the provided CSV file into the database.

  ## Parameters

  - `file_name`: A string representing the name of the file (including the extension) to import from.
    The file should be located in the directory specified by `data_dir()`.

  ## Process

  1. Checks if the provided file exists.
  2. Opens the file as a stream and skips the header row.
  3. Parses the CSV data using `NimbleCSV.RFC4180.parse_stream/1`.
  4. Transforms each parsed row into a map ready for insertion into the database using `row_to_food_truck_map/1`.
  5. Chunks the data into chunks of size 1000 (can be adjusted based on requirements).
  6. Inserts each chunk into the `FoodTruck` database table using `Repo.insert_all/3`. In case of conflict on `location_id`, it replaces all fields with the new data.

  ## Logs

  - Logs an info message with the name of the file it is processing at the start.
  - If the file does not exist, it logs an error message.

  ## Returns

  - This function does not return a meaningful value. Its main purpose is to perform side effects (i.e., importing data into the database).
  """
  def import_from_csv(nil), do: :ok

  def import_from_csv(file_name) do
    Logger.info("Processing file: #{file_name}")
    file_path = Path.join(data_dir(), file_name)

    if File.exists?(file_path) do
      try do
        file_path
        |> File.stream!()
        |> Stream.drop(1)
        |> NimbleCSV.RFC4180.parse_stream()
        |> Stream.map(&row_to_food_truck_map/1)
        |> Enum.chunk_every(1_000)
        |> Enum.each(
          &Repo.insert_all(FoodTruck, &1,
            on_conflict: :replace_all,
            conflict_target: [:location_id]
          )
        )

        :ok
      rescue
        e in NimbleCSV.ParseError ->
          Logger.error("Failed to parse CSV file #{file_name}: #{e.message}")
          {:error, e.message}
      end
    else
      Logger.error("Failed to open file #{file_name}. File does not exist.")
    end
  end

  defp row_to_food_truck_map(row) do
    [
      location_id,
      applicant,
      facility_type,
      cnn,
      location_description,
      address,
      blocklot,
      block,
      lot,
      _permit,
      status,
      food_items,
      x,
      y,
      latitude,
      longitude,
      _schedule,
      _dayshours,
      _noi_sent,
      _approved,
      _received,
      _priorpermit,
      _expirationdate,
      _location,
      fire_prevention_district,
      police_district,
      supervisor_district,
      zip_code,
      _neighborhoods_old
    ] = row

    %{
      location_id: String.to_integer(location_id),
      applicant: applicant,
      facility_type: facility_type,
      cnn: String.to_integer(cnn),
      location_description: location_description,
      address: address,
      blocklot: blocklot,
      block: block,
      lot: lot,
      status: status,
      food_items: food_items,
      x: string_to_decimal(x),
      y: string_to_decimal(y),
      latitude: Decimal.new(latitude),
      longitude: Decimal.new(longitude),
      fire_prevention_district: string_to_integer(fire_prevention_district),
      police_district: string_to_integer(police_district),
      supervisor_district: string_to_integer(supervisor_district),
      zip_code: string_to_integer(zip_code),
      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
  end

  defp data_dir do
    Application.get_env(:street_bite, :data_directory)
  end

  defp string_to_decimal(""), do: nil
  defp string_to_decimal(s), do: Decimal.new(s)
  defp string_to_integer(""), do: nil
  defp string_to_integer(s), do: String.to_integer(s)
end
