java -Djava.security.egd=file:/dev/./urandom -jar app.jar $1 &
docker-entrypoint.sh "mongod"
