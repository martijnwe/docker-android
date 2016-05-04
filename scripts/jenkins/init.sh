#!/bin/sh
if [ -z "$1" ]; then
echo init.sh [env.yml] 
exit 256
fi

service jenkins start
sleep 10

ruby plugins.rb $1
ruby mkjob.rb $1


while :
do
    sleep 60
done

