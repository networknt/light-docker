#!/bin/bash

set -eo pipefail

bundler="/light-api/swagger-bundler/target/swagger-bundler.jar"

JAVA_OPTS=${JAVA_OPTS:"-XX:MaxPermSize=256M -Xmx1024M"}

exec java ${JAVA_OPTS} -jar ${bundler} "$@"