<script lang="ts">
	import type { PageData } from './$houdini'
	import Bus from './Bus.svelte';

	export let data: PageData

	$: ({ RootQuery } = data)
	$: buses = $RootQuery.data?.buses
</script>

<div class="mb-10">
<h1 class="text-5xl font-bold mb-8">BikeB.us</h1>
<p>This is a site for tracking bike buses. Click one of the buses below to track it.</p>
</div>

{#each buses || [] as bus }
	<Bus bus={bus} />
{/each}
