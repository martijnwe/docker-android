#!/bin/sh
if [ -z "$1" ]; then
echo init.sh [env.yml] 
exit 256
fi

service jenkins start
sleep 10

ruby /develop/scripts/jenkins/upgrade.rb $1
ruby /develop/scripts/jenkins/plugins.rb $1
ruby /develop/scripts/jenkins/mkjob.rb $1


while :
do
    sleep 60
done

