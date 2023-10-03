import { client } from '@/lib/urql'
import { Params, useParams } from '@/router'
import { graphql } from '@/gql/gql'
import { useQuery } from 'urql'

const ShowBus = graphql(`
  query ShowBus($id: ID!) {
    bus(id: $id) {
      id
      name
      description
    }
  }
`)

export const Loader = ({ params }: { params: Params['/bus/:id'] }) => {
  console.log("LOADING")
  const { id } = params
  return client.query(ShowBus, { id }).toPromise
}

export default function () {
  const { id } = useParams('/bus/:id')
  const [result] = useQuery({
    query: ShowBus,
    variables: {
      id
    }
  })

  if (result.fetching || !result?.data?.bus) {
    return <h1>Loading...</h1>
  }

  return <div>
    <h1>{result.data.bus.name}</h1>
    <p>{result.data.bus.description}</p>
  </div>
}