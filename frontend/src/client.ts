import { HoudiniClient } from '$houdini';
import { subscription } from '$houdini/plugins'
import { createClient } from 'graphql-ws'

export default new HoudiniClient({
    url: 'http://localhost:4000/graphql',
    plugins: [
        subscription(() => createClient({
            url: 'ws://localhost:4000/graphql/subscriptions'
        }))
    ]

    // uncomment this to configure the network call (for things like authentication)
    // for more information, please visit here: https://www.houdinigraphql.com/guides/authentication
    // fetchParams({ session }) {
    //     return {
    //         headers: {
    //             Authentication: `Bearer ${session.token}`,
    //         }
    //     }
    // }
})
