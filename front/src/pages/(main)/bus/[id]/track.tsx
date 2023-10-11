import { useSignal, useSignalEffect } from "@preact/signals"
import { graphql } from '@/gql/gql'
import { useMutation } from "urql"
import { useParams } from "@/router"

const mutation = graphql(`
  mutation UpdateLocation($id: ID!, $latitude: Float!, $longitude: Float!) {
    updateLocation(input: { busId: $id, latitude: $latitude, longitude: $longitude }) {
      bus {
        id
      }
    }
  }
`)

const clearLocation = graphql(`
  mutation ClearLocation($id: ID!) {
    clearLocation(input: { busId: $id }) {
      bus {
        id
      }
    }
  }
`)

export default function () {
  const [stuff, mutate] = useMutation(mutation)
  const [_, clearMutate] = useMutation(clearLocation)
  const tracking = useSignal(false)
  const { id } = useParams("/bus/:id/track")

  useSignalEffect(() => {
    if (tracking.value) {
      const clearId = navigator.geolocation.watchPosition(position => {
        mutate({
          id,
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        })
      }, (error => console.error(error)))

      return () => {
        console.log("Clearing watch")
        navigator.geolocation.clearWatch(clearId)
        clearMutate({
          id,
        })
      }
    }
  })

  return (
    <div class="mt-4">
      <h2 class="text-2xl font-semibold">Track the bus</h2>
      <p></p>
      <button onClick={() => tracking.value = !tracking.value}>{tracking.value ? "Stop tracking" : "Start tracking"}</button>
      {
        tracking.value && stuff.fetching && <p>Updating location...</p>
      }
    </div>
  )
}