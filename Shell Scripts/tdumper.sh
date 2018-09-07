#!/bin/bash
#set -x
managedWLSBIserverpid=`ps -ef | grep "\-Dweblogic.Name" |grep -v grep | grep -v "\-Dweblogic.Name=AdminServer" | grep BI | awk '{print $2}'`
saspid=`grep "coreapplication_obis1\/" /proc/*/environ 2> /dev/null | awk -F'/' '{print $3}'`
i=1
while [ $i -le 20 ]
do
pstack $saspid > obis1_${i}.pstack
jstack $managedWLSBIserverpid > bi_server${i}.jstack
(( i++ ))
sleep 60
done
exit
