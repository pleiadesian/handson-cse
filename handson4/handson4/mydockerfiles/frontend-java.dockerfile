FROM dplsming/sockshop-frontend:0.1

USER root

COPY ./target/zkpwatcher.jar app.jar
COPY ./target/start-frontend.sh start.sh
RUN chown -R root:root /app.jar
RUN chmod +x start.sh
ENTRYPOINT /start.sh "frontend"
