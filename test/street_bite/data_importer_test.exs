defmodule StreetBite.DataImporterTest do
  use StreetBite.DataCase, async: true

  import ExUnit.CaptureLog

  alias StreetBite.Repo
  alias StreetBite.DataImporter
  alias StreetBite.FoodTruck

  test "import_from_csv/1 imports data from a valid CSV file" do
    assert [] = Repo.all(FoodTruck)

    capture_log(fn ->
      DataImporter.import_from_csv("../test/fixtures/data/test_food_trucks.csv")
    end)

    food_trucks = Repo.all(FoodTruck)
    assert Enum.all?(food_trucks, fn ft -> %FoodTruck{} = ft end)
  end

  test "import_from_csv/1 does not import data from a non-existent CSV file" do
    capture_log(fn ->
      DataImporter.import_from_csv("non_existent_file.csv")
    end) =~ "Failed to open file non_existent_file.csv. File does not exist."

    assert [] = Repo.all(FoodTruck)
  end

  test "import_from_directory/0 does not import if directory does not exist" do
    Application.put_env(:street_bite, :data_directory, "non_existent_directory")

    capture_log(fn ->
      DataImporter.import_from_directory()
    end) =~ "Failed to open directory non_existent_directory. Directory does not exist."

    assert Enum.empty?(Repo.all(FoodTruck))
  end

  test "import_from_csv/1 does not import if CSV file has wrong format" do
    data_directory = Path.absname(Path.join([File.cwd!(), "test", "fixtures", "data"]))

    Application.put_env(:street_bite, :data_directory, data_directory)
    DataImporter.import_from_csv("test_wrong_format.csv")

    assert [] == Repo.all(FoodTruck)
  end

  test "import_from_csv/1 does not import rows with missing or invalid data" do
    data_directory = Path.absname(Path.join([File.cwd!(), "test", "fixtures", "data"]))

    Application.put_env(:street_bite, :data_directory, data_directory)
    DataImporter.import_from_csv("test_missing_data.csv")

    num_rows =
      (data_directory <> "/test_missing_data.csv")
      |> File.stream!()
      |> Stream.drop(1)
      |> Enum.count()

    assert length(Repo.all(FoodTruck)) < num_rows
  end

  test "import_from_directory/0 does not import from non-CSV files" do
    Application.put_env(:street_bite, :data_directory, "test/fixtures/data/non_csv_files")

    capture_log(fn ->
      DataImporter.import_from_directory()
    end) =~ "Data directory does not exist"

    assert [] == Repo.all(FoodTruck)
  end
end
