import { HoudiniClient } from '$houdini';
import { subscription } from '$houdini/plugins'
import { createClient } from 'graphql-ws'
import { PUBLIC_API_SERVER_URL } from '$env/static/public'

const GRAPHQL_URL = new URL('graphql', PUBLIC_API_SERVER_URL).href

const subscriptionBase = new URL('graphql/subscriptions', PUBLIC_API_SERVER_URL)
subscriptionBase.protocol = 'ws'
const SUBSCRIPTION_URL = subscriptionBase.href

export default new HoudiniClient({
    url: GRAPHQL_URL,
    plugins: [
        subscription(() => createClient({
            url: SUBSCRIPTION_URL
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
