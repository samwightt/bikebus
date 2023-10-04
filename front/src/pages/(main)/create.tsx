import { useSignal, useComputed, useSignalEffect } from "@preact/signals";
import { gpx } from "@mapbox/togeojson";

function Form() {
  const name = useSignal("");
  const description = useSignal("");
  const files = useSignal<FileList | null>(null);

  const firstFile = useComputed(() => {
    if (files.value) {
      if (files.value.length <= 0) return;
      return files.value.item(0);
    }
  });
  const fileArrayBuffer = useSignal<ArrayBuffer | null>(null);

  useSignalEffect(() => {
    if (!firstFile.value) return;
    firstFile.value
      ?.arrayBuffer()
      .then((buffer) => (fileArrayBuffer.value = buffer));
  });

  const geojsonString = useComputed(() => {
    if (!fileArrayBuffer.value) return;

    const firstFileString = new TextDecoder().decode(fileArrayBuffer.value);
    const firstFileXml = new DOMParser().parseFromString(
      firstFileString,
      "text/xml"
    );
    const geojson: string = gpx(firstFileXml);
    return JSON.stringify(geojson);
  });

  useSignalEffect(() => {
    console.log("HI");
    console.log(geojsonString.value);
  });

  const isValid = useComputed(
    () =>
      name.value.trim() !== "" &&
      geojsonString.value &&
      geojsonString.value?.trim().length > 0
  );

  const disabled = useComputed(() => !isValid.value);

  return (
    <form>
      <div class="form-control w-full">
        <label class="label label-text">Bus name</label>
        <input
          type="text"
          value={name}
          placeholder="eg. Lakeview Bus"
          onInput={(e) => (name.value = e.currentTarget.value)}
          class="input input-bordered w-full"
        />
      </div>
      <div class="form-control w-full">
        <label class="label label-text">Description</label>
        <textarea
          placeholder="eg. This is the bus for Lakeview"
          value={description}
          onInput={(e) => (description.value = e.currentTarget.value)}
          class="input input-bordered w-full"
        />
      </div>
      <div class="form-control w-full">
        <label class="label label-text">GPX File</label>
        <input
          type="file"
          placeholder="Only GPX files."
          class="input input-bordered w-full"
          onInput={(e) => (files.value = e.currentTarget.files)}
        />
      </div>
      <button class="btn mt-4" type="submit" disabled={disabled}>
        Create bus
      </button>
    </form>
  );
}

export default function CreateBus() {
  return (
    <div>
      <h1 class="text-4xl font-bold">Create a bus</h1>
      <div>
        <Form />
      </div>
    </div>
  );
}
