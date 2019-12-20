sudo docker stop frontend payment shipping user user-db carts carts-db orders orders-db catalogue catalogue-db
sudo docker network rm handson4
sudo docker network create --driver=bridge handson4
sudo docker run --rm --name catalogue-db --network handson4 -d cataloguedb-java
sudo docker run --rm --name catalogue --network handson4 -d catalogue-java
sudo docker run --rm --name orders-db --network handson4 -d ordersdb-java
sudo docker run --rm --name orders --network handson4 -d orders-java
sudo docker run --rm --name carts-db --network handson4 -d cartsdb-java
sudo docker run --rm --name carts --network handson4 -d carts-java
sudo docker run --rm --name user-db --network handson4 -d userdb-java
sudo docker run --rm --name user --network handson4 -e MONGO_HOST=user-db:27017 -d user-java
sudo docker run --rm --name shipping --network handson4 -d shipping-java
sudo docker run --rm --name payment --network handson4 -d payment-java
sudo docker run --rm --name frontend --network handson4 -e SESSION_REDIS=true -p 30000:8079 -d frontend-java

