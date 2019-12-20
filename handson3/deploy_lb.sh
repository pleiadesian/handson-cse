sudo docker stop frontend frontend-1 frontend-2 frontend-3 frontend-4 payment shipping user user-db carts carts-db orders orders-db catalogue catalogue-db nginx-router-nolb nginx-router-lb session-db
sudo docker network rm handson3
sudo docker network create --driver=bridge --subnet=172.26.0.0/16 handson3
sudo docker run --rm --name catalogue-db --network handson3 --ip=172.26.0.2 -d dplsming/sockshop-cataloguedb:0.1
sudo docker run --rm --name catalogue --network handson3 --ip=172.26.0.3 --add-host=catalogue-db:172.26.0.2 -d weaveworksdemos/catalogue:0.3.5
sudo docker run --rm --name orders-db --network handson3 --ip=172.26.0.4 -d mongo:3.4
sudo docker run --rm --name orders --network handson3 --ip=172.26.0.5 --add-host=orders-db:172.26.0.4 --add-host=carts:172.26.0.7 --add-host=user:172.26.0.9 --add-host=shipping:172.26.0.10 --add-host=payment:172.26.0.11 -d weaveworksdemos/orders:0.4.7
sudo docker run --rm --name carts-db --network handson3 --ip=172.26.0.6 -d mongo:3.4
sudo docker run --rm --name carts --network handson3 --ip=172.26.0.7 --add-host=carts-db:172.26.0.6 --add-host=user:172.26.0.9 -d weaveworksdemos/carts:0.4.8
sudo docker run --rm --name user-db --network handson3 --ip=172.26.0.8 -d mongo:3.4
sudo docker run --rm --name user --network handson3 --ip=172.26.0.9 --add-host=user-db:172.26.0.8 --add-host=carts:172.26.0.7 -e MONGO_HOST=user-db:27017 -d weaveworksdemos/user:0.4.4
sudo docker run --rm --name shipping --network handson3 --ip=172.26.0.10 -d weaveworksdemos/shipping:0.4.8
sudo docker run --rm --name payment --network handson3 --ip=172.26.0.11 -d weaveworksdemos/payment:0.4.3
sudo docker run --rm --name session-db --network handson3 --ip=172.26.0.12 -d redis
sudo docker run --rm --name frontend --network handson3 --ip=172.26.0.13 --add-host=catalogue:172.26.0.3 --add-host=orders:172.26.0.5 --add-host=carts:172.26.0.7 --add-host=user:172.26.0.9 --add-host=shipping:172.26.0.10 --add-host=payment:172.26.0.11 --add-host=session-db:172.26.0.12 -e SESSION_REDIS=true -d dplsming/sockshop-frontend:0.1
sudo docker run --rm --name frontend-1 --network handson3 --ip=172.26.0.14 --add-host=catalogue:172.26.0.3 --add-host=orders:172.26.0.5 --add-host=carts:172.26.0.7 --add-host=user:172.26.0.9 --add-host=shipping:172.26.0.10 --add-host=payment:172.26.0.11 --add-host=session-db:172.26.0.12 -e SESSION_REDIS=true -d dplsming/sockshop-frontend:0.1
sudo docker run --rm --name frontend-2 --network handson3 --ip=172.26.0.15 --add-host=catalogue:172.26.0.3 --add-host=orders:172.26.0.5 --add-host=carts:172.26.0.7 --add-host=user:172.26.0.9 --add-host=shipping:172.26.0.10 --add-host=payment:172.26.0.11 --add-host=session-db:172.26.0.12 -e SESSION_REDIS=true -d dplsming/sockshop-frontend:0.1
sudo docker run --rm --name frontend-3 --network handson3 --ip=172.26.0.16 --add-host=catalogue:172.26.0.3 --add-host=orders:172.26.0.5 --add-host=carts:172.26.0.7 --add-host=user:172.26.0.9 --add-host=shipping:172.26.0.10 --add-host=payment:172.26.0.11 --add-host=session-db:172.26.0.12 -e SESSION_REDIS=true -d dplsming/sockshop-frontend:0.1
sudo docker run --rm --name frontend-4 --network handson3 --ip=172.26.0.17 --add-host=catalogue:172.26.0.3 --add-host=orders:172.26.0.5 --add-host=carts:172.26.0.7 --add-host=user:172.26.0.9 --add-host=shipping:172.26.0.10 --add-host=payment:172.26.0.11 --add-host=session-db:172.26.0.12 -e SESSION_REDIS=true -d dplsming/sockshop-frontend:0.1
sudo docker run --rm --network handson3 --ip=172.26.0.18 --name nginx-router-nolb -p 8080:80 -v `pwd`/public:/public -v `pwd`/config-nolb:/etc/nginx/conf.d -v `pwd`/logs:/var/log/nginx --add-host=frontend:172.26.0.13 -d nginx
sudo docker run --rm --network handson3 --ip=172.26.0.19 --name nginx-router-lb -p 8081:80 -v `pwd`/public:/public -v `pwd`/config-lb:/etc/nginx/conf.d -v `pwd`/logs:/var/log/nginx --add-host=frontend:172.26.0.13 --add-host=frontend-1:172.26.0.14 --add-host=frontend-2:172.26.0.15 --add-host=frontend-3:172.26.0.16 --add-host=frontend-4:172.26.0.17 -d nginx

