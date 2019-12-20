FROM weaveworksdemos/payment:0.4.3

USER root

RUN apk update \
     && apk add openjdk8-jre
COPY ./target/zkpwatcher.jar app.jar
COPY ./target/start.sh start.sh
RUN chown -R root:root /app.jar
RUN chmod +x start.sh
ENTRYPOINT /start.sh "payment"
