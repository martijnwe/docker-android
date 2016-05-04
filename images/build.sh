#!/bin/sh
if [ -z "$1" ]; then
echo build.sh [dockerfile] 
ls -ltr
exit 256
fi

docker build -f $1 .

