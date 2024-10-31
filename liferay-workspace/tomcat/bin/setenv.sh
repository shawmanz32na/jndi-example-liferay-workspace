# This is the default Liferay 7.4-ga125 setenv.sh, except that it also enables JMX monitoring

CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8 -Djava.locale.providers=JRE,COMPAT,CLDR -Djava.net.preferIPv4Stack=true -Duser.timezone=GMT -Xms2560m -Xmx2560m -XX:MaxNewSize=1536m -XX:MaxMetaspaceSize=768m -XX:MetaspaceSize=768m -XX:NewSize=1536m -XX:SurvivorRatio=7"

# Enable JMX Monitoring on 0.0.0.0:9010
# CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Djava.rmi.server.hostname=0.0.0.0"

JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.base/sun.net.www.protocol.http=ALL-UNNAMED --add-opens=java.base/sun.net.www.protocol.https=ALL-UNNAMED --add-opens=java.base/sun.util.calendar=ALL-UNNAMED --add-opens=jdk.zipfs/jdk.nio.zipfs=ALL-UNNAMED"
					
if [ "$1" = "glowroot" ]
then
	GLOWROOT_OPTS="-javaagent:${CATALINA_HOME}/../glowroot/glowroot.jar -Dglowroot.enabled=true"

	CATALINA_OPTS="${CATALINA_OPTS} ${GLOWROOT_OPTS}"

	shift
fi

if [ "$GLOWROOT_ENABLED" = "true" ]
then
	GLOWROOT_OPTS="-javaagent:${CATALINA_HOME}/../glowroot/glowroot.jar -Dglowroot.enabled=true"

	CATALINA_OPTS="${CATALINA_OPTS} ${GLOWROOT_OPTS}"
fi
