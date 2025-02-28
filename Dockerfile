#FROM amazoncorretto:11-alpine-jdk
#MAINTAINER ABE
#COPY target/practicaswrest-0.0.1-SNAPSHOT.jar  demo.jar
#ENTRYPOINT ["java","-jar","/demo.jar"]


FROM amazoncorretto:11-alpine-jdk
RUN apk update && apk add postgresql postgresql-contrib postgresql-client bash
RUN mkdir -p /run/postgresql && chown postgres:postgres /run/postgresql && chmod 775 /run/postgresql

COPY target/practicaswrest-0.0.1-SNAPSHOT.jar  demo.jar
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENV DB_HOST=localhost
ENV DB_PORT=5432
ENV DB_NAME=mi_basededatos
ENV DB_USER=usuario
ENV DB_PASSWORD=contraseña

EXPOSE 5432 8080
ENTRYPOINT ["/bin/bash", "/start.sh"]