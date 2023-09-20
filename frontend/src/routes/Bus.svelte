<script lang="ts">
	import { graphql, fragment, type BusHomeDetails } from '$houdini'

	export let bus: BusHomeDetails

	$: data = fragment(bus, graphql(`
		fragment BusHomeDetails on Bus {
			id
			name
			description
			location {
				latitude
				longitude
			}
		}
	`))
</script>

<div class="my-4">
	<h2 class="text-3xl font-semibold mb-3 flex flex-row items-center gap-4">
		<a href={`/bus/${$data.id}`}>
			{$data.name}
			{#if $data.location}
				<span class="text-white bg-red-500 rounded-md px-2 py-1 font-semibold text-sm inline-block">LIVE</span>
			{/if}
		</a>
	</h2>
	{#if $data.description}
		<p class="">{$data.description}</p>
	{/if}
</div>
