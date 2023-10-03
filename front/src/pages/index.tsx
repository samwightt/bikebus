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
      <h1 class="text-4xl mb-4 font-semibold">Bike Bus</h1>
      <p class="mb-8">Bike Bus is an app for tracking bike buses and group rides. It's free to use and <a
        href="https://github.com/samwightt/bikebus" class="underline">completely open source</a>.
      </p>
      <h2 class="text-2xl font-medium">Buses</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8 my-16">
        {result.data?.buses.map((bus) => (
          <Link to="/bus/:id" params={{ id: bus.id! }} key={bus.id}>
            <div class="card w-full bg-white ">
              <div class="card-body">
                <h3 class="card-title">
                  {bus.name}
                </h3>
                {bus.description && <p>{bus.description}</p>}
              </div>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
}