FROM weaveworksdemos/catalogue:0.3.5

USER root

RUN apk update \
     && apk add openjdk8-jre
COPY ./target/zkpwatcher.jar app.jar
COPY ./target/start.sh start.sh
RUN chown -R root:root /app.jar
RUN chmod +x start.sh
ENTRYPOINT /start.sh
# CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar","catalogue","&"]
# USER myuser
# CMD ["/app", "-port=80"]
