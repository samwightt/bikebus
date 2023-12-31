import { client } from "@/lib/urql";
import { Params, useParams } from "@/router";
import { graphql } from "@/gql/gql";
import { useQuery } from "urql";
import { useMemo } from "preact/hooks";
import Map, { Layer, Source } from "react-map-gl/maplibre";
import { LngLatBounds } from "maplibre-gl";

const ShowBus = graphql(`
  query ShowBus($id: ID!) {
    bus(id: $id) {
      id
      route
    }
  }
`);

export const Loader = ({ params }: { params: Params["/bus/:id"] }) => {
  const { id } = params;
  return client.query(ShowBus, { id }).toPromise();
};

function Route(props: { route?: string }) {
  const parsedJson = useMemo(() => {
    if (props.route) {
      try {
        return JSON.parse(props.route);
      } catch (e) {
        return null;
      }
    }
    return null;
  }, [props.route]);

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

export default function ShowBusPage() {
  const { id } = useParams("/bus/:id");
  const [{ data, fetching }] = useQuery({
    query: ShowBus,
    variables: {
      id,
    },
  });

  if (fetching || !data?.bus) {
    return <h1>Loading...</h1>;
  }

  const parsedJson = useMemo(() => {
    if (data.bus?.route) {
      try {
        return JSON.parse(data.bus.route);
      } catch (e) {
        return null;
      }
    }
    return null;
  }, [data.bus.route]);

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
        <Route route={data.bus.route} />
      </Map>
    </div>
  );
}
