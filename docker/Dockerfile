#
# Copyright 2018, TOTVS S.A.
# All rights reserved.
#

# base image
FROM openjdk:13-jdk-alpine3.10

RUN addgroup -S idm
RUN adduser -S idm -G idm

# variables and arguments for identity
ENV IDM_HOME "/opt/idm"

RUN mkdir -p "${IDM_HOME}" && \
    chown -R idm:idm "${IDM_HOME}"

WORKDIR ${IDM_HOME}

# install and configure as identity user
USER idm

# copy artifacts to docker image
ADD --chown=idm:idm target/idm-boot-starter.jar "${IDM_HOME}"

# don't let idm-events-listener run as root
USER idm

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar idm-boot-starter.jar" ]
