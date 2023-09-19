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

## Environment variables

The following environment variables are available for configuration:

### Frontend

These environment variables are static, meaning they are included at build time. **Changes to these environment variables require rebuilding the frontend or the frontend container**.

- `PUBLIC_API_SERVER_URL` - The URL base of the API server. Must include the protocol. In development, this is `http://localhost:4000`. If a path is included in this URL, the frontend will append `/graphql` to it.

## Backend

These environment variables are configured at runtime and do *not* require recompiling the app or the app's container. See `server/config/release.exs` for further documentation:

- `MIX_ENV` - This should be set to `prod` in production.
- `DATABASE_URL` - The `postgresql://` [connection URL](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING-URIS) for the Postgres database.
- `PHX_HOST` - The host of the app. In development this is `localhost`
- `PORT` - The port to run the server on.
- `SECRET_KEY_BASE` - The key used to sign and encrypt cookies + other secrets. Generate this with `mix phx.gen.secret`, or use a sufficiently long key.
- `ECTO_IPV6` - Set to `true` or `1` for Postgres databases that require IPV6 for connection.
- `POOL_SIZE` - The size of the DB connection pool. `10` by default.

## Stack

The backend is written in Elixir and the frontend is written in Svelte with SvelteKit. The two communicate using GraphQL. The backend runs a GraphQL server built with Absinthe that uses Phoenix channels for subscriptions. The frontend uses Houdini to request and display content from the backend. The SvelteKit app is compiled in SPA mode as we don't need SSR or prerendering.

## Principles

1. Cheapness of hosting collectively should be prioritized over ease of self-installation / hosting.
2. The architecture of the app should be simple and use as few moving parts as possible.
3. Don't reinvent the wheel. If other services do something well (and for free), don't reimplement the feature unless absolutely necessary.
4. Build all features using a common, open API so that third-party developers can build their own tooling on top of it.
