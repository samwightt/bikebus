# bikebus

BikeBus is open source software for tracking bike buses. It is GPL V3 licensed, cheap to host, and easy to run. It is built to run on mobile web browsers.

A [bike bus](https://en.wikipedia.org/wiki/Bike_bus) is a group of people who cycle together on a set route following a set timetable. Crucial to running a bike bus is a tracker. Much like the tracker or maps for a transit agency, a bike bus tracker allows users to see the current location of the bike bus and estimate when they need to leave to join up with the bus at their stop.

While other tracking software exists, it is either not open source, expensive to scale / host, or does not allow easy use by end-users without a dev holding their hand. This project aims to resolve that by being cheap-to-host open source software that is user-friendly and scales well.

## Installation

This project has the following dependencies:

- Elixir 1.15.5
- Node v18.16.0
- pnpm package manager
- Postgres server

Download and clone the repo.

To start the server:

```bash
cd server
# Get dependencies
mix deps.get
# Set up the database.
mix ecto.setup
# Start the server.
# Go to http://localhost:4000/graphiql to see the GraphQL server.
mix phx.server
```

To start the frontend dev server:

```bash
cd frontend
# Install dependencies.
pnpm install
# Start the dev server.
pnpm dev
```

## Stack

The backend is written in Elixir and the frontend is written in Svelte with SvelteKit. The two communicate using GraphQL. The backend runs a GraphQL server built with Absinthe that uses Phoenix channels for subscriptions. The frontend uses Houdini to request and display content from the backend. The SvelteKit app is compiled in SPA mode as we don't need SSR or prerendering.

## Principles

1. Cheapness of hosting collectively should be prioritized over ease of self-installation / hosting.
2. The architecture of the app should be simple and use as few moving parts as possible.
3. Don't reinvent the wheel. If other services do something well (and for free), don't reimplement the feature unless absolutely necessary.
4. Build all features using a common, open API so that third-party developers can build their own tooling on top of it.
