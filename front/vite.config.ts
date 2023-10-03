import { defineConfig } from 'vite'
import preact from '@preact/preset-vite'
import generouted from '@generouted/react-router/plugin'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [preact(), generouted()],
})
