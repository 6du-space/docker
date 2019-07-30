#!/usr/bin/env bash

PORT_RANGE="1000-2000"
HOSTNAME=yf
NET=6du
IP=100
SUBNET=172.20.0
VPS_IP=$SUBNET.1
IMAGE=6dus/6du-dev
NAME=$HOSTNAME

docker network create --subnet=$SUBNET.0/16 $NET

docker run \
-d \
--add-host=vps:$VPS_IP \
-p $PORT_RANGE:$PORT_RANGE \
-v /var/log/docker/$NAME:/var/log \
-v /mnt/docker/$NAME/home:/home \
-v /mnt/docker/$NAME/root:/root \
-v /tmp/docker/$NAME:/tmp \
-v /mnt/share:/mnt/share \
-h $HOSTNAME \
--name $NAME \
--net $NET \
--ip $SUBNET.$IP \
--device /dev/fuse\
--cap-add SYS_ADMIN\
--restart=always \
$IMAGE
