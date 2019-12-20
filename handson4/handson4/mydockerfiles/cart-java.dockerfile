FROM weaveworksdemos/carts:0.4.8

USER root

RUN apk update \
     && apk add openjdk8-jre
COPY ./target/zkpwatcher.jar app.jar
COPY ./target/start-java.sh start.sh
RUN chown -R root:root /app.jar
RUN chmod +x start.sh
ENTRYPOINT /start.sh "carts"
