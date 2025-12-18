#!/usr/bin/env bash
# Preview Start Script for OpenMRS Core
# This script starts the OpenMRS webapp using Jetty on port 3001.
# It intentionally runs from the repository root and targets the webapp module.
# Requirements:
#  - Java JDK 8+ (per project requirements)
#  - Apache Maven (mvn) available on PATH
#
# Usage:
#  ./scripts/preview-start.sh
#
# Notes:
#  - We use Jetty because it is documented in README and configured in webapp/pom.xml.
#  - The port can be changed by setting JETTY_PORT env var before invoking.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Validate expected module structure exists
if [[ ! -f "$ROOT_DIR/webapp/pom.xml" ]]; then
  echo "[ERROR] Could not find webapp/pom.xml. Ensure you execute from the project repository root."
  exit 1
fi

# Determine desired port
JETTY_PORT="${JETTY_PORT:-3001}"

echo "[INFO] Starting OpenMRS webapp via Jetty on port ${JETTY_PORT}"
echo "[INFO] Repository root: ${ROOT_DIR}"
echo "[INFO] Module: webapp"
echo "[INFO] Command: mvn -DskipTests -Pskip-all-checks -Djetty.http.port=${JETTY_PORT} jetty:run"

# Verify mvn exists before trying to run
if ! command -v mvn >/dev/null 2>&1; then
  echo "[ERROR] Maven (mvn) command not found. Please ensure Maven is installed and on your PATH."
  echo "        On Debian/Ubuntu: sudo apt-get update && sudo apt-get install -y maven"
  echo "        On Alpine: apk add --no-cache maven"
  exit 127
fi

# Run jetty from the webapp module. Keep in foreground so preview process stays up.
cd "$ROOT_DIR/webapp"
exec mvn -DskipTests -Pskip-all-checks -Djetty.http.port="${JETTY_PORT}" jetty:run
