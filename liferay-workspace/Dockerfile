FROM eclipse-temurin:8u352-b08-jdk AS liferay-workspace

# Install Blade CLI (per https://learn.liferay.com/w/dxp/liferay-development/tooling/blade-cli)
RUN curl -L https://raw.githubusercontent.com/liferay/liferay-blade-cli/master/cli/installers/local | sh
ENV PATH="$PATH:/root/jpm/bin"

CMD ["/bin/bash"]


FROM liferay-workspace AS jndi-example-liferay-workspace

# Copy the JNDI Example and initialize the Liferay bundle
WORKDIR /usr/liferay-workspace
COPY liferay-jndi-example /usr/liferay-workspace
RUN blade gw initBundle

# Enable JMX Monitoring
COPY tomcat/bin/setenv.sh bundles/tomcat-9.0.17/bin/

# Update the PostgreSQL JDBC Driver to a version that supports PostgreSQL 15+
RUN rm bundles/tomcat-9.0.17/lib/ext/postgresql.jar
ADD https://jdbc.postgresql.org/download/postgresql-42.7.4.jar bundles/tomcat-9.0.17/lib/ext/

# Install HikariCP for use by JNDI resources by moving the Liferay-provided HikariCP artifacts to Tomcat's third-party dependencies
RUN mv bundles/tomcat-9.0.17/webapps/ROOT/WEB-INF/lib/slf4j-api.jar bundles/tomcat-9.0.17/lib/ext/
RUN mv bundles/tomcat-9.0.17/webapps/ROOT/WEB-INF/lib/hikaricp.jar bundles/tomcat-9.0.17/lib/ext/

# # # Launch Liferay on startup
# # CMD blade server start && tail -f /usr/liferay-workspace/bundles/tomcat/logs/catalina.out
