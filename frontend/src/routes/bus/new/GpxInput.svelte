<script lang="ts">
	import { gpx } from '@mapbox/togeojson'

	export let jsonString: string | null = null

	let files: FileList | undefined

	$: firstFile = files && files.length > 0 ? files.item(0) : null
	let firstFileContent: ArrayBuffer | null =  null

	$: firstFile?.arrayBuffer()?.then(buffer => firstFileContent = buffer)
	$: firstFileString = firstFileContent && new TextDecoder().decode(firstFileContent)
	$: firstFileXml = firstFileString && new DOMParser().parseFromString(firstFileString, "text/xml")
	$: geojson = firstFileXml && gpx(firstFileXml)
	$: geojsonString = (geojson && JSON.stringify(geojson)) ?? null

	$: jsonString = geojsonString
</script>

<label>
	Upload a gpx file
	<input type="file" bind:files accept="application/gpx+xml" />
</label>
