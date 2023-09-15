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
end
