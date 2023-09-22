<script lang="ts">
	import { onMount } from 'svelte';
	import type { PageData } from './$houdini'
	import * as maplibregl from 'maplibre-gl'

	export let data: PageData
	$: ({ BusInfo } = data)

	$: bus = $BusInfo.data?.bus
	$: route = bus?.route && JSON.parse(bus?.route)

	let div: HTMLElement
	let map: maplibregl.Map | null = null

	onMount(() => {
		map = new maplibregl.Map({
			container: div,
			style: "https://tiles.stadiamaps.com/styles/alidade_smooth.json",
			zoom: 15
		})

		return () => {
			map?.remove()
		}
	})

	$: coordinates = route && route.features[0].geometry.coordinates
	$: bounds = coordinates ? new maplibregl.LngLatBounds({
		lat: coordinates[0][0],
		lng: coordinates[0][1]
	}) : null
	$: {
		 if (coordinates)  {
				for (let coordinate of coordinates) {
					bounds?.extend(coordinate)
				}
		}
	}

	function recenter() {
		if (bounds && map) {
			map?.fitBounds(bounds, {
				padding: 20,
				animate: false
			})
		}
	}

	let loaded = false
	$: map?.on('load', () => {
		loaded = true
	})
	$: {
		if (loaded) {
			if (map?.getSource('route')) {
				map?.removeSource('route');
			}
			map?.addSource('route', {
				type: 'geojson',
				data: route
			})
			map?.addLayer({
				id: 'route',
				type: 'line',
				source: 'route',
				'layout': {
					'line-join': 'round',
					'line-cap': 'round'
				},
				'paint': {
					'line-color': "#000",
					'line-width': 8
				}
			})
			recenter()
		}
	}

</script>

<h1 class="text-5xl mb-5 font-bold">{bus?.name}</h1>
{#if bus?.description}
	<p class="text-xl">{bus?.description}</p>
{/if}

<div bind:this={div} />

<style>
	div {
		max-height: 70vh;
		height: 70vh;
	}
</style>
