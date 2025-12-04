# Multi-stage not strictly required here since we are running via mvn inside the container,
# but we include a build arg to control the initial build.
FROM maven:3.9.6-eclipse-temurin-17 AS builder

ARG MVN_ARGS="install -DskipTests"
WORKDIR /workspace

# Pre-copy the pom(s) to leverage docker layer caching on dependency resolution
COPY ./pom.xml /workspace/pom.xml
# If there are submodule poms, consider copying them individually for better caching
# Fallback: copy minimal files first
RUN --mount=type=cache,target=/root/.m2 mvn -q -e -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -DskipTests dependency:go-offline

# Copy full source
COPY . /workspace

# Optionally run an initial build during image creation (can be skipped for dev iterations)
RUN --mount=type=cache,target=/root/.m2 mvn -q $MVN_ARGS -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn

# Final image will just reuse the same base with our workspace mounted at runtime by compose
FROM maven:3.9.6-eclipse-temurin-17
WORKDIR /workspace
# No copy here; docker-compose mounts the source for iterative development
CMD ["bash", "-lc", "mvn -q -DskipTests tomcat7:run -Dmaven.test.skip=true -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"]
