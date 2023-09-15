defmodule BikeBus.Tracker.Bus do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "buses" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(bus, attrs) do
    bus
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
