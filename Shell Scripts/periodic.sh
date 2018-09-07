# this shell scripts execute the netstat command every 15 secs 360 times so 90 mins
#!bin/sh
i=0
while [ $i -ne 600 ]
do
lsof |grep "/bi/app/instances/instance1/tmp"|grep nqsserver|wc - l >> obis_tmp_count.txt
sleep 2
i=`expr $i + 1`
done
