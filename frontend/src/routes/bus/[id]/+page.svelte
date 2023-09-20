<script lang="ts">
	import type { PageData } from './$houdini'

	export let data: PageData
	$: ({ BusInfo } = data)

	$: bus = $BusInfo.data?.bus
</script>

<h1 class="text-5xl mb-5 font-bold">{bus?.name}</h1>
{#if bus?.description}
	<p class="text-xl">{bus?.description}</p>
{/if}
