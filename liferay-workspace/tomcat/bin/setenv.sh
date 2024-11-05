# This is the default Liferay 7.1.3-ga4 setenv.sh, except that it also enables JMX monitoring

CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF8 -Djava.net.preferIPv4Stack=true -Duser.timezone=GMT -Xms2560m -Xmx2560m -XX:MaxNewSize=1536m -XX:MaxMetaspaceSize=512m -XX:MetaspaceSize=512m -XX:NewSize=1536m -XX:SurvivorRatio=7"

# Enable JMX Monitoring on 0.0.0.0:9010
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Djava.rmi.server.hostname=0.0.0.0"
