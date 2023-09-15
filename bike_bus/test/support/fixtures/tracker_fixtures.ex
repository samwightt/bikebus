defmodule BikeBus.TrackerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BikeBus.Tracker` context.
  """

  @doc """
  Generate a bus.
  """
  def bus_fixture(attrs \\ %{}) do
    {:ok, bus} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description"
      })
      |> BikeBus.Tracker.create_bus()

    bus
  end
end
