FROM mysql
ENV MYSQL_DATABASE employees_db
copy ./sql-script/ /docker-entrypoint-initdb.d/
