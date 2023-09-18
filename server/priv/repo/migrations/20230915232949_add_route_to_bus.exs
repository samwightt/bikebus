defmodule BikeBus.Repo.Migrations.AddRouteToBus do
  use Ecto.Migration

  def change do
    alter table(:buses) do
      add(:route, :string)
    end
  end
end
