# PUBLIC_INTERFACE
# Entry points for local dev and CI to avoid using system 'mvn'.
# Requires Docker and Docker Compose v2 (docker compose ...).
# Exposes the application on host port 3001 by default.
# To change port: OPENMRS_HOST_PORT=3001 make run

# PUBLIC_INTERFACE
run:
	@OPENMRS_HOST_PORT=$${OPENMRS_HOST_PORT:-3001} docker compose up

# PUBLIC_INTERFACE
preview:
	@OPENMRS_HOST_PORT=$${OPENMRS_HOST_PORT:-3001} bash ./run-preview.sh

# PUBLIC_INTERFACE
stop:
	@docker compose down

# PUBLIC_INTERFACE
clean:
	@docker compose down -v || true

# PUBLIC_INTERFACE
run-detached:
	@OPENMRS_HOST_PORT=$${OPENMRS_HOST_PORT:-3001} docker compose up -d

# PUBLIC_INTERFACE
build:
	@docker compose build --build-arg MVN_ARGS="install -DskipTests"

# PUBLIC_INTERFACE
test:
	# Execute tests inside the compose service using mvn
	@docker compose run --rm openmrs bash -lc "mvn -q test"

# PUBLIC_INTERFACE
stop:
	@docker compose down

# PUBLIC_INTERFACE
clean:
	# Stops containers and removes volumes (if any in future), but keeps local ~/.m2 cache
	@docker compose down -v || true
