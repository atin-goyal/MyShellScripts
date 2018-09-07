#!/bin/bash
#set -x
# Prints the top ten physical sqls based on RT with their logical and physical hash. Optionally physical sql text can be printed also
total_lines=`cat $1|wc -l`
grep "Physical query response time" $1 |sort -nr -k23|head >top_ten.txt
echo "Top ten physical query RTs are as follows:"
echo "Query Time, Logical Hash, Physical Hash, RT"
#count=`echo $match|wc -l`
i=0
while read i
do
id=`echo $i | awk '{print $26}'|cut -d'<' -f3|cut -d'>' -f1`
phash=`grep -n "$id" $1 | grep "Sending query to database named"|head -1|awk '{print $39}'|cut -d':' -f1`
rt=`echo $i|awk '{print $23}'`
if [ -z "$phash" ]
then
echo "Query not found for exchange id: $id with rt: $rt"
continue
fi
query_time=`grep -n "$id" $1 | grep "Sending query to database named"|head -1|awk '{print $1}'|cut -d'[' -f2|cut -d'.' -f1`
lhash=`grep -n "$id" $1 | grep "Sending query to database named"|head -1|awk '{print $35}'|cut -d',' -f1`
echo "$query_time, $lhash, $phash, $rt"
done <  top_ten.txt

echo "Do you want to print sql texts for the above?[y/n]"
read resp

if [ "$resp" == "y" ]
then
while read i
do
id=`echo $i | awk '{print $26}'|cut -d'<' -f3|cut -d'>' -f1`
start_line=`grep -n "$id" $1 | grep "Sending query to database named"|head -1|cut -d':' -f1`
phash=`grep -n "$id" $1 | grep "Sending query to database named"|head -1|awk '{print $39}'|cut -d':' -f1`
rt=`echo $i|awk '{print $23}'`
if [ -z $phash ]
then
echo "Query not found for exchange id: $id with rt: $rt"
continue
fi
diff=`echo $total_lines-$start_line|bc`
tail -$diff $1 >tmp_query.txt
end_line=`grep -n "OracleBIServerComponent" tmp_query.txt|head -1|cut -d':' -f1`
end_line=`echo $end_line-2|bc`
head -$end_line tmp_query.txt >$phash.txt
echo "$phash.txt"
done < top_ten.txt
fi
exit