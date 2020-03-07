#
# alpine jdk
#
FROM alpine:3.10.1 as build-jdk

RUN apk update && \
    apk --no-cache add openjdk11 && \
    rm -rf /var/cache/apk/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH="$PATH:$JAVA_HOME/bin"

#
# Develop env for VSCode
#
FROM build-jdk as develop
WORKDIR /app
EXPOSE 8080


#
# build jar
#
FROM build-jdk AS builder
USER root
COPY ./app /app
WORKDIR /app/demo

RUN sh gradlew build

#
# alpine mini jre
#
FROM alpine:3.10.1 as build-jre

RUN apk update \
 && apk --no-cache add openjdk11    \
 && rm -rf /var/cache/apk/*

RUN /usr/lib/jvm/java-11-openjdk/bin/jlink \
     --module-path /usr/lib/jvm/java-11-openjdk/jmods \
     --compress=2 \
     --add-modules jdk.jfr,jdk.management.agent,java.base,java.logging,java.xml,jdk.unsupported,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
     --no-header-files \
     --no-man-pages \
     --output /opt/jdk-11-mini-runtime

FROM alpine:3.10.1 as alpine-mini-jre

ENV JAVA_HOME=/opt/jdk-11-mini-runtime
ENV PATH="$PATH:$JAVA_HOME/bin"

COPY --from=build-jre /opt/jdk-11-mini-runtime /opt/jdk-11-mini-runtime


#
# build container image
#
FROM alpine-mini-jre as demo-app

ENV APP_DIR /app

COPY --from=builder /app/demo/build/libs/demo.jar /app/

RUN adduser --system spring
USER spring

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/demo.jar"]


# docker build . --target demo-app -t demo-app
# docker run -it -p 8080:8080 --rm  demo-app