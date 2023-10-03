import { useQuery, gql } from 'urql'
import { Link } from '@/router'

const BusQuery = gql`
  query {
    buses {
      id
      name
    }
  }
`

export default function Home() {
  const [result] = useQuery({
    query: BusQuery
  })

  if (result.fetching) {
    return <h1>Loading...</h1>
  }

  return (
    <div>
      <h1>Buses</h1>
      {result.data.buses.map((bus: any) => (
        <Link to="/bus/:id" params={{ id: bus.id }}>
          <p key={bus.id}>{bus.name}</p>
        </Link>
      ))}
    </div>
  )
}