<script lang="ts">
	import type { PageData } from './$houdini'

	export let data: PageData

	$: ({ RootQuery } = data)
</script>

<h1>Welcome to SvelteKit</h1>
{#each $RootQuery.data?.buses || [] as bus }
	<p>{bus.name}</p>
	{#if bus.description}
		<p>{bus.description}</p>
	{/if}
{/each}
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
