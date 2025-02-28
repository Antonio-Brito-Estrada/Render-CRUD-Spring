#FROM amazoncorretto:11-alpine-jdk
#MAINTAINER ABE
#COPY target/practicaswrest-0.0.1-SNAPSHOT.jar  demo.jar
#ENTRYPOINT ["java","-jar","/demo.jar"]


FROM amazoncorretto:11-alpine-jdk

RUN apk update && apk add postgresql-client

COPY target/practicaswrest-0.0.1-SNAPSHOT.jar  demo.jar

ENV DB_HOST=localhost
ENV DB_PORT=5432
ENV DB_NAME=mi_basededatos
ENV DB_USER=usuario
ENV DB_PASSWORD=contraseña

ENTRYPOINT ["java","-jar","/demo.jar"]

EXPOSE 8080