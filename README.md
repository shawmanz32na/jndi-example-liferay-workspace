# JNDI Example Liferay Workspace

A containerized [Liferay Workspace](https://learn.liferay.com/w/dxp/liferay-development/tooling/liferay-workspace) for demonstrating use of [jndi-example](https://github.com/dnebing/jndi-example).

## Usage

```
# Start the Docker Compose stack
docker compose up -d

# Launch a terminal in the Liferay Workspace container
docker exec -it liferay-workspace

# Start Liferay
blade server start

# Deploy the JNDI example
pushd liferay-workspace/liferay-jndli-example/modules/com.liferay.jndi.example/com.liferay.jndi.example.api
blade gw clean deploy
popd
pushd liferay-workspace/liferay-jndli-example/modules/com.liferay.jndi.example/com.liferay.jndi.example.service
blade gw clean deploy
popd
```

## Development / debugging features

### Real-time debugging

Java real-time debugging is exposed at `localhost:8000`, and a VS Code debug configuration is provided to attach to the running Liferay process.

### JMX

JMX (MBean) metrics and reporting is enabled at `0.0.0.0:9010`. To use it, launch **jconsole.exe**, select **Remote Process** and enter `0.0.0.0:9010`, then **Connect**.

## Reproducing database pool closures on module redeploy

The primary intent of creating this workspace was to demonstrate an issue being experienced where redeploying a service builder module causes the HikariCP database connection pool to close, which then causes the module to fail to start, which then requires the Liferay server to be restarted to bring the system back online.

Once the workspace has been initialized and started using the instructions in the **Usage** section above, this issue can be reproduced with the following steps:
1. Launch the workspace using the instructions in the **Usage** section
2. View the Liferay log by opening a new terminal and running `docker exec -it liferay-workspace /bin/bash` and then `tail -f /usr/liferay-workspace/bundles/tomcat-9.0.17/logs/catalina.out`
    - The log will indicate successful Liferay startup and `[DialectDetector:158] Using dialect org.hibernate.dialect.PostgreSQLDialect for PostgreSQL 15.8`
3. View the database connection pool status through JMX using the instructions in the **Develompent / debugging features | JMX** section above and then selecting the MBeans tab and expanding the **com.zaxxer.hikari** folder
    - There will exist a **Pool (extdb-postgres)** and **PoolConfig (extdb-postgres)** entry
4. Make a code change, e.g. adding a logging line to `FooLocalService` and copy it to the container with `docker cp ./liferay-workspace/liferay-jndi-example/modules/com.liferay.jndi.example/com.liferay.jndi.example-service/src/main/java  liferay-workspace:/usr/liferay-workspace/modules/com.liferay.jndi.example/com.liferay.jndi.example-service/src/main/`
5. Build and redeploy the updated module by opening the terminal used for the **Usage** section and running `pushd liferay-workspace/liferay-jndli-example/modules/com.liferay.jndi.example/com.liferay.jndi.example.service && blade gw clean deploy && popd`
    - The Liferay log will indicate `[DialectDetector:147] java.sql.SQLException: HikariDataSource HikariDataSource (extdb-postgres) has been closed.` followed by a very lenthy stack trace saying `[ModuleApplicationContextRegistrator:65] Unable to start com.liferay.jndi.example.service ... Caused by: java.lang.RuntimeException: No dialect found`
    - The JMX window will show **Pool (extdb-postgres)** and **PoolConfig (extdb-postgres)** no longer exist

## Other known issues

None of the Remote Service API methods succeed when using the /api/jsonws interface. Specific examples:
- Usages of `getFoos` result in `[JSONWebServiceServiceAction:116] com.liferay.portal.kernel.dao.orm.ORMException: org.hibernate.exception.SQLGrammarException: could not execute query`
- Usages of `getFoo` with an id value result in com.liferay.portal.kernel.dao.orm.ORMException: org.hibernate.exception.SQLGrammarException: could not load an entity: [com.liferay.jndi.example.model.impl.FooImpl#1]