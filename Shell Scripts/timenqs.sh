#!/bin/bash
#set -x
init_block_timestamps=`grep "milliseconds at init block" $1|awk '{print $1}'`
start_timestamp=`head -n1 $1|awk '{print $1}'|tr '[' ' '|tr ']' ' '|tr 'T' ' '`
end_timestamp=`tail -n1 $1|awk '{print $1}'|tr '[' ' '|tr ']' ' '|tr 'T' ' '`
all_init_block_name=`grep "milliseconds at init block" $1|cut -d' ' -f 20- `
all_time_taken_by_init_block=`grep "milliseconds at init block" $1|awk '{print $14}'`

all_init_block_name=`echo $all_init_block_name | tr ' ' '~' | tr '.' ' '`
#init_block_timestamps=`echo $init_block_timestamps|tr ' ' '~' | tr '.' ' '`

field_count=1
echo ",,$start_timestamp"
for init_block_name in `echo $all_init_block_name`
do
#	time_taken_by_init_block=`echo $all_time_taken_by_init_block | awk "{print $field_count}"`
	time_taken_by_init_block=`echo $all_time_taken_by_init_block | cut -d' ' -f${field_count}`
	init_block_timestamp=`echo $init_block_timestamps|cut -d' ' -f${field_count}|tr '[' ' '|tr ']' ' '|tr 'T' ' '`
	echo "`echo $init_block_name| tr '~' ' '` , $time_taken_by_init_block"
#,$init_block_timestamp"
	field_count=`echo $field_count+1 |bc`
done
echo ",,$end_timestamp"
exit
