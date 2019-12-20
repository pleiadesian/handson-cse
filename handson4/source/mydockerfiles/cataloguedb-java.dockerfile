FROM dplsming/sockshop-cataloguedb:0.1
# FROM weaveworksdemos/catalogue-db

USER root

RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 \
     && apt update \
     && apt install openjdk-8-jre -y
COPY ./target/zkpwatcher.jar zkpwatcher.jar
COPY ./target/start-cataloguedb.sh start.sh
COPY ./target/sources.list /etc/apt/sources.list
RUN chown -R root:root zkpwatcher.jar
RUN chmod +x start.sh
ENTRYPOINT ./start.sh "catalogue-db"
