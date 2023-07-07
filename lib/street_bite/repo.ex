defmodule StreetBite.Repo do
  use Ecto.Repo,
    otp_app: :street_bite,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 25
end
