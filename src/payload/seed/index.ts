import { Payload } from 'payload';

export const seed = async (payload: Payload): Promise<void> => {
  // Create an admin user
  await payload.create({
    collection: 'users',
    data: {
      email: 'admin@zervios.com',
      password: 'password123', // Change in production!
      name: 'Admin User',
      roles: ['admin'],
    },
  });

  // Create site settings
  await payload.updateGlobal({
    slug: 'settings',
    data: {
      siteName: 'ZerviOS',
      siteDescription: 'A modern CMS-powered platform',
      // Logo and favicon will need to be added after media uploads are created
    },
  });

  console.log('Seed completed successfully!');
};

export default seed;