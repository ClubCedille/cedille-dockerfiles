FROM mongo:7-jammy

ENV MONGO_INITDB_ROOT_USERNAME admin
ENV MONGO_INITDB_ROOT_PASSWORD secret
ENV MONGO_INITDB_DATABASE admin

ADD mongo-init.js /docker-entrypoint-initdb.d/