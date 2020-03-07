FROM openjdk:11-jdk-slim as develop

ENV APP_DIR /usr/local/app

# FROM amazoncorretto:11 as develop
# RUN yum -y update && \
#     yum -y install shadow-utils tar gzip

RUN apt -y update

RUN apt -y update && \
    groupadd spring && adduser --system spring && adduser spring spring && \
    mkdir $APP_DIR && chown -R spring:spring $APP_DIR

USER spring:spring

WORKDIR $APP_DIR

EXPOSE 8080


FROM develop AS builder
USER root
COPY ./app /usr/local/app
WORKDIR /usr/local/app/demo
# RUN id;whoami;pwd;ls -la
RUN bash gradlew build


FROM openjdk:11-jre-slim as demo-app

ENV APP_DIR /usr/local/app

COPY --from=builder /usr/local/app/demo/build/libs/demo.jar /usr/local/app/

EXPOSE 8080

ENTRYPOINT ["java","-jar","/usr/local/app/demo.jar"]


# docker build . --target demo-app -t demo-app
# docker run -it-p --rm  8070:8080 demo-app
