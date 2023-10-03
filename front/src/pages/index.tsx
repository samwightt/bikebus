import { useQuery, gql } from 'urql'

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
      {result.data.buses.map((bus: any) => (<p key={bus.id}>{bus.name}</p>))}
    </div>
  )
}