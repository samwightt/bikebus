<script lang="ts">
	import { onMount } from 'svelte';
	import type { PageData } from './$houdini'
	import * as maplibregl from 'maplibre-gl'

	export let data: PageData
	$: ({ BusInfo } = data)

	$: bus = $BusInfo.data?.bus

	let div: HTMLElement

	onMount(() => {
		const map = new maplibregl.Map({
			container: div,
			style: "https://tiles.stadiamaps.com/styles/alidade_smooth.json",
			zoom: 15
		})

		return () => {
			map.remove()
		}
	})

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
