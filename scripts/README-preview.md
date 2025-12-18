Preview Start Instructions

Purpose
- Provide a reliable way to start the OpenMRS webapp for preview without attempting to cd into a non-existent directory name derived from the container.

How it works
- The script runs from the repository root and explicitly targets the webapp module.
- It uses the Jetty Maven plugin configured in webapp/pom.xml.
- Default port is 3001; override with JETTY_PORT environment variable.

Run
- From repo root:
  ./scripts/preview-start.sh

Change port
- JETTY_PORT=3002 ./scripts/preview-start.sh

Why not cd into "openmrs-core-183966" first?
- "openmrs-core-183966" is the container/workspace name, not a subdirectory within the repo. The repository itself already has this as its root. Attempting to cd into it from within the repo leads to "No such file or directory".
