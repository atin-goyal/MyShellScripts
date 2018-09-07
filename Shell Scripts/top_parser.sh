#!/bin/bash
touch parsed_$1.log
#set -x
flag=0
act_used=0
while read i
do

#get time
bol_top=`echo $i | grep -c "top "`
if [ "$bol_top" -gt "0" ]
then
date=`echo $i|awk '{print $3}'`
fi

#get used and buffers
bol_mem=`echo $i|grep -c "Mem:"`
if [ "$bol_mem" -gt "0" ]
then
used=`echo $i|awk '{print $4}'|cut -f1 -d'k'`
buffer=`echo $i|awk '{print $8}'|cut -f1 -d'k'`
fi

#get cached
bol_cach=`echo $i|grep -c "Swap:"`
if [ "$bol_cach" -gt "0" ]
then
flag=1
cached=`echo $i|awk '{print $8}'|cut -f1 -d'k'`
fi

if [ "$flag" -eq "1" ]
then
act_used=`echo $used-$buffer|bc`
act_used=`echo $act_used-$cached|bc`
echo $date,$act_used >>parsed_$1.log
fi

flag=0
#exit
done < $1
exit
