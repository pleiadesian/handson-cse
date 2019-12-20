FROM mongo:3.4

USER root

RUN apt-get update \
    && apt-get install openjdk-8-jdk --assume-yes

COPY ./target/zkpwatcher.jar app.jar
COPY ./target/start-mongo.sh start.sh
RUN chown -R root:root app.jar
RUN chmod +x start.sh
ENTRYPOINT ./start.sh "carts-db"
