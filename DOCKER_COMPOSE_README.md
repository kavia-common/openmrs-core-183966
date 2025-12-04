# Running OpenMRS Core with Docker Compose (No system mvn required)

This project is configured to build and run using Docker Compose so Maven runs inside the container. This avoids needing `mvn` on the host CI runner.

Exposed port:
- Host: 3001
- Container (internal): 8080
- Override host port: set OPENMRS_HOST_PORT, e.g. `OPENMRS_HOST_PORT=3001`

Commands:
- Start (foreground): `docker compose up`
- Start (detached): `docker compose up -d`
- Build (faster iteration): `docker compose build --build-arg MVN_ARGS="install -DskipTests"`
- Run tests: `docker compose run --rm openmrs bash -lc "mvn test"`
- Stop: `docker compose down`
- Clean (stop + remove volumes): `docker compose down -v`

Makefile shortcuts:
- `make run` (binds to port 3001 by default)
- `make build`
- `make test`
- `make stop`
- `make clean`

Preview pipeline single command:
- `docker compose up` (or `docker compose up -d` for detached)

Notes:
- The container runs `mvn tomcat7:run` internally.
- Ensure Docker and Docker Compose v2 are available in the environment.
- If using a shared CI environment, you may want to remove the ~/.m2 cache mount in docker-compose.yml.
