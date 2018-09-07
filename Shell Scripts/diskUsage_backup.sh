#!/bin/bash

LOGDIR=./Sumanth_DiskLogs
LOGFILENAME=Apple__NoCond_OCT15_FODuplicate_Bug_run1
OBIPSTMP=/export/home/perfuser/BISHIPHOME_MAIN_LINUX.X64_130925.1904/instances/instance1/tmp/OracleBIPresentationServicesComponent/coreapplication_obips1
DefaultPool=/export/home/perfuser/BISHIPHOME_MAIN_LINUX.X64_130925.1904/instances/instance1/tmp/OracleBIPresentationServicesComponent/coreapplication_obips1/defaultpool
DXE=/export/home/perfuser/BISHIPHOME_MAIN_LINUX.X64_130925.1904/instances/instance1/tmp/OracleBIPresentationServicesComponent/coreapplication_obips1/dxe
JHTMP=/export/home/perfuser/BISHIPHOME_MAIN_LINUX.X64_130925.1904/instances/instance1/tmp/OracleBIJavaHostComponent/coreapplication_obijh1

sleepTime=5
if [ ! -e "$LOGDIR" ]; then
  echo "$LOGDIR doesn't exist!.  Creating it..."
  mkdir $LOGDIR
fi


for (( i=1; i<=2000 ; i++ )) 
do

  #echo $i 
  echo `date` >> $LOGDIR/$LOGFILENAME
  echo du -sh $OBIPSTMP/*.tmp $DefaultPool/* $DXE $JHTMP/* /tmp/XLS* /tmp/xdo* \> $LOGDIR/$LOGFILENAME
  du -sh $OBIPSTMP/*.tmp $DefaultPool/* $DXE/* $JHTMP/* /tmp/XLS* /tmp/xdo* >> $LOGDIR/$LOGFILENAME
  
cat $LOGDIR/$LOGFILENAME

  echo sleep $sleepTime
  sleep $sleepTime
done

