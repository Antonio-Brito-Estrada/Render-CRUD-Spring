#!/bin/bash

mkdir -p /run/postgresql
chown postgres:postgres /run/postgresql
chmod 775 /run/postgresql

if [ ! -d "/var/lib/postgresql/data" ]; then
    su - postgres -c "initdb -D /var/lib/postgresql/data"
fi


su - postgres -c "pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/data/logfile start"
sleep 5


su - postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'\" | grep -q 1 || psql -c \"CREATE DATABASE $DB_NAME;\""
su - postgres -c "psql -tc \"SELECT 1 FROM pg_roles WHERE rolname = '$DB_USER'\" | grep -q 1 || psql -c \"CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';\""
su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;\""

exec java -jar /demo.jar