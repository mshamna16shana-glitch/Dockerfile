# Multi-Stage Docker Optimization Report

## Base Images Used
- Builder: node:18-alpine (55MB)
- Production: node:18-alpine (55MB)
- Avoided: node:18 (350MB) - too large

## Size Comparison
- Single-stage build: ~950MB
- Multi-stage build: ~150MB
- Savings: 85% reduction (800MB saved)

## Security Measures
1. Non-root user: appuser (not root)
2. Alpine Linux: minimal attack surface
3. No secrets copied
4. HEALTHCHECK added for container monitoring

## Production Ready Features
- ENV NODE_ENV=production
- EXPOSE 3000
- HEALTHCHECK interval 30s
- .dockerignore to exclude unnecessary files

## Build & Run
docker build -t task-manager:prod .
docker run -d -p 3000:3000 --env-file .env task-manager:prod
docker images task-manager:prod -- to verify size
