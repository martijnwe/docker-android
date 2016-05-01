#!/bin/sh


if [ -z "$1" ] ; then
echo run.sh [image] 
echo e.g. run.sh 765 

docker images
exit 256
fi

docker run -i -t  -d -v /home/martijnw/docker/android:/hostdir -p 8080:8080 $1
