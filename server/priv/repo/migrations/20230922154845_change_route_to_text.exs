defmodule BikeBus.Repo.Migrations.ChangeRouteToText do
  use Ecto.Migration


  def up do
    alter table(:buses) do
      modify :route, :text
    end
  end

  def down do
    alter table(:buses) do
      modify :route, :string
    end
  end
end
