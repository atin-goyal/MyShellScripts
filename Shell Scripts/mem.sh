#!/bin/bash
cd PB9graph
files=`ls |grep -Po '.+(?=_[0-9]*_Graph.log)'`
cd ..
echo "File, PB8, PB9" > summary.txt
for i in `echo $files`
do
cd PB8
PB8_mem=`cat $i*|cut -d' ' -f4|sort -nr|head -1`
cd ../PB9graph
PB9_mem=`cat $i*|cut -d' ' -f4|sort -nr|head -1`
cd ..
echo "$i, $PB8_mem, $PB9_mem" >> summary.txt
done
exit
