defmodule BikeBus.Repo.Migrations.CreateBuses do
  use Ecto.Migration

  def change do
    create table(:buses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
