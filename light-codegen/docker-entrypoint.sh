#!/bin/bash

set -eo pipefail

codegen="/light-api/light-codegen/codegen-cli/target/codegen-cli.jar"

JAVA_OPTS=${JAVA_OPTS:"-XX:MaxPermSize=256M -Xmx1024M"}

exec java ${JAVA_OPTS} -jar ${codegen} "$@"