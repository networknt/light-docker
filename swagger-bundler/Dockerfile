FROM jimschubert/8-jdk-alpine-mvn:latest

MAINTAINER Steve Hu <steve.hu@gmail.com>

RUN set -x \
    && mkdir -p /light-api/out \
    && apk add --no-cache bash \
    && apk add --no-cache --virtual .temporary wget \
    && wget -qO- https://api.github.com/repos/networknt/swagger-bundler/tarball/master | tar zxv -C /light-api \
    && mv /light-api/networknt-swagger-bundler* /light-api/swagger-bundler/ \
    && apk del .temporary

VOLUME /light-api/out

WORKDIR /light-api/out

COPY docker-entrypoint.sh /

RUN cd /light-api/swagger-bundler && \
    mvn package -DskipTests && \
    rm -rf ${MAVEN_HOME}/.m2/repository

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["help"]
