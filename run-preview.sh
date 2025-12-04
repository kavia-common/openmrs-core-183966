#!/usr/bin/env bash
# Run OpenMRS Core using Docker Compose for preview, without relying on host Maven.
# Maps container HTTP port to 0.0.0.0:3001 on the host.
# This script builds (if necessary) and starts the app service defined in docker-compose.yml.

set -euo pipefail

# Ensure docker and docker compose are available
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is required but not installed or not in PATH." >&2
  exit 1
fi

# Prefer docker compose (v2), fallback to docker-compose (v1)
if docker compose version >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD="docker-compose"
else
  echo "Error: docker compose (v2) or docker-compose (v1) is required but not found." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Generate a default docker-compose.yml if it does not exist
if [ ! -f docker-compose.yml ]; then
  cat > docker-compose.yml <<'YAML'
version: "3.8"
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.preview
    container_name: openmrs-core-preview
    ports:
      - "3001:8080"
    environment:
      - JAVA_OPTS=-Xms256m -Xmx1024m
    # Allow the app to bind to 0.0.0.0 inside container (default for most web servers)
    restart: unless-stopped
YAML
fi

# Generate a lightweight Dockerfile for preview if not present
if [ ! -f Dockerfile.preview ]; then
  cat > Dockerfile.preview <<'DOCKER'
# Multi-stage: Build the OpenMRS WAR using Maven inside container, then run on Tomcat
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /workspace
# Copy the entire project to build context
COPY . /workspace
# Build the webapp (skip tests to speed up preview)
RUN mvn -q -DskipTests clean package

# Runtime image with Tomcat
FROM tomcat:9.0-jdk17-temurin
# Remove default ROOT and deploy our WAR
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Try to find the built WAR; fall back to webapp/target if standard
# The project is multi-module; webapp module typically produces openmrs.war
COPY --chown=tomcat:tomcat webapp/target/*.war /usr/local/tomcat/webapps/ROOT.war
# Expose 8080 inside the container; docker-compose maps this to 3001
EXPOSE 8080
ENV CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom ${JAVA_OPTS}"
CMD ["catalina.sh", "run"]
DOCKER
fi

# Build and start the app
$DOCKER_COMPOSE_CMD build app
$DOCKER_COMPOSE_CMD up app
