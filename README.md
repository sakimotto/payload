# ZerviOS

A modern headless CMS platform built with Payload CMS, MongoDB, and Next.js, all containerized with Docker.

## Overview

ZerviOS is a complete full-stack application that combines the power of Payload CMS for content management with a Next.js frontend for delivering that content to users. The entire stack is containerized using Docker for easy deployment and development.

### Key Features

- **Headless CMS**: Payload CMS provides a flexible and customizable content management system
- **RESTful & GraphQL APIs**: Access your content through multiple API options
- **Modern Frontend**: Next.js frontend with server-side rendering capabilities
- **Containerized**: Everything runs in Docker containers for consistency across environments
- **Scalable**: Each service can be scaled independently as needed

## Documentation

- [Architecture Documentation](docs/ARCHITECTURE.md) - System design and component overview
- [Development Guide](docs/DEVELOPMENT.md) - Setup and development workflow
- [API Documentation](docs/API.md) - API endpoints and integration details
- [Deployment Guide](docs/DEPLOYMENT.md) - Production deployment instructions
- [Security Documentation](docs/SECURITY.md) - Security measures and best practices
- [Setup Checklist](docs/CHECKLIST.md) - Comprehensive setup and verification checklist

## Project Structure

```
ZerviOS/
├── src/                 # Source code
│   ├── payload/         # Payload CMS backend
│   └── frontend/        # Next.js frontend
├── infra/               # Infrastructure configuration
│   └── docker/          # Docker-specific configurations
├── docs/                # Documentation
├── scripts/             # Utility scripts
├── docker-compose.yml   # Docker Compose configuration
└── .env                 # Environment variables
```

## Prerequisites

- Docker and Docker Compose installed
- Node.js and npm (for local development)
- Git

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd ZerviOS
```

### 2. Configure Environment Variables

```bash
cp env.example .env
```

Edit the `.env` file to set your desired configuration values.

### 3. Start the Docker Containers

```bash
docker-compose up -d
```

This will start all the required services:
- MongoDB database
- Payload CMS backend
- Next.js frontend
- Redis cache (optional)

### 4. Access the Applications

- **Payload CMS Admin**: http://localhost:3000/admin
  - Default login: admin@zervios.com / password123 (change in production!)
- **Frontend**: http://localhost:3001
- **API**: http://localhost:3000/api

## Development Workflow

### Running in Development Mode

The default Docker Compose configuration is set up for development:

```bash
docker-compose up -d
```

In development mode:
- Source code directories are mounted into containers
- Code changes are reflected immediately (hot reloading)
- Debug logging is enabled

### Building for Production

For production deployment:

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

The production configuration:
- Builds optimized container images
- Disables development features
- Optimizes for performance rather than development convenience

### Stopping the Services

```bash
docker-compose down
```

To remove volumes as well (WARNING: this deletes all data):

```bash
docker-compose down -v
```

## Verification

To verify that all services are running correctly:

```bash
./verify.sh
```

This script checks:
- Container status
- MongoDB connection
- Payload CMS health
- Frontend access
- Redis connection (if enabled)

## License

[MIT License](LICENSE)

## Acknowledgments

- [Payload CMS](https://payloadcms.com/)
- [Next.js](https://nextjs.org/)
- [MongoDB](https://www.mongodb.com/)
- [Docker](https://www.docker.com/)