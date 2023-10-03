import { CodegenConfig } from '@graphql-codegen/cli'

export default {
  schema: '../schema.graphql',
  documents: ['src/**/*.{ts,tsx,js,jsx}'],
  ignoreNoDocuments: true,
  generates: {
    './src/gql/': {
      preset: 'client',
      plugins: [],
    }
  }
} as CodegenConfig