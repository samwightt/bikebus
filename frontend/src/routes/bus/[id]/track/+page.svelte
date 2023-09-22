<script lang="ts">
	import type { PageData } from './$houdini'
	import { graphql } from '$houdini'

	export let data: PageData

	$: ({ TrackBusInfo } = data)
	$: bus = $TrackBusInfo.data?.bus

	let listener: null | number = null

	const updatePosition = graphql(`
		mutation StartTracking($id: ID!, $latitude: Float!, $longitude: Float!) {
			updateLocation(input: {
				busId: $id,
				latitude: $latitude,
				longitude: $longitude
			}) {
				bus {
					id
				}
			}
		}
	`)

	const clearPosition = graphql(`
		mutation ClearTracking($id: ID!) {
			clearLocation(input: { busId: $id}) {
				bus {
					id
				}
			}
		}
	`)

	function startTracking() {
		if (listener === null) {
			listener = navigator.geolocation.watchPosition((position) => {
				console.log(position.coords)
				updatePosition.mutate({
					id: bus!.id!,
					latitude: position.coords.latitude,
					longitude: position.coords.longitude
				})
			}, (error) => console.log(error), {
				enableHighAccuracy: true,
				timeout: 5000,
				maximumAge: 3000
			})
		}
	}

	async function stopTracking() {
		if (listener !== null) {
			navigator.geolocation.clearWatch(listener)
			clearPosition.mutate({ id: bus!.id! })
			listener = null
		}
	}
</script>

{#if bus}
	<h1>Start tracking {bus.name}...</h1>
	{#if listener !== null}
	 	<h1>Tracking!!</h1>
		<p>Please leave your phone open.</p>
		<button on:click={stopTracking}>Stop tracking</button>
	{:else}
		<button on:click={startTracking}>Start tracking...</button>
	{/if}
{/if}
