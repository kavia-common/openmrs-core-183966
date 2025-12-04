# Running OpenMRS Core locally (dev preview)

This project is multi-module Maven with a webapp module that can run with an embedded Tomcat plugin.

Correct commands (run from the project root: openmrs-core-183966):
- Build (with tests): 
  mvn -DskipTests=false clean install
- Start (bind to 0.0.0.0:3001 for preview):
  mvn -pl webapp -am tomcat7:run -Dmaven.tomcat.port=3001 -Dmaven.tomcat.host=0.0.0.0
- Test:
  mvn test
- Resolve dependencies:
  mvn dependency:resolve
- Lint:
  mvn checkstyle:check

Notes:
- Do not cd into openmrs-core-183966 if you are already at the project root; the preview runner starts in that directory.
- If you prefer Jetty, you can run from the webapp module:
  cd webapp && mvn -Djetty.http.port=3001 -Djetty.host=0.0.0.0 jetty:run
