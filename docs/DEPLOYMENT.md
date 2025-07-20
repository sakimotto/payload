# ZerviOS Deployment Guide

## Infrastructure Overview

### Components

- MongoDB Database
- Payload CMS Backend
- Next.js Frontend
- Redis Cache (Optional)
- Nginx Reverse Proxy

### Requirements

- Docker and Docker Compose
- 4GB RAM minimum
- 20GB storage minimum
- Linux-based OS (recommended)

## Environment Configuration

### Required Environment Variables

```bash
# MongoDB
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=secure_password
MONGO_INITDB_DATABASE=zervios

# Payload CMS
PAYLOAD_SECRET=your_secure_secret
PAYLOAD_PUBLIC_SERVER_URL=https://api.yourdomain.com
PAYLOAD_ADMIN_EMAIL=admin@yourdomain.com

# Frontend
NEXT_PUBLIC_SITE_URL=https://yourdomain.com
NEXT_PUBLIC_PAYLOAD_URL=https://api.yourdomain.com

# Authentication
OKTA_ISSUER=https://your-okta-domain.okta.com
OKTA_CLIENT_ID=your_client_id
OKTA_CLIENT_SECRET=your_client_secret

# External Services
AZURE_OPENAI_KEY=your_azure_openai_key
PLANKA_API_KEY=your_planka_api_key
ODOO_API_KEY=your_odoo_api_key

# Redis (Optional)
REDIS_PASSWORD=secure_redis_password
```

## Production Deployment

### 1. Server Preparation

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker and Docker Compose
sudo apt install docker.io docker-compose -y

# Create network
docker network create zervios-network
```

### 2. SSL Certificate Setup

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Generate certificates
sudo certbot certonly --nginx -d yourdomain.com -d api.yourdomain.com
```

### 3. Application Deployment

```bash
# Clone repository
git clone <repository-url>
cd ZerviOS

# Configure environment
cp env.example .env
vim .env  # Edit with production values

# Start services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 4. Nginx Configuration

```nginx
# /etc/nginx/sites-available/zervios

# API
server {
    listen 443 ssl;
    server_name api.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Frontend
server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Backup Strategy

### MongoDB Backup

```bash
#!/bin/bash
# /root/backup-mongodb.sh

BACKUP_DIR=/backups/mongodb
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

docker-compose exec -T mongodb mongodump \
    --uri="mongodb://$MONGO_INITDB_ROOT_USERNAME:$MONGO_INITDB_ROOT_PASSWORD@localhost:27017" \
    --out="/dump/$TIMESTAMP"

# Cleanup old backups (keep last 7 days)
find $BACKUP_DIR -type d -mtime +7 -exec rm -rf {} +
```

### Media Backup

```bash
#!/bin/bash
# /root/backup-media.sh

BACKUP_DIR=/backups/media
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

tar -czf "$BACKUP_DIR/media_$TIMESTAMP.tar.gz" /path/to/media

# Cleanup old backups (keep last 7 days)
find $BACKUP_DIR -type f -mtime +7 -exec rm {} +
```

## Monitoring

### Health Checks

```bash
#!/bin/bash
# /root/health-check.sh

# Check services
docker-compose ps

# Check MongoDB
docker-compose exec -T mongodb mongosh --eval "db.runCommand({ ping: 1 })"

# Check Payload
curl -f http://localhost:3000/api/health

# Check Frontend
curl -f http://localhost:3001
```

### Log Management

```bash
# View service logs
docker-compose logs --tail=100 -f [service]

# Rotate logs
/etc/logrotate.d/docker-compose
```

## Scaling Considerations

### Horizontal Scaling

1. Set up load balancer
2. Configure session persistence
3. Scale frontend containers
4. Monitor performance

### Vertical Scaling

1. Increase container resources
2. Optimize MongoDB indexes
3. Configure Redis caching
4. Tune Node.js performance

## Security Measures

1. Regular updates:
```bash
docker-compose pull
docker-compose up -d
```

2. Firewall configuration:
```bash
ufw allow 80,443/tcp
ufw enable
```

3. Security headers:
```nginx
add_header Strict-Transport-Security "max-age=31536000";
add_header X-Frame-Options "SAMEORIGIN";
add_header X-Content-Type-Options "nosniff";
```

## Troubleshooting

### Common Issues

1. Container won't start:
```bash
docker-compose logs [service]
docker-compose ps
```

2. Database connection issues:
```bash
docker-compose exec mongodb mongosh
```

3. Permission problems:
```bash
chown -R 1000:1000 ./media
```

### Recovery Procedures

1. Restore MongoDB:
```bash
docker-compose exec mongodb mongorestore /dump/backup_name
```

2. Restore media:
```bash
tar -xzf media_backup.tar.gz -C /path/to/media
```