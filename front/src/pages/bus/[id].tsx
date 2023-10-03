import { client } from "@/lib/urql";
import { Link, Params, useParams } from "@/router";
import { graphql } from "@/gql/gql";
import { useQuery } from "urql";
import { useEffect, useMemo } from "preact/hooks";
import Map, { Layer, Source, useMap } from "react-map-gl/maplibre";
import { LngLatBounds } from "maplibre-gl";

const ShowBus = graphql(`
  query ShowBus($id: ID!) {
    bus(id: $id) {
      id
      name
      description
      route
    }
  }
`);

export const Loader = ({ params }: { params: Params["/bus/:id"] }) => {
  console.log("LOADING");
  const { id } = params;
  return client.query(ShowBus, { id }).toPromise;
};

function Route(props: { route?: string }) {
  const { current: map } = useMap();
  const parsedJson = useMemo(() => {
    if (props.route) {
      return JSON.parse(props.route);
    }
    return null;
  }, [props.route]);

  const coordinates = parsedJson && parsedJson.features[0].geometry.coordinates;

  const bounds = useMemo(() => {
    if (coordinates) {
      const latlngbound = new LngLatBounds({
        lat: coordinates[0][0],
        lng: coordinates[0][1],
      });
      for (let coordinate of coordinates) {
        latlngbound.extend(coordinate);
      }
      return latlngbound;
    }
    return null;
  }, [coordinates]);

  console.log(bounds, map);

  return (
    <Source type="geojson" data={parsedJson}>
      <Layer
        type="line"
        layout={{
          "line-join": "round",
          "line-cap": "round",
        }}
        paint={{
          "line-color": "#000",
          "line-width": 8,
        }}
      />
    </Source>
  );
}

export default function () {
  const { id } = useParams("/bus/:id");
  const [result] = useQuery({
    query: ShowBus,
    variables: {
      id,
    },
  });

  if (result.fetching || !result?.data?.bus) {
    return <h1>Loading...</h1>;
  }

  const parsedJson = useMemo(() => {
    if (result.data?.bus?.route) {
      return JSON.parse(result.data.bus.route);
    }
    return null;
  }, [result.data.bus.route]);

  const coordinates = parsedJson && parsedJson.features[0].geometry.coordinates;

  const bounds = useMemo(() => {
    if (coordinates) {
      const latlngbound = new LngLatBounds({
        lat: coordinates[0][0],
        lng: coordinates[0][1],
      });
      for (let coordinate of coordinates) {
        latlngbound.extend(coordinate);
      }
      return latlngbound;
    }
  }, [coordinates]);

  return (
    <div>
      <p class="text-2xl mb-4">
        <Link to="/">Bike Bus</Link>
      </p>
      <h1 class="text-4xl font-bold mb-8">{result.data.bus.name}</h1>
      <p>{result.data.bus.description}</p>
      <Map
        style={{
          width: "100%",
          height: "60vh",
        }}
        initialViewState={{
          bounds: bounds,
          zoom: 14,
          fitBoundsOptions: {
            padding: 20,
          },
        }}
        mapStyle="https://tiles.stadiamaps.com/styles/alidade_smooth.json"
      >
        <Route route={result.data.bus.route} />
      </Map>
    </div>
  );
}
