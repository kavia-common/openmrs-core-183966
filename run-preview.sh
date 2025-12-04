#!/usr/bin/env bash
set -euo pipefail

# PUBLIC_INTERFACE
# This script starts OpenMRS for preview:
# - When run on the host, it starts docker compose (maven runs inside container).
# - When executed inside the container (compose command), it runs mvn to start Tomcat.
# It maps to host port 3001 by default (OPENMRS_HOST_PORT), binding to 0.0.0.0.
# Usage: ./run-preview.sh

export OPENMRS_HOST_PORT="${OPENMRS_HOST_PORT:-3001}"

# Detect container via DOCKERIZED flag set in compose or presence of /.dockerenv
if [[ "${DOCKERIZED:-}" == "true" || -f "/.dockerenv" ]]; then
  echo "Detected container environment, starting OpenMRS via Maven inside container on 0.0.0.0:8080 (host ${OPENMRS_HOST_PORT})..."
  # Bind Tomcat to 0.0.0.0 and port 8080; host maps 3001->8080 via docker-compose
  exec mvn -q -DskipTests tomcat7:run \
    -Dmaven.test.skip=true \
    -Dmaven.tomcat.port=8080 \
    -Dmaven.tomcat.host=0.0.0.0 \
    -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
else
  echo "Starting OpenMRS via docker compose on host port ${OPENMRS_HOST_PORT} ..."
  # Ensure we never call host mvn; docker compose will build and run the containerized Maven
  if [[ "${DRY_RUN:-}" == "1" || "${DRY_RUN:-}" == "true" ]]; then
    echo "[DRY RUN] docker compose up"
    exit 0
  fi
  exec docker compose up
fi
