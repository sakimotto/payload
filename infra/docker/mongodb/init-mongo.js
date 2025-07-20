// This script is executed when MongoDB is initialized for the first time
// It creates the initial database and user

// Get environment variables or use defaults
const dbName = process.env.MONGO_INITDB_DATABASE || 'zervios';
const rootUser = process.env.MONGO_INITDB_ROOT_USERNAME;
const rootPassword = process.env.MONGO_INITDB_ROOT_PASSWORD;

// Connect to MongoDB instance
db = db.getSiblingDB(dbName);

// Create application user with proper permissions
db.createUser({
  user: rootUser,
  pwd: rootPassword,
  roles: [
    {
      role: 'readWrite',
      db: dbName,
    },
    {
      role: 'dbAdmin',
      db: dbName,
    },
  ],
});

// Create collections (MongoDB will create them automatically, but this makes them explicit)
db.createCollection('users');
db.createCollection('media');
db.createCollection('payload-preferences');
db.createCollection('payload-migrations');

// Add indexes for better performance
db.users.createIndex({ email: 1 }, { unique: true });
db.media.createIndex({ filename: 1 });

print('MongoDB initialization completed successfully');