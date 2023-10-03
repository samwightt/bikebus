import { ComponentChildren } from 'preact'
import { Client, cacheExchange, fetchExchange, Provider as UrqlProvider, subscriptionExchange } from 'urql'
import { createClient as createWSClient } from 'graphql-ws'

const wsClient = createWSClient({
  url: 'ws://localhost:4000/graphql/subscriptions'
})

export const client = new Client({
  url: 'http://localhost:4000/graphql',
  exchanges: [cacheExchange, fetchExchange, subscriptionExchange({
    forwardSubscription(request) {
      const input = { ...request, query: request.query || '' }
      return {
        subscribe(sink) {
          const unsubscribe = wsClient.subscribe(input, sink)
          return { unsubscribe }
        }
      }
    }
  })]
})

export function Provider(props: { children: ComponentChildren }) {
  return <UrqlProvider value={client}>
    {props.children}
  </UrqlProvider>
}