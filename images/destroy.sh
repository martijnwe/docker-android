#!/bin/sh


if [ -z "$1" ]; then
echo destroy.sh [container] ]
echo stop, remove and remove associated image.
docker ps
exit 256
fi

MYIMG=`docker ps | grep $1 | awk '{print $2}'`

if [ -z "$MYIMG" ]; then
echo no such image for process $1 
docker ps
exit 255
fi

docker stop $1
docker rm $1
docker rmi -f $MYIMG
