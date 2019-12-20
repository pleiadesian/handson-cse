java -Djava.security.egd=file:/dev/./urandom -jar zkpwatcher.jar $1 &
docker-entrypoint.sh "mysqld"
