<script lang="ts">
	import { graphql, fragment, type BusHomeDetails } from '$houdini'

	export let bus: BusHomeDetails

	$: data = fragment(bus, graphql(`
		fragment BusHomeDetails on Bus {
			id
			name
			location {
				latitude
				longitude
			}
		}
	`))

	const updates = graphql(`
		subscription BusUpdates($busId: ID!) {
			busUpdated(busId: $busId) {
				id
				name
				location {
					latitude
					longitude
				}
			}
		}
	`)

	$: updates.listen({ busId: $data.id! })
	$: location = $updates.data?.busUpdated?.location || $data.location
</script>

<h2>{$data.name}</h2>

{#if location}
	<p>Latitude: {location.latitude}</p>
	<p>Longitude: {location.longitude}</p>
{/if}
