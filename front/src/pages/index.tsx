import { useQuery } from 'urql'
import { graphql } from '../gql/gql'
import { Link } from '@/router'

const BusQuery = graphql(`
  query busesQuery {
    buses {
      id
      name
      description
    }
  }
`)

export default function Home() {
  const [result] = useQuery({
    query: BusQuery,
    variables: {}
  })

  if (result.fetching) {
    return <h1>Loading...</h1>
  }

  return (
    <div>
      <h1>Buses</h1>
      {result.data?.buses.map((bus) => (
        <Link to="/bus/:id" params={{ id: bus.id! }}>
          <p key={bus.id}>{bus.name} - </p>
        </Link>
      ))}
    </div>
  )
}