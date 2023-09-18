defmodule BikeBus.Tracker do
  @moduledoc """
  The Tracker context.
  """

  import Ecto.Query, warn: false
  alias BikeBus.Repo

  alias BikeBus.Tracker.Bus

  @doc """
  Returns the list of buses.

  ## Examples

      iex> list_buses()
      [%Bus{}, ...]

  """
  def list_buses do
    Repo.all(Bus)
  end

  @doc """
  Gets a single bus.

  Raises `Ecto.NoResultsError` if the Bus does not exist.

  ## Examples

      iex> get_bus!(123)
      %Bus{}

      iex> get_bus!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bus!(id), do: Repo.get!(Bus, id)

  @doc """
  Creates a bus.

  ## Examples

      iex> create_bus(%{field: value})
      {:ok, %Bus{}}

      iex> create_bus(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bus(attrs \\ %{}) do
    %Bus{}
    |> Bus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bus.

  ## Examples

      iex> update_bus(bus, %{field: new_value})
      {:ok, %Bus{}}

      iex> update_bus(bus, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bus(%Bus{} = bus, attrs) do
    bus
    |> Bus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bus.

  ## Examples

      iex> delete_bus(bus)
      {:ok, %Bus{}}

      iex> delete_bus(bus)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bus(%Bus{} = bus) do
    Repo.delete(bus)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bus changes.

  ## Examples

      iex> change_bus(bus)
      %Ecto.Changeset{data: %Bus{}}

  """
  def change_bus(%Bus{} = bus, attrs \\ %{}) do
    Bus.changeset(bus, attrs)
  end
end
