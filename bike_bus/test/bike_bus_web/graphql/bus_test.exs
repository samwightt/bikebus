defmodule BikeBusWeb.Graphql.BusTest do
  use BikeBusWeb.ConnCase, async: true

  describe "listing buses" do
    @list_query """
    query {
      buses {
        id
        name
        description
        route
      }
    }
    """
    @route "{\"some_route\": true}"

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
          description: "Testing description",
          route: @route
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
                     "description" => bus.description,
                     "route" => @route
                   }
                 ]
               }
             }
    end
  end

  describe "bus creation" do
    @create_bus """
    mutation($name: String!, $description: String, $route: String!, $password: String!) {
      createBus(input: {
        name: $name,
        description: $description,
        route: $route,
        password: $password
      }) {
        bus {
          id
          name
          description
        }
      }
    }
    """

    @route "{\"some_route\": true}"
    @password "password"

    setup do
      Application.put_env(:bike_bus, :creation_password, @password)
    end

    test "creates a bus", %{conn: conn} do
      response =
        conn
        |> graphql_request(@create_bus, %{
          "name" => "Testing",
          "description" => "Testing description",
          "route" => @route,
          "password" => @password
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
          "description" => "Testing description",
          "route" => @route,
          "password" => @password
        })

      fetched_bus =
        response
        |> get_in(["data", "createBus", "bus", "id"])
        |> BikeBus.Tracker.get_bus!()

      assert fetched_bus.name == "Testing"
      assert fetched_bus.description == "Testing description"
    end

    test "requires valid password", %{conn: conn} do
      response =
        conn
        |> graphql_request(@create_bus, %{
          "name" => "Testing",
          "description" => "Testing description",
          "route" => @route,
          "password" => "Not the password"
        })

      assert response = %{
        "errors" => [
        ]
      }
    end
  end

  describe "getting a bus" do
    test "gets a bus stored in the db", %{conn: conn} do
      route = "{some_route: true}"
      {:ok, bus} =
        BikeBus.Tracker.create_bus(%{name: "Testing", description: "Testing description", route: route})

      query = """
        query($id: ID!) {
          bus(id: $id) {
            id
            name
            description
            route
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
                   "description" => "Testing description",
                   "route" => route
                 }
               }
             } == response
    end
  end

  describe "current bus location" do
    @query """
    query($id: ID!) {
      bus(id: $id) {
        location {
          latitude
          longitude
        }
      }
    }
    """

    test "is nil by default", %{conn: conn} do
      {:ok, bus} = BikeBus.Tracker.create_bus(%{name: "Testing", description: "Testing description", route: "{some_route: true}"})
      response = graphql_request(conn, @query, %{"id" => bus.id})
      assert response == %{"data" => %{"bus" => %{"location" => nil}}}
    end

    test "can be set via mutation", %{conn: conn} do
      {:ok, bus} = BikeBus.Tracker.create_bus(%{name: "Testing", description: "Testing description", route: "{some_route: true}"})
      mutation = """
      mutation ($id: ID!, $latitude: Float!, $longitude: Float!) {
        updateLocation(input: { busId: $id, latitude: $latitude, longitude: $longitude }) {
          bus {
            id
          }
        }
      }
      """

      input_vars = %{
        "id" => bus.id,
        "latitude" => 1.0,
        "longitude" => 2.0
      }

      response = graphql_request(conn, mutation, input_vars)

      assert response == %{"data" => %{"updateLocation" => %{"bus" => %{"id" => bus.id}}}}

      response = graphql_request(conn, @query, %{"id" => bus.id})
      assert response == %{"data" => %{"bus" => %{"location" => %{"latitude" => 1.0, "longitude" => 2.0}}}}
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
