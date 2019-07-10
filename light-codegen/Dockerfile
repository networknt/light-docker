FROM maven:3.6.1-jdk-11-slim

MAINTAINER Steve Hu <steve.hu@gmail.com>

RUN set -x \
    && mkdir -p /light-api/out \
    && apk add --no-cache bash \
    && apk add --no-cache --virtual .temporary wget \
    && wget -qO- https://api.github.com/repos/networknt/light-codegen/tarball/master | tar zxv -C /light-api \
    && mv /light-api/networknt-light-codegen* /light-api/light-codegen/ \
    && apk del .temporary

VOLUME /light-api/out

WORKDIR /light-api/out

COPY docker-entrypoint.sh /

RUN cd /light-api/light-codegen && \
    mvn package -DskipTests && \
    rm -rf ${MAVEN_HOME}/.m2/repository

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["help"]
