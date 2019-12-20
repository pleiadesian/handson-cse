FROM dplsming/sockshop-cataloguedb:0.1

USER root

COPY ./target/zkpwatcher.jar app.jar
COPY ./target/start-mongo.sh start.sh
RUN chown -R root:root /app.jar
RUN chmod +x start.sh
ENTRYPOINT /start.sh "catalogue-db"