defmodule BikeBus.Tracker.Bus do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "buses" do
    field :name, :string
    field :description, :string
    field :route, :string

    timestamps()
  end

  @doc false
  def changeset(bus, attrs) do
    bus
    |> cast(attrs, [:name, :description, :route])
    |> validate_required([:name, :route])
  end
end
