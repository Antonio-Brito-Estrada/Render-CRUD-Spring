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
echo "Esperando a que PostgreSQL se inicie..."
sleep 5

# Crear la base de datos y el usuario si no existen
su - postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'\" | grep -q 1 || psql -c \"CREATE DATABASE $DB_NAME;\""
su - postgres -c "psql -tc \"SELECT 1 FROM pg_roles WHERE rolname = '$DB_USER'\" | grep -q 1 || psql -c \"CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';\""
su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON SCHEMA public TO $DB_USER;\""
su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;\""
su - postgres -c "psql -c \"GRANT USAGE, CREATE ON SCHEMA public TO $DB_USER;\""
su - postgres -c "psql -c \"GRANT CREATE ON DATABASE $DB_NAME TO $DB_USER;\""

# Otorgar permisos de SELECT, INSERT, UPDATE, DELETE sobre todas las tablas en el esquema public
su - postgres -c "psql -c \"GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO $DB_USER;\""

# Otorgar permisos sobre las secuencias (para poder hacer insert en tablas con autoincremento)
su - postgres -c "psql -c \"GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;\""

# Otorgar permisos para crear nuevos objetos dentro del esquema public
su - postgres -c "psql -c \"GRANT CREATE ON SCHEMA public TO $DB_USER;\""

# Configurar permisos por defecto para cualquier tabla que se cree en el futuro
su - postgres -c "psql -c \"ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $DB_USER;\""

# Configurar permisos por defecto para cualquier secuencia que se cree en el futuro
su - postgres -c "psql -c \"ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO $DB_USER;\""

# Comprobar si PostgreSQL está accesible
echo "Comprobando conexión a la base de datos..."
until psql -h localhost -U "$DB_USER" -d "$DB_NAME" -c '\q'; do
    echo "Esperando a PostgreSQL..."
    sleep 2
done

echo "Conexión a PostgreSQL exitosa."

# Iniciar el servicio Java
echo "Iniciando aplicación Java..."
exec java -jar /demo.jar &  # Ejecutar Java en segundo plano

# Esperar que la aplicación Java esté lista (si es necesario, ajustar el tiempo)
sleep 10

# Iniciar el servidor Python con CORS
echo "Iniciando servidor Python con CORS..."
python3 /app.py