# ZerviOS API Documentation

## Authentication

### OIDC Authentication

```http
GET /api/auth/okta
POST /api/auth/okta/callback
POST /api/auth/logout
```

Authentication is handled via Okta OIDC. Access tokens are required for all API requests.

### Headers

```http
Authorization: Bearer <access_token>
Content-Type: application/json
```

## Core Endpoints

### Users

```http
GET /api/users
GET /api/users/:id
POST /api/users
PATCH /api/users/:id
DELETE /api/users/:id
```

User management with factory and department associations.

### Tasks

```http
GET /api/tasks
GET /api/tasks/:id
POST /api/tasks
PATCH /api/tasks/:id
DELETE /api/tasks/:id
```

Task management with Planka integration.

### Projects

```http
GET /api/projects
GET /api/projects/:id
POST /api/projects
PATCH /api/projects/:id
DELETE /api/projects/:id
```

Project management and organization.

### Knowledge Base

```http
GET /api/kb-articles
GET /api/kb-articles/:id
POST /api/kb-articles
PATCH /api/kb-articles/:id
DELETE /api/kb-articles/:id
```

Knowledge base article management with versioning.

### Calendar

```http
GET /api/calendar-events
GET /api/calendar-events/:id
POST /api/calendar-events
PATCH /api/calendar-events/:id
DELETE /api/calendar-events/:id
```

Calendar event management with Google Calendar sync.

## Integration Endpoints

### Planka Integration

```http
POST /api/integrations/planka/webhook
GET /api/integrations/planka/tasks
POST /api/integrations/planka/sync
```

Planka task management integration.

### Odoo Integration

```http
POST /api/integrations/odoo/webhook
GET /api/integrations/odoo/data
POST /api/integrations/odoo/sync
```

Odoo ERP integration endpoints.

### AI Services

```http
POST /api/ai/generate
POST /api/ai/analyze
POST /api/ai/translate
```

Azure OpenAI integration endpoints.

## Query Parameters

### Pagination

```
page: number (default: 1)
limit: number (default: 10, max: 100)
```

### Filtering

```
where[field]: value
where[field][operator]: value
```

Supported operators: equals, not_equals, greater_than, less_than, exists, in

### Sorting

```
sort: field_name
order: asc|desc
```

### Population

```
depth: number (default: 2, max: 10)
fields: comma-separated list of fields
```

## Webhooks

### Webhook Format

```json
{
  "event": "string",
  "payload": {
    "id": "string",
    "collection": "string",
    "data": {}
  }
}
```

### Webhook Events

- `collection.create`
- `collection.update`
- `collection.delete`
- `integration.sync`

## Error Handling

### Error Response Format

```json
{
  "errors": [{
    "message": "string",
    "code": "string",
    "field": "string"
  }]
}
```

### Common Error Codes

- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `422`: Validation Error
- `429`: Rate Limit Exceeded
- `500`: Internal Server Error

## Rate Limiting

Requests are limited to:
- 100 requests per minute per IP
- 1000 requests per hour per user

Headers:
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1620000000
```

## GraphQL

### Endpoint

```http
POST /api/graphql
```

### Example Query

```graphql
query {
  Users {
    docs {
      id
      email
      name
      factory {
        id
        name
      }
    }
    totalDocs
  }
}
```

## Versioning

API versioning is handled through the URL:

```http
/api/v1/resource
```

Current version: v1