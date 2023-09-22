<script lang="ts">
	import { goto } from '$app/navigation';
	import { graphql } from '$houdini'
	import GpxInput from './GpxInput.svelte';

	let name = ""
	let description = ""
	let password = ""
	let route: string | null = null

	$: console.log(route)

	$: formReady = name.length > 0 && password.length > 0 && route !== null

	const mutation = graphql(`
		mutation CreateBus($name: String!, $description: String!, $password: String!, $route: String!) {
			createBus(input: {
				name: $name,
				description: $description,
				password: $password,
				route: $route
			}) {
				bus {
					id
				}
			}
		}
	`)

	const handleSubmit = async (e) => {
		e.preventDefault()
		if (formReady && route) {
			mutation.mutate({
				name,
				description,
				password,
				route
			}).then(x => {
				if (x.data?.createBus?.bus.id) {
					goto(`/bus/${x.data.createBus.bus.id}`)
				}
			})
		}
	}
</script>

<p>Create a new bus</p>

<form on:submit|preventDefault={handleSubmit}>
	<div>
		<label>
			Name
			<input type="text" bind:value={name} />
		</label>
	</div>
	<div>
		<label>
			Description
			<input type="text" bind:value={description} />
		</label>
	</div>
	<div>
		<label>
			Password
			<input type="password" bind:value={password} />
		</label>
	</div>
	<div>
		<GpxInput bind:jsonString={route} />
	</div>
	<button type="submit" disabled={!formReady}>Create bus</button>
</form>
