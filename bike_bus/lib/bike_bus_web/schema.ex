defmodule BikeBusWeb.Schema do
  use Absinthe.Schema

  @desc "A bike bus that people can track on the map."
  object :bus do
    @desc "The id of the bus."
    field :id, :id
    @desc "The name of the bus."
    field :name, non_null(:string)
    @desc "An optional description of the bus. Plain text. Not escaped."
    field :description, :string
  end

  query do
    @desc "A list of all of the buses."
    field :buses, list_of(:bus) do
      resolve(fn _parent, _args, _resolution ->
        {:ok, BikeBus.Tracker.list_buses()}
      end)
    end
  end
end
