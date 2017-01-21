#!/bin/bash

set -eo pipefail

codegen="/swagger-api/swagger-codegen/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"

JAVA_OPTS=${JAVA_OPTS:"-XX:MaxPermSize=256M -Xmx1024M -DloggerPath=conf/log4j.properties"}

case "$1" in
    generate|help|langs|meta|config-help)
        command=$1
        shift
        exec java ${JAVA_OPTS} -jar ${codegen} ${command} "$@"
        ;;
    *)
         exec "$@"
        ;;
esac
