import { defineConfig } from 'vite'
import preact from '@preact/preset-vite'
import generouted from '@generouted/react-router/plugin'
import tsconfig from 'vite-tsconfig-paths'
import codegen from 'vite-plugin-graphql-codegen';


// https://vitejs.dev/config/
export default defineConfig({
  plugins: [tsconfig(), preact(), generouted(), codegen()],
})
