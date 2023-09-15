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
        |> post("/graphql", %{
          "query" => @list_query
        })
        |> json_response(200)

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
        |> post("/graphql", %{
          "query" => @list_query
        })
        |> json_response(200)

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
        |> post("/graphql", %{
          "query" => @create_bus,
          "variables" => %{
            "name" => "Testing",
            "description" => "Testing description"
          }
        })
        |> json_response(200)

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
        |> post("/graphql", %{
          "query" => @create_bus,
          "variables" => %{
            "name" => "Testing",
            "description" => "Testing description"
          }
        })
        |> json_response(200)

      fetched_bus =
        response
        |> get_in(["data", "createBus", "bus", "id"])
        |> BikeBus.Tracker.get_bus!()

      assert fetched_bus.name == "Testing"
      assert fetched_bus.description == "Testing description"
    end
  end
end
