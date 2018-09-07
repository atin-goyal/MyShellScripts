#!/bin/bash
# usage ./pinger.sh <hostname or ip address>
i=1
while [ $i -ne 4 ]
do
ping -i 2  -c 25  -s 500 $1 > ping_500_$1_$i.log
ping -i 2  -c 25  -s 1000 $1 > ping_1000_$1_$i.log 
i=`expr $i + 1`
done
exit
