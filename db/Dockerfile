FROM postgres

ENV POSTGRES_USER infomaniak
ENV POSTGRES_PASSWORD infomaniak
ENV POSTGRES_DB infomaniak

COPY create_table.sql /docker-entrypoint-initdb.d/create_table.sql
