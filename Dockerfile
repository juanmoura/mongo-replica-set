FROM ubuntu:20.04 as base

# MongoDB download URL
ARG VERSION=6.0.18
ARG MONGOSH_URL=https://downloads.mongodb.com/compass/mongodb-mongosh_2.3.1_amd64.deb
ARG DB_URL=https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-${VERSION}.tgz

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl && \
    # Baixando e instalando o MongoDB
    curl -OL ${DB_URL} && \
    tar -zxvf mongodb-linux-x86_64-ubuntu2004-${VERSION}.tgz && \
    mv ./mongodb-linux-x86_64-ubuntu2004-${VERSION}/bin/* /usr/local/bin/ && \
    rm -rf ./mongodb-linux-x86_64-ubuntu2004-${VERSION} && rm ./mongodb-linux-x86_64-ubuntu2004-${VERSION}.tgz && \
    # Baixando e instalando o mongosh
    curl -OL ${MONGOSH_URL} && \
    apt-get install -y ./mongodb-mongosh_2.3.1_amd64.deb && \
    rm ./mongodb-mongosh_2.3.1_amd64.deb

COPY ./init-mongodbs.sh ./init-replica.sh ./entry-point.sh /

RUN chmod +x /init-mongodbs.sh && \
    chmod +x /init-replica.sh && \
    chmod +x /entry-point.sh

# Data directory
ARG DB1_DATA_DIR=/var/lib/mongo1
ARG DB2_DATA_DIR=/var/lib/mongo2
ARG DB3_DATA_DIR=/var/lib/mongo3

# Log directory
ARG DB1_LOG_DIR=/var/log/mongodb1
ARG DB2_LOG_DIR=/var/log/mongodb2
ARG DB3_LOG_DIR=/var/log/mongodb3

# DB Ports
ARG DB1_PORT=27017
ARG DB2_PORT=27018
ARG DB3_PORT=27019

RUN mkdir -p ${DB1_DATA_DIR} && \
    mkdir -p ${DB1_LOG_DIR} && \
    mkdir -p ${DB2_DATA_DIR} && \
    mkdir -p ${DB2_LOG_DIR} && \
    mkdir -p ${DB3_DATA_DIR} && \
    mkdir -p ${DB3_LOG_DIR} && \
    chown `whoami` ${DB1_DATA_DIR} && \
    chown `whoami` ${DB1_LOG_DIR} && \
    chown `whoami` ${DB2_DATA_DIR} && \
    chown `whoami` ${DB2_LOG_DIR} && \
    chown `whoami` ${DB3_DATA_DIR} && \
    chown `whoami` ${DB3_LOG_DIR}

EXPOSE ${DB1_PORT}
EXPOSE ${DB2_PORT}
EXPOSE ${DB3_PORT}

ENTRYPOINT [ "bash", "entry-point.sh" ]
