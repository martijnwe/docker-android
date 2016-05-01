#!/bin/sh


if [ -z "$1" ]; then
echo exec.sh [container] [command]
echo e.g. exec.sh 765 bash

docker ps
exit 256
fi

DOCKERCMD=$2
if [ -z "$2" ]; then
  DOCKERCMD=bash
fi

docker exec -it $1 $DOCKERCMD
