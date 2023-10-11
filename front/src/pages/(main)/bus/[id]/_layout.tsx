import { client } from "@/lib/urql";
import { graphql } from "@/gql/gql";
import { useParams, Params } from "@/router";
import { Outlet } from 'react-router-dom'
import { useQuery } from "urql";

const BusDetails = graphql(`
  query BusDetails($id: ID!) {
    bus(id: $id) {
      name
      description
    }
  }
`)

export const Loader = ({ params }: { params: Params["/bus/:id"] }) => {
  const { id } = params;
  return client.query(BusDetails, { id }).toPromise();
};

export default function () {
  const { id } = useParams('/bus/:id')
  const [{ data }] = useQuery({
    query: BusDetails,
    variables: {
      id
    }
  })

  return (
    <div>
      {data && data.bus && (
        <>
          <h1 class="text-4xl font-bold mb-8">{data.bus.name}</h1>
          <p>{data.bus.description}</p>
        </>
      )}
      <Outlet />
    </div>
  )
}