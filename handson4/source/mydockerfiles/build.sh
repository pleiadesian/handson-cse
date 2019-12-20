docker build -f catalogue-java.dockerfile -t catalogue-java .
docker build -f cataloguedb-java.dockerfile -t cataloguedb-java .
docker build -f carts-java.dockerfile -t carts-java .
docker build -f cartsdb-java.dockerfile -t cartsdb-java .
docker build -f orders-java.dockerfile -t orders-java .
docker build -f ordersdb-java.dockerfile -t ordersdb-java .
docker build -f user-java.dockerfile -t user-java .
docker build -f userdb-java.dockerfile -t userdb-java .
docker build -f shipping-java.dockerfile -t shipping-java .
docker build -f payment-java.dockerfile -t payment-java .
docker build -f frontend-java.dockerfile -t frontend-java .

