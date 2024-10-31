FROM eclipse-temurin:21.0.4_7-jdk AS liferay-workspace

# Install Blade CLI (per https://learn.liferay.com/w/dxp/liferay-development/tooling/blade-cli)
RUN curl -L https://raw.githubusercontent.com/liferay/liferay-blade-cli/master/cli/installers/local | sh
ENV PATH="$PATH:/root/jpm/bin"
# Add Blade CLI to the PATH to make it available in the terminal (per https://learn.liferay.com/w/dxp/liferay-development/tooling/blade-cli/troubleshooting-blade-cli#the-blade-command-is-not-available-in-my-cli)
# RUN echo 'export PATH="$PATH:$HOME/jpm/bin"' >> ~/.bashrc
# Reload the Bash profile to use the updated PATH without restarting the container (per https://liferay.dev/ask/questions/liferay-learn-feedback/installing-and-updating-blade-cli-document-doesn-t-actually-install-blade)
# RUN . ~/.bashrc
RUN echo $PATH
RUN blade --version

CMD ["/bin/bash"]


FROM liferay-workspace AS jndi-example-liferay-workspace

# Copy the JNDI Example and initialize the Liferay bundle
WORKDIR /usr/liferay-workspace
COPY liferay-jndi-example /usr/liferay-workspace
RUN blade gw initBundle

# Enable JMX Monitoring
COPY tomcat/bin/setenv.sh bundles/tomcat/bin/

# "Install" the PostgreSQL JDBC Driver by moving it from Liferay's libs to the global Tomcat libs
RUN mv bundles/tomcat/webapps/ROOT/WEB-INF/shielded-container-lib/postgresql.jar bundles/tomcat/lib/
