# Stage 1: Builder - Heavy stage for build
FROM node:18-alpine AS builder
WORKDIR /app

# Copy dependency files
COPY package*.json ./
RUN npm ci --only=production

# Copy source and build
COPY . .
RUN npm run build

# Stage 2: Production - Lightweight & Secure Final Image
FROM node:18-alpine AS production
WORKDIR /app

ENV NODE_ENV=production

# Security: Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only needed files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public

# Switch to non-root user
USER appuser

EXPOSE 3000

# Health check for orchestration
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "dist/server.js"]
