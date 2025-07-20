import { buildConfig } from 'payload/config';
import path from 'path';

// Import collections
import Users from './collections/Users';
import Media from './collections/Media';
// Import other collections as needed

// Import globals
import Settings from './globals/Settings';
// Import other globals as needed

export default buildConfig({
  serverURL: process.env.PAYLOAD_PUBLIC_SERVER_URL,
  admin: {
    user: 'users', // Points to the users collection
    meta: {
      titleSuffix: '- ZerviOS Admin',
      favicon: '/assets/favicon.ico',
      ogImage: '/assets/og-image.jpg',
    },
  },
  collections: [
    Users,
    Media,
    // Add other collections
  ],
  globals: [
    Settings,
    // Add other globals
  ],
  typescript: {
    outputFile: path.resolve(__dirname, 'payload-types.ts'),
  },
  graphQL: {
    schemaOutputFile: path.resolve(__dirname, 'generated-schema.graphql'),
  },
  cors: [
    process.env.NEXT_PUBLIC_SITE_URL || '',
  ],
  csrf: [
    process.env.NEXT_PUBLIC_SITE_URL || '',
  ],
  upload: {
    limits: {
      fileSize: 5000000, // 5MB, adjust as needed
    },
  },
});