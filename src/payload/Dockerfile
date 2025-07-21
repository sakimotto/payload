# Builder stage
FROM node:20-alpine as builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies including 'payload' and its types
RUN npm install

# Copy source files
COPY . .

# Build TypeScript files and payload
RUN npm run build

# Production stage
FROM node:20-alpine as production

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm install --production

# Copy built files from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/build ./build

# Set environment variables
ENV NODE_ENV=production
ENV PAYLOAD_CONFIG_PATH=dist/payload.config.js
ENV MONGODB_URI=mongodb://mongodb:27017/zervios
ENV PORT=3001

# Expose the port
EXPOSE 3001

# Start the server
CMD ["node", "dist/server.js"]