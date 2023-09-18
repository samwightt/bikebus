defmodule BikeBus.Repo do
  use Ecto.Repo,
    otp_app: :bike_bus,
    adapter: Ecto.Adapters.Postgres
end
