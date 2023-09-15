defmodule BikeBus.TrackerTest do
  use BikeBus.DataCase

  alias BikeBus.Tracker

  describe "buses" do
    alias BikeBus.Tracker.Bus

    import BikeBus.TrackerFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_buses/0 returns all buses" do
      bus = bus_fixture()
      assert Tracker.list_buses() == [bus]
    end

    test "get_bus!/1 returns the bus with given id" do
      bus = bus_fixture()
      assert Tracker.get_bus!(bus.id) == bus
    end

    test "create_bus/1 with valid data creates a bus" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Bus{} = bus} = Tracker.create_bus(valid_attrs)
      assert bus.name == "some name"
      assert bus.description == "some description"
    end

    test "create_bus/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_bus(@invalid_attrs)
    end

    test "update_bus/2 with valid data updates the bus" do
      bus = bus_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Bus{} = bus} = Tracker.update_bus(bus, update_attrs)
      assert bus.name == "some updated name"
      assert bus.description == "some updated description"
    end

    test "update_bus/2 with invalid data returns error changeset" do
      bus = bus_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_bus(bus, @invalid_attrs)
      assert bus == Tracker.get_bus!(bus.id)
    end

    test "delete_bus/1 deletes the bus" do
      bus = bus_fixture()
      assert {:ok, %Bus{}} = Tracker.delete_bus(bus)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_bus!(bus.id) end
    end

    test "change_bus/1 returns a bus changeset" do
      bus = bus_fixture()
      assert %Ecto.Changeset{} = Tracker.change_bus(bus)
    end
  end
end
