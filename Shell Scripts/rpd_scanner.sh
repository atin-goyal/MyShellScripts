#!/bin/bash
#set -x
LTS_Start_Nums=`grep -n "DECLARE LOGICAL TABLE SOURCE" $1| cut -d: -f1`
LTS_Start_No=0
mkdir LTS
for LTS_Start_No in `echo $LTS_Start_Nums`
do
        echo "Line no:$LTS_Start_No"
        temp=`echo $LTS_Start_No +1|bc`
        LTS_End_No=`sed -n ''$temp',$p' $1 | grep -nm1 "DECLARE" | cut -d: -f1`
        LTS_End_No=`echo $LTS_End_No - 2| bc`
        LTS_End_No=`echo $LTS_Start_No + $LTS_End_No|bc`
        LTS_Name=`sed -n ''$LTS_Start_No','$LTS_End_No'p' $1 | grep "DECLARE LOGICAL TABLE SOURCE" | sed 's/.*AS//g' | awk -F\" '{print $2}'`
        #break
        if [ "`echo $LTS_Name | grep -c "PVO"`" = "1" ] && [ "`sed -n ''$LTS_Start_No','$LTS_End_No'p' $1 | grep -c 'VALUEOF(NQ_SESSION."USER_LANGUAGE_CODE")'`" -ge "1" ]
        then
                if [ "`sed -n ''$LTS_Start_No','$LTS_End_No'p' $1 | grep -c 'AS {LOOKUP'`" -ge "1" ] || [ "`sed -n ''$LTS_Start_No','$LTS_End_No'p' $1 | grep -c 'DETAIL FILTER'`" -ge "1" ]
                then
                        LTS_Name=`echo $LTS_Name | tr ' ' '_'`
                        touch ./LTS/$LTS_Name.txt
                        echo "`sed -n ''$LTS_Start_No','$LTS_End_No'p' $1`" > ./LTS/$LTS_Name.txt
                fi
        fi
done
exit