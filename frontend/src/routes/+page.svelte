<script lang="ts">
	import type { PageData } from './$houdini'
	import Bus from './Bus.svelte';

	export let data: PageData

	$: ({ RootQuery } = data)
	$: buses = $RootQuery.data?.buses
</script>

<h1>Welcome to SvelteKit</h1>
{#each buses || [] as bus }
	<Bus bus={bus} />
{/each}
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
