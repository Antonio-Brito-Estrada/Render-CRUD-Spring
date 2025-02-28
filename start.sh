#!/bin/bash

# Crear los directorios de PostgreSQL si no existen
mkdir -p /run/postgresql
chown postgres:postgres /run/postgresql
chmod 775 /run/postgresql

# Iniciar PostgreSQL si no está iniciado
if [ ! -d "/var/lib/postgresql/data" ]; then
    su - postgres -c "initdb -D /var/lib/postgresql/data"
fi

# Iniciar PostgreSQL
su - postgres -c "pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/data/logfile start"

# Esperar unos segundos para que PostgreSQL arranque
sleep 5

# Crear la base de datos y el usuario si no existen
su - postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'\" | grep -q 1 || psql -c \"CREATE DATABASE $DB_NAME;\""
su - postgres -c "psql -tc \"SELECT 1 FROM pg_roles WHERE rolname = '$DB_USER'\" | grep -q 1 || psql -c \"CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';\""
su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;\""

# Ejecutar el servicio Java
echo "Iniciando aplicación Java..."
exec java -jar /demo.jar &  # Ejecutar Java en segundo plano

# Iniciar el servidor Python con CORS
echo "Iniciando servidor Python con CORS..."
python3 /app.py