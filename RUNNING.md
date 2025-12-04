# Running OpenMRS Core locally (dev preview)

This repository is configured to run entirely with Docker Compose so that Maven executes inside a container. This avoids requiring Maven or Java on your host and ensures consistent behavior with the preview system.

Quick start (from repository root):
- Start preview (binds 0.0.0.0:3001):
  ./run-preview.sh

- Or using docker compose directly:
  OPENMRS_HOST_PORT=3001 docker compose up

- Build image layers (Maven runs inside the image):
  docker compose build --build-arg MVN_ARGS="install -DskipTests"

- Run tests (inside container):
  docker compose run --rm openmrs bash -lc "mvn -q test"

Details:
- The application listens on 0.0.0.0:8080 inside the container and is mapped to host port 3001 by default via docker-compose.yml.
- To change the exposed host port, set OPENMRS_HOST_PORT, e.g.:
  OPENMRS_HOST_PORT=4000 ./run-preview.sh

- The run-preview.sh script:
  - Detects whether it is running inside the container and, if so, starts Tomcat via Maven there (still containerized).
  - When run on the host, it simply executes docker compose up.

Notes:
- Do not run bare mvn commands on the host for preview, as this environment expects Maven to run inside the container.
- The .project_manifest.yaml uses:
  - build: docker compose build --build-arg MVN_ARGS='install -DskipTests'
  - start/preview: bash openmrs-core-183966/run-preview.sh
  - test: docker compose run --rm openmrs bash -lc 'mvn -q test'
- The application will be available at:
  http://localhost:3001/
  (or whichever port you set in OPENMRS_HOST_PORT)
