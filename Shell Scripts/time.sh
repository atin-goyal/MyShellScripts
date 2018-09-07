#!/bin/bash
#set -x
all_time_total=`cat $1 |awk '{print $3}'`
time_total=0
all_time_post=`grep "POST" $1 |awk '{print $3}'|more`
time_post=0
temp=0

for temp  in `echo $all_time_total`
do
        time_total=`echo $time_total + $temp |bc`
done

echo "total time= $time_total"

temp=0
for temp  in `echo $all_time_post`
do
        time_post=`echo $time_post + $temp |bc`
done

echo "POST time= $time_post"

exit

