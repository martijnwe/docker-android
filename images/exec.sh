#!/bin/sh


if [ -z "$1" ] && [ -z "$2" ]; then
echo exec.sh [container] [command]
echo e.g. exec.sh 765 bash

docker ps
exit 256
fi

docker exec -it $1 $2
