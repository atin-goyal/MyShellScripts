#!/bin/bash
echo "Enter Domain Home:"
read Domain_Home
echo "Number Of Days To Collect :"
read No_Of_Days
echo "Enter Mode 1) For All Log files or Any Other Value For AccessFiles & Heap Pressure(Default):"
read State
Domain_Name=$(basename $Domain_Home)
if [ "$No_Of_Days" == "" ]
then
No_Of_Days=10;
fi
if [ "$State" == "1" ]
then
find  $Domain_Home/servers/*rver*/logs/ -maxdepth 1 \( -name '*log*' -o -name '*.out*' \)  -type f -mtime -$No_Of_Days |  xargs zip $Domain_Name.zip  2>/dev/null;
else
find  $Domain_Home/servers/*rver*/logs/ -maxdepth 1 -name 'access*'  -type f -mtime -$No_Of_Days | xargs zip $Domain_Name.zip  2>/dev/null;
fi
if [ "$State" != "1" ]
then
echo "------------------------------Heap Pressure For "$Domain_Name"--------------------------"
for NAME in $(ls  $Domain_Home/servers | grep -i 'server')
do
echo "Heap Pressure For "$NAME;
##find  $Domain_Home/servers/$NAME/logs/ -name '*out*'  -type f -mtime -$No_Of_Days | xargs grep -ir '\->'  | awk '{print substr($11,11,6)"  "substr($12,1,10)}' | grep -v ',' | awk 'BEGIN{s=0;}{s=s+$1;}END{print "Avg Heap Usage: "s/NR "KB Total Heap: "$2;}'  2>/dev/null;
find  $Domain_Home/servers/$NAME/logs/ -name '*out*'  -type f -mtime -$No_Of_Days | xargs grep -ir '\->' | awk '{gsub(/KB/, "", $11); print substr($11, (index($11, "->")+2)) "  "substr($12,2,(index($12,")")-4))}' | grep -v ',' | awk 'BEGIN{s=0;}{s=s+$1;}ENDBEGIN{max = 0;}{if($2>max)max=$2;}END{print "Avg Heap Usage: "s/NR "KB Max Heap: "max"KB";}' 2>/dev/null;
echo "";
done
echo "";
echo "----------------------------------------------------------------";
echo "Memory Statistics For The Host";
echo "";
find /var/log/sa -name 'sa[0-9]*' -mtime -$No_Of_Days | xargs ls -tr | awk '{print "sar -r -f "$1" | grep -i -e mem -e Average -e Linux"}' | bash;
echo "----------------------------------------------------------------";
echo "";
echo "Swap Area Statistics For The Host";
echo "";
find /var/log/sa -name 'sa[0-9]*' -mtime -$No_Of_Days | xargs ls -tr | awk '{print "sar -W -f "$1" | grep -i -e swp -e Average -e Linux"}' | bash;
echo "----------------------------------------------------------------";
echo "";
echo "CPU Statistics For The Host";
echo "";
find /var/log/sa -name 'sa[0-9]*' -mtime -$No_Of_Days | xargs ls -tr | awk '{print "sar -f "$1" | grep -i -e idle -e Average -e Linux"}' | bash;
fi
