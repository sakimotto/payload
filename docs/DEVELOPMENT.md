# ZerviOS Development Guide

## Development Environment Setup

### Prerequisites

- Docker Desktop
- Node.js 18+
- Git
- VS Code (recommended)

### Initial Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd ZerviOS
```

2. Environment configuration:
```bash
cp env.example .env
```

Edit `.env` with required values:
- MongoDB credentials
- Okta OIDC configuration
- Azure OpenAI API keys
- External service endpoints

3. Start development environment:
```bash
docker-compose up -d
```

### Development URLs

- Payload CMS Admin: http://localhost:3000/admin
- Frontend: http://localhost:3001
- API: http://localhost:3000/api

## Project Structure

### Backend (Payload CMS)

```
src/payload/
├── collections/     # Data models
├── blocks/          # Content blocks
├── fields/          # Custom fields
├── hooks/           # Collection hooks
├── access/          # Access control
├── endpoints/       # Custom API endpoints
├── utilities/       # Helper functions
└── seed/           # Seed data
```

### Frontend (Next.js)

```
src/frontend/
├── components/     # React components
├── hooks/          # Custom React hooks
├── pages/          # Next.js pages
├── styles/         # CSS/SCSS files
├── lib/            # Utilities
└── public/         # Static assets
```

## Development Workflow

### Backend Development

1. Creating a New Collection:
   - Create schema in `collections/`
   - Define access control
   - Add to `payload.config.ts`
   - Create seed data

2. Adding Custom Fields:
   - Create field in `fields/`
   - Add validation
   - Include in collections

3. Implementing Hooks:
   - Create hook in `hooks/`
   - Add to collection config
   - Test functionality

### Frontend Development

1. Component Development:
   - Create in `components/`
   - Add TypeScript types
   - Include styling
   - Write tests

2. Page Creation:
   - Add to `pages/`
   - Implement data fetching
   - Add routing
   - Setup layouts

3. API Integration:
   - Use Payload API client
   - Handle authentication
   - Manage state
   - Error handling

## Testing

### Backend Tests

```bash
cd src/payload
npm run test
```

### Frontend Tests

```bash
cd src/frontend
npm run test
```

## Code Style Guidelines

### TypeScript

- Use strict mode
- Define interfaces/types
- Document complex functions
- Use async/await

### React

- Functional components
- Custom hooks for logic
- Proper prop types
- Memoization when needed

### CSS/SCSS

- Follow BEM methodology
- Use CSS modules
- Maintain responsiveness
- Follow design system

## Debugging

### Backend

1. Access logs:
```bash
docker-compose logs payload
```

2. MongoDB shell:
```bash
docker-compose exec mongodb mongosh
```

### Frontend

1. React Developer Tools
2. Network tab monitoring
3. Console debugging

## Common Issues

### Payload CMS Version Compatibility

**CRITICAL**: This project uses Payload v2.5.0. Do NOT use v3 configuration syntax.

1. **Module Resolution Errors**:
   - Check `payload.config.ts` uses v2 syntax
   - Verify dependencies match v2 versions
   - See [Post-Mortem](./POST_MORTEM_PAYLOAD_V2_MIGRATION.md) for detailed analysis

2. **Required v2 Dependencies**:
   ```json
   {
     "@payloadcms/bundler-webpack": "^1.0.0",
     "@payloadcms/richtext-slate": "^1.0.0",
     "@payloadcms/db-mongoose": "^1.0.0"
   }
   ```

3. **Configuration Template**:
   ```typescript
   import { buildConfig } from 'payload/config' // NOT 'payload'
   import { webpackBundler } from '@payloadcms/bundler-webpack'
   import { slateEditor } from '@payloadcms/richtext-slate' // NOT lexicalEditor
   ```

### Container Issues

1. Ports already in use:
```bash
docker-compose down
netstat -ano | findstr "3000 3001 27017"
```

2. MongoDB connection:
- Check credentials
- Verify network
- Check logs

### Build Issues

1. Clear dependencies:
```bash
rm -rf node_modules
npm install
```

2. Clear Docker cache:
```bash
docker-compose build --no-cache
```

3. **Payload Build Process**:
   ```bash
   cd src/payload
   npm run build  # Required before npm run dev
   npm run dev
   ```

## Deployment

### Staging

```bash
docker-compose -f docker-compose.yml -f docker-compose.staging.yml up -d
```

### Production

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## Contributing

1. Branch naming:
   - feature/description
   - fix/description
   - docs/description

2. Commit messages:
   - Clear and descriptive
   - Reference issues

3. Pull requests:
   - Update documentation
   - Include tests
   - Add changelog entry