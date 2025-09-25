#!/bin/bash
set -e

IMAGE="${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
CONTAINER_NAME=wheels-dev-stage-test

echo "Running test container from image: $IMAGE"
docker run -d --name $CONTAINER_NAME $IMAGE
echo "Waiting for container to become healthy..."
TIMEOUT=60
INTERVAL=5
elapsed=0

while [ $elapsed -lt $TIMEOUT ]; do
  health=$(docker inspect -f '{{.State.Health.Status}}' $CONTAINER_NAME 2>/dev/null || echo "no-health")
  echo "Health status: $health"

  if [ "$health" = "healthy" ]; then
    echo "✅ Container is healthy."
    docker rm -f $CONTAINER_NAME
    exit 0
  elif [ "$health" = "unhealthy" ]; then
    echo "❌ Container is unhealthy."
    docker logs $CONTAINER_NAME || true
    WEBINF_PATH=$(docker logs $CONTAINER_NAME 2>&1 | grep "Found WEB-INF" | sed -E "s/.*Found WEB-INF: '([^']+)'.*/\1/")
    if [ -n "$WEBINF_PATH" ]; then
      echo "Detected WEB-INF: $WEBINF_PATH"
      docker exec $CONTAINER_NAME cat "$WEBINF_PATH/lucee-server/context/logs/application.log" || true
    fi
    docker rm -f $CONTAINER_NAME || true
    exit 1
  elif [ "$health" = "no-health" ]; then
    echo "❌ HEALTHCHECK not defined in image. Cannot proceed."
    docker rm -f $CONTAINER_NAME || true
    exit 1
  fi

  sleep $INTERVAL
  elapsed=$((elapsed + INTERVAL))
done

echo "❌ Container health status stuck at 'starting' for more than $TIMEOUT seconds."
docker logs $CONTAINER_NAME || true
WEBINF_PATH=$(docker logs $CONTAINER_NAME 2>&1 | grep "Found WEB-INF" | sed -E "s/.*Found WEB-INF: '([^']+)'.*/\1/")
if [ -n "$WEBINF_PATH" ]; then
  echo "Detected WEB-INF: $WEBINF_PATH"
  docker exec $CONTAINER_NAME cat "$WEBINF_PATH/lucee-server/context/logs/application.log" || true
fi
docker rm -f $CONTAINER_NAME || true
exit 1
