import { buildConfig } from 'payload/config';
import { mongooseAdapter } from '@payloadcms/db-mongodb';
import { webpackBundler } from '@payloadcms/bundler-webpack';
import { slateEditor } from '@payloadcms/richtext-slate';
import path from 'path';

// Import collections
import { Users } from './collections/Users.js';
import { Media } from './collections/Media.js';
// Import other collections as needed

// Import globals
import { Settings } from './globals/Settings.js';
// Import other globals as needed

export default buildConfig({
  serverURL: process.env.PAYLOAD_PUBLIC_SERVER_URL,
  admin: {
    user: 'users', // Points to the users collection
    bundler: webpackBundler(),
    meta: {
      titleSuffix: '- ZerviOS Admin',
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
  db: mongooseAdapter({
    url: process.env.DATABASE_URI,
  }),
  editor: slateEditor({}),
});