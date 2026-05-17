#!/bin/bash
set -e  # exit on any error

APP_NAME="devops-node-app"
IMAGE_TAG="${1:-latest}"
ENV_FILE=".env"

echo "Starting deployment of $APP_NAME:$IMAGE_TAG"

# Check Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "ERROR: Docker is not running"
  exit 1
fi

# Check .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found"
  exit 1
fi

echo "[1/4] Pulling latest image..."
docker pull "$APP_NAME:$IMAGE_TAG" 2>/dev/null || echo "Using local image"

echo "[2/4] Stopping existing container..."
docker compose down || true

echo "[3/4] Starting services..."
docker compose --env-file "$ENV_FILE" up -d

echo "[4/4] Health check..."
sleep 5
if curl -sf http://localhost:3000/health > /dev/null; then
  echo "✓ Deployment successful — app is healthy"
else
  echo "✗ Health check failed — rolling back"
  docker compose down
  exit 1
fi