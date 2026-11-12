#!/usr/bin/env bash
# ==============================================================================
# Automated Build and Deployment Script
# Project: Panda Team DevOps Task
# Author: Vadym Shchuryk
# ==============================================================================

set -euo pipefail

# ----------------- КОНФІГУРАЦІЯ -----------------
DOCKER_USER="${DOCKER_USER:-ceph1386}"
IMAGE_NAME="${IMAGE_NAME:-panda-devops-app}"
TAG="${TAG:-latest}"
CONTAINER_NAME="panda-web-app"
HOST_PORT="${HOST_PORT:-8080}"
CONTAINER_PORT=80

FULL_IMAGE="${DOCKER_USER}/${IMAGE_NAME}:${TAG}"

echo "=================================================="
echo " Starting Deployment Pipeline for: ${FULL_IMAGE}"
echo "=================================================="

# 1. ЗБИРАННЯ ОБРАЗУ
echo -e "\n[1/4] Building Docker image..."
docker build -t "${FULL_IMAGE}" .

# 2. ПУШ У РЕЄСТР (DOCKER HUB)
# Якщо передано змінну оточення PUSH_IMAGE=true або запущено окремо
if [[ "${PUSH_IMAGE:-true}" == "true" ]]; then
    echo -e "\n[2/4] Pushing image to Docker Hub (${FULL_IMAGE})..."
    docker push "${FULL_IMAGE}"
else
    echo -e "\n[2/4] Skipping push to Docker Hub (PUSH_IMAGE=false)..."
fi

# 3. РОЗГОРТАННЯ КОНТЕЙНЕРА (DEPLOY)
echo -e "\n[3/4] Deploying container: ${CONTAINER_NAME}..."

# Безпечно зупиняємо і видаляємо старий контейнер, якщо він існує
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "Stopping and removing existing container '${CONTAINER_NAME}'..."
    docker stop "${CONTAINER_NAME}" >/dev/null 2>&1 || true
    docker rm "${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

# Запуск оновленого контейнера
docker run -d \
    --name "${CONTAINER_NAME}" \
    --restart unless-stopped \
    -p "${HOST_PORT}:${CONTAINER_PORT}" \
    "${FULL_IMAGE}"

# 4. HEALTHCHECK ТА ВАЛІДАЦІЯ
echo -e "\n[4/4] Validating deployment health..."
sleep 3

if docker ps --filter "name=${CONTAINER_NAME}" --filter "status=running" | grep -q "${CONTAINER_NAME}"; then
    echo "✓ Container is running successfully!"
    echo "✓ App endpoint: http://localhost:${HOST_PORT}"
    
    # Перевірка HTTP коду
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:${HOST_PORT}" || echo "000")
    if [[ "${HTTP_CODE}" == "200" ]]; then
        echo "✓ Healthcheck PASSED: HTTP status 200 OK"
    else
        echo "⚠ Warning: Expected HTTP 200, but received: ${HTTP_CODE}"
    fi
else
    echo "✗ Deployment FAILED! Container crashed or stopped."
    docker logs "${CONTAINER_NAME}"
    exit 1
fi

echo "=================================================="
echo " Deployment completed successfully!"
echo "=================================================="
