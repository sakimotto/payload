import express from 'express';
import { getPayload } from 'payload';
import { resolve } from 'node:path';
import { config } from 'dotenv';
import configPromise from './payload.config.js';

// Load environment variables
config();

const app = express();
const port = process.env.PORT || 3001;

// Initialize Payload
const start = async () => {
  try {
    const payload = await getPayload({
      config: configPromise,
      secret: process.env.PAYLOAD_SECRET || 'your-secret-here',
    });

    app.use('/api', payload.router);

    // Add your own express routes here

    app.listen(port, () => {
      console.log(`Server listening on port ${port}`);
      console.log(`Payload Admin URL: http://localhost:${port}/admin`);
    });
  } catch (error) {
    console.error(`Error starting server: ${error.message}`);
    process.exit(1);
  }
};

start();