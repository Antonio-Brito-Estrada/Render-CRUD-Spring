#FROM amazoncorretto:11-alpine-jdk
#MAINTAINER ABE
#COPY target/practicaswrest-0.0.1-SNAPSHOT.jar  demo.jar
#ENTRYPOINT ["java","-jar","/demo.jar"]


FROM amazoncorretto:11-alpine-jdk

# Instalar PostgreSQL, herramientas necesarias y Python
RUN apk update && apk add postgresql postgresql-contrib postgresql-client bash python3

# Crear los directorios de PostgreSQL si no existen
RUN mkdir -p /run/postgresql && chown postgres:postgres /run/postgresql && chmod 775 /run/postgresql

# Copiar la aplicación Java y Python y el script
COPY target/practicaswrest-0.0.1-SNAPSHOT.jar  demo.jar
COPY app.py /app.py
COPY start.sh /start.sh

# Dar permisos de ejecución al script de inicio
RUN chmod +x /start.sh

# Definir variables de entorno
ENV DB_HOST=localhost
ENV DB_PORT=5432
ENV DB_NAME=mi_basededatos
ENV DB_USER=usuario
ENV DB_PASSWORD=contraseña

# Exponer los puertos necesarios
EXPOSE 5432 8080

# Ejecutar el script de inicio
ENTRYPOINT ["/bin/bash", "/start.sh"]