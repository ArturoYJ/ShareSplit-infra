FROM postgres:16-alpine

# Render requiere que el puerto esté expuesto. Aunque Postgres usa el 5432, 
# Render inyecta la variable de entorno PORT, así que es buena práctica tener el estándar.
EXPOSE 5432

# Copiar las migraciones para que Postgres las ejecute automáticamente 
# al crear la base de datos por primera vez.
COPY ./migrations /docker-entrypoint-initdb.d/
