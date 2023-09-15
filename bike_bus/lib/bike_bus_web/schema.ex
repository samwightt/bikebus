defmodule BikeBusWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  import Brex.Result.Base

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

    @desc "Gets a single bus with the given the id."
    field :bus, :bus do
      @desc "The id of the bus to get. Must be a UUID."
      arg(:id, non_null(:id))

      resolve(fn _parent, args, _ ->
        {:ok, BikeBus.Tracker.get_bus!(args.id)}
      end)
    end
  end

  mutation do
    @desc "Creates a new bike bus."
    payload field :create_bus do
      input do
        @desc "The name of the bus."
        field :name, non_null(:string)
        @desc "An optional description of the bus. Plain text. Not escaped."
        field :description, :string
      end

      output do
        @desc "The created bus."
        field :bus, non_null(:bus)
      end

      resolve(fn input_attrs, _ ->
        input_attrs
        |> BikeBus.Tracker.create_bus()
        |> fmap(fn bus -> %{bus: bus} end)
      end)
    end
  end
end
