/usr/local/bin/java.sh -Djava.security.egd=file:/dev/./urandom -jar zkpwatcher.jar $1 &
/usr/local/bin/java.sh -jar ./app.jar --port=80
