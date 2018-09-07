#!/bin/sh
#######################################################################################
# Author: Atin Goyal
# Usage : sh monitor.sh <interval in secs> <count> <process ID> <GC log file path>
#
# Output: Creates text files which contains the logs
#
# WARNING: all the preexisting log files created by this script will be overwritten
# Misc: if you want to monitor jstat then give the path for it and uncomment the line
#######################################################################################


nohup mpstat -P ALL $1 $2  | perl -MPOSIX -pe'$|++;$_=strftime"%m-%d-%Y %T - $_",localtime' >mp1.txt &
nohup vmstat $1 $2 | perl -MPOSIX -pe'$|++;$_=strftime"%m-%d-%Y %T - $_",localtime' >vm1.txt &
# nohup /usr/local/jive/java/bin/jstat -gc $3 $1*100 $2 | perl -MPOSIX -pe'$|++;$_=strftime"%m-%d-%Y %T - $_",localtime' > j1.txt &
# First executing top once to print headers and then no headers continuous output
nohup top -b -d 1 -n 1 -p $3 | grep PID >top1.txt &
nohup top -b -d $1 -n $2 -p $3 | grep $3 | perl -MPOSIX -pe'$|++;$_=strftime"%m-%d-%Y %T - $_",localtime' >> top1.txt &
nohup tail -f $4 >gc1.txt &
