#!/bin/bash
#set -vx
files=`ls |grep -Po '.+(?=_[0-9]*_Graph.log)' | sort | uniq`
rm -rf final_*
mkdir final_cpu
mkdir final_rss
echo > final_cpu/tmp
echo > final_cpu/tmp2
echo > final_rss/tmp
echo > final_rss/tmp2
title="time"
count=0
for i in `echo $files`
do
file1=`ls "$i"*|sort`
for j in `echo $file1`
do
cat $j | cut -d' ' -f1,2 >> final_cpu/$i.log
sort final_cpu/$i.log >final_cpu/$i.log2
mv final_cpu/$i.log2 final_cpu/$i.log
cat $j | cut -d' ' -f1,2 >> final_rss/$i.log
sort final_rss/$i.log >final_rss/$i.log2
mv final_rss/$i.log2 final_rss/$i.log
done
printf -v title '%s %s' "$title" "$i"

if [ "$count" -ne "0" ]
then
k=2
fields="0"
while [ "$k" -le "$column" ]
do
printf -v fields '%s,1.%d' "$fields" "$k"
k=`expr $k + 1`
done
printf -v fields '%s,2.2' "$fields"
echo $fields
echo $i
join -a1 -a2 -e '0' -o $fields final_cpu/tmp final_cpu/$i.log > final_cpu/tmp2
cat final_cpu/tmp2 > final_cpu/tmp

join -a1 -a2 -e '0' -o $fields final_rss/tmp final_rss/$i.log > final_rss/tmp2
cat final_rss/tmp2 > final_rss/tmp
column=`expr $column + 1`
if [ "$column" -eq "18" ]
then
echo
#exit
fi
else
cat final_cpu/$i.log > final_cpu/tmp
cat final_rss/$i.log > final_rss/tmp
count=1
column=2
fi
done
echo $title > final_cpu/result_cpu.txt
cat final_cpu/tmp >> final_cpu/result_cpu.txt

echo $title > final_rss/result_rss.txt
cat final_rss/tmp >> final_rss/result_rss.txt

exit
