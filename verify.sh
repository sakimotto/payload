#!/bin/bash
# ZerviOS Verification Script
# This script checks if all Docker containers are running properly

echo "ZerviOS Verification Script"
echo "============================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "Error: Docker is not running or not accessible"
  exit 1
fi

echo "✓ Docker is running"

# Check if containers are running
echo -e "\nChecking container status..."
CONTAINERS=$(docker-compose ps -q)
if [ -z "$CONTAINERS" ]; then
  echo "Error: No containers are running. Start them with 'docker-compose up -d'"
  exit 1
fi

docker-compose ps
echo "✓ Containers are running"

# Check MongoDB connection
echo -e "\nChecking MongoDB connection..."
docker-compose exec -T mongodb mongosh --host mongodb \
  --username $MONGO_INITDB_ROOT_USERNAME \
  --password $MONGO_INITDB_ROOT_PASSWORD \
  --eval "db.adminCommand('ping')" > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Error: Cannot connect to MongoDB"
  exit 1
fi

echo "✓ MongoDB is accessible"

# Check Payload CMS health
echo -e "\nChecking Payload CMS health..."
PAYLOAD_HEALTH=$(curl -s http://localhost:3000/api/health || echo "")
if [[ "$PAYLOAD_HEALTH" != *"healthy"* ]]; then
  echo "Error: Payload CMS is not healthy"
  echo "Response: $PAYLOAD_HEALTH"
  exit 1
fi

echo "✓ Payload CMS is healthy"

# Check frontend access
echo -e "\nChecking frontend access..."
FRONTEND_STATUS=$(curl -s -I http://localhost:3001 | head -n 1 || echo "")
if [[ "$FRONTEND_STATUS" != *"200 OK"* && "$FRONTEND_STATUS" != *"304 Not Modified"* ]]; then
  echo "Warning: Frontend might not be accessible"
  echo "Response: $FRONTEND_STATUS"
else
  echo "✓ Frontend is accessible"
fi

# Check Redis if enabled
echo -e "\nChecking Redis connection..."
docker-compose exec -T redis redis-cli -a $REDIS_PASSWORD ping > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Warning: Cannot connect to Redis (this is optional)"
else
  echo "✓ Redis is accessible"
fi

echo -e "\n✅ Verification completed successfully!"
echo "ZerviOS is running properly."
echo ""
echo "Access your applications at:"
echo "- Payload CMS Admin: http://localhost:3000/admin"
echo "- Frontend: http://localhost:3001"
echo ""
echo "To stop the services, run: docker-compose down"