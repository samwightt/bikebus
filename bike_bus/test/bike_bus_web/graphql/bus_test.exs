defmodule BikeBusWeb.Graphql.BusTest do
  use BikeBusWeb.ConnCase, async: true

  describe "listing buses" do
    @list_query """
    query {
      buses {
        id
        name
        description
      }
    }
    """

    test "returns an empty array when there are no buses", %{conn: conn} do
      response =
        conn
        |> graphql_request(@list_query)

      assert response == %{"data" => %{"buses" => []}}
    end

    test "returns a list of buses", %{conn: conn} do
      {:ok, bus} =
        BikeBus.Tracker.create_bus(%{
          name: "Testing",
          description: "Testing description"
        })

      response =
        conn
        |> graphql_request(@list_query)

      assert response == %{
               "data" => %{
                 "buses" => [
                   %{
                     "id" => bus.id,
                     "name" => bus.name,
                     "description" => bus.description
                   }
                 ]
               }
             }
    end
  end

  describe "bus creation" do
    @create_bus """
    mutation($name: String!, $description: String) {
      createBus(input: {
        name: $name,
        description: $description
      }) {
        bus {
          id
          name
          description
        }
      }
    }
    """

    test "creates a bus", %{conn: conn} do
      response =
        conn
        |> graphql_request(@create_bus, %{
          "name" => "Testing",
          "description" => "Testing description"
        })

      assert %{
               "data" => %{
                 "createBus" => %{
                   "bus" => %{"name" => "Testing", "description" => "Testing description"}
                 }
               }
             } = response
    end

    test "persists bus to db", %{conn: conn} do
      response =
        conn
        |> graphql_request(@create_bus, %{
          "name" => "Testing",
          "description" => "Testing description"
        })

      fetched_bus =
        response
        |> get_in(["data", "createBus", "bus", "id"])
        |> BikeBus.Tracker.get_bus!()

      assert fetched_bus.name == "Testing"
      assert fetched_bus.description == "Testing description"
    end
  end

  describe "getting a bus" do
    test "gets a bus stored in the db", %{conn: conn} do
      {:ok, bus} =
        BikeBus.Tracker.create_bus(%{name: "Testing", description: "Testing description"})

      query = """
        query($id: ID!) {
          bus(id: $id) {
            id
            name
            description
          }
        }
      """

      response =
        conn
        |> graphql_request(query, %{"id" => bus.id})

      assert %{
               "data" => %{
                 "bus" => %{
                   "id" => bus.id,
                   "name" => "Testing",
                   "description" => "Testing description"
                 }
               }
             } == response
    end
  end

  defp graphql_request(conn, query, variables \\ %{}) when is_binary(query) and is_struct(conn, Plug.Conn) do
    conn
    |> post("/graphql", %{
      "query" => query,
      "variables" => variables
    })
    |> json_response(200)
  end
end
