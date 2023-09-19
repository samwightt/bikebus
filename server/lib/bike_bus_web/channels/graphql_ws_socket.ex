defmodule BikeBusWeb.GraphqlWsSocket do
  use Absinthe.GraphqlWS.Socket, schema: BikeBusWeb.Schema
end
