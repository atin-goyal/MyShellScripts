#/bin/bash
#set -x
threshold=10
if [ "$1" == "" ]
then
today=$(date +"%b %d")
today1=$(date +"%Y-%m-%d")
else
today=$(date -d $1 +"%b %d")
today1=$(date -d $1 +"%Y-%m-%d")
fi

#Stuck Threads
Stuck_count=0
Stuck_count=$(grep "STUCK" *.out | grep -c "$today")
if [ $Stuck_count -gt 0 ]; then
echo "Stuck threads found" > ${today1}.log
echo "No of Stuck threads: $Stuck_count"  >> ${today1}.log
echo "/nSTUCK Threads" >> ${today1}.log
grep "STUCK" *.out | grep "$today" >> ${today1}.log
else
echo "No Stuck Threads" > ${today1}.log
fi

# BI Server Restart
echo "BI Server Restart" >> ${today1}.log
grep "RUNNING mode" bi_server*.log | grep "$today" >> ${today1}.log

# Access log Slow requests
Slow_count=`grep  "analytics" access.log.*| awk '{if ($3 > $threshold) print}'| wc -l`
printf "no of requests (analytics) taking more than $threshold seconds:%d\n" $Slow_count >> ${today1}.log
if [ $Slow_count -gt 0 ]
then
echo "Top 10 Slow requests (Analytics)" >> ${today1}.log
#grep "analytics" $access_log |awk '{if ($3>=10) print $2}|cut -c0-2|uniq -c ##hourly
grep "analytics" access.log.*|grep "$today1"|awk '{if ($3 > $threshold) print}'|sort -nr -k3|head >> ${today1}.log
fi

Slow_count=`grep  "xmlpserver" access.log.*| awk '{if ($3 > $threshold) print}' | wc -l`
printf "no of requests (xmlpserver) taking more than $threshold seconds:%d\n" $Slow_count >> ${today1}.log
if [ $Slow_count -gt 0 ]
then
echo "Top 10 Slow requests (xmlpserver)" >> ${today1}.log
#grep "analytics" $access_log |awk '{if ($3>=10) print $2}|cut -c0-2|uniq -c ##hourly
grep "xmlpserver" access.log.*|grep "$today1"|awk '{if ($3 > $threshold) print}'|sort -nr -k3|head >> ${today1}.log
fi


# Sawlog Logins
#grep "logged in" sawlog* | awk -F'-' '{print $3;}' | sort | cut -c0-6 | uniq -c ##hourly
echo "sawlog Logins" >>  ${today1}.log
grep "logged in" sawlog* |grep -c "$today1" >> ${today1}.log

# Nqquery slow queries
#echo $threshold
Slow_count=`grep "Physical query response time" nqquery*.log  | grep "$today1" | awk '{if ($21 > '$threshold' ) print}' | wc -l`
printf "No of SQLs taking more than $threshold secs: %d\n" $Slow_count >> ${today1}.log
if [ $Slow_count -gt 0 ]
then
if [ $Slow_count -gt 0 ]
then
echo "Top 10 Slow SQLs" >> ${today1}.log
grep "Physical query response time" nqquery*.log  | grep "$today1" | awk '{if ($21 > '$threshold') print}' | head >> ${today1}.log
fi

exit
