#!/bin/bash
set -e

APP_NAME="devops-node-app"
IMAGE_TAG="${1:-latest}"
ENV_FILE=".env"
APP_IMAGE="$APP_NAME:$IMAGE_TAG"

echo "Starting deployment of $APP_IMAGE"

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

echo "[1/4] Preparing image..."
if docker pull "$APP_IMAGE"; then
  COMPOSE_BUILD_FLAG="--no-build"
else
  echo "Image not available remotely, building locally"
  COMPOSE_BUILD_FLAG="--build"
fi

echo "[2/4] Stopping existing container..."
docker compose down || true

echo "[3/4] Starting services..."
APP_IMAGE="$APP_IMAGE" docker compose --env-file "$ENV_FILE" up -d $COMPOSE_BUILD_FLAG

echo "[4/4] Health check..."
sleep 5
if curl -sf http://localhost/health > /dev/null; then
  echo "Deployment successful: app is healthy"
else
  echo "Health check failed, stopping deployment"
  docker compose down
  exit 1
fi
