defmodule BikeBus.Repo.Migrations.AddLocationToBus do
  use Ecto.Migration

  def change do
    alter table(:buses) do
      add :location, :map
    end
  end
end
