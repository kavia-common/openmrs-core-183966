#!/usr/bin/env bash
set -euo pipefail

# PUBLIC_INTERFACE
# This script runs the application using Docker Compose so maven runs in the container.
# It maps to host port 3001 by default. Override with OPENMRS_HOST_PORT if needed.
# Usage: ./run-preview.sh

export OPENMRS_HOST_PORT="${OPENMRS_HOST_PORT:-3001}"
echo "Starting OpenMRS via docker compose on host port ${OPENMRS_HOST_PORT} ..."
exec docker compose up
