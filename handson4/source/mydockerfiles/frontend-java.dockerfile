FROM dplsming/sockshop-frontend:0.1

USER root

RUN apk update \
     && apk add openjdk8-jre
COPY ./target/zkpwatcher.jar zkpwatcher.jar
COPY ./target/start-frontend.sh start.sh
RUN chown -R root:root zkpwatcher.jar
RUN chmod +x start.sh
ENTRYPOINT ./start.sh "frontend"
