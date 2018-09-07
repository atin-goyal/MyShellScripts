#!/usr/bin/ksh
################################################################
# Author: Gaurav Rathore
# Usage : First Param is common logfile path for all processes
#		  requested without ending in "/"
#		  Second param onward is the path to the process Id file
#		  after the common path as per first param beginning with
#		  "/"
#
# Output: PID SIZE RSS CPU PROCESS/NLWP for each process in the
#		  sequence it was requested
################################################################
# Get the total no of params and processes requested
numParams=$#
((totalPids=$#-1))
#echo "Total pids requested $totalPids"

# Save the logs base location - Done to prevent param length maxout
pidBaseLocation=$1

# Get all the Process IDs associated with all the processes in a temp file
while [ "$2" != "" ]
do
	pidFile=$pidBaseLocation$2
	#pid=`awk -f ~/scripts/getpid.awk $pidFile`
	pid=`more ${pidFile}`
	pids=${pids}"$pid,"

	# Shift all the parameters down by one
	shift
done

# remove the last comma
pids=${pids%\,}

# Get the prstat for all process Ids
output=`top -b -p${pids} -d 1 -n 1 | tail -${numParams} | head -${totalPids} `

# get the prstat output in an array
i=0
for arr in $output
do
	arrPr[$i]=$arr
	((i=i+1))
done

# Replace comma separated process Ids with space separated Ids
pid=$(echo $pids|sed 's/,/ /g')

# get the process Ids in an array
i=0
for arr2 in $pid
do
	arrPid[$i]=$arr2
	((i=i+1))
done

# Loop through both prstat output and process Id arrays to sort the prstat output
i=0
j=0

# Get the lengths of each array
pidlen=${#arrPid[@]}
prlen=${#arrPr[@]}

#echo "PIdlen is $pidlen"
#echo "PRlen is $prlen"

# Sort output based on input process Ids
while ((i<pidlen))
do
	j=0
	while ((j<prlen))
	do
		# Check if the process Id in arrPid matches prstat output
		if [[ ${arrPid[i]} = ${arrPr[j]} ]]
		then
			# If process Ids match get the values for PID SIZE RSS CPU THREADS
			#prouttemp="${arrPid[i]} ${arrPr[((j+1))]} ${arrPr[((j+4))]} ${arrPr[((j+5))]} ${arrPr[((j+6))]} ${arrPr[((j+7))]} ${arrPr[((j+8))]} ${arrPr[((j+9))]} "
			prouttemp="${arrPid[i]} ${arrPr[((j+4))]} ${arrPr[((j+5))]} ${arrPr[((j+6))]} ${arrPr[((j+8))]} ${arrPr[((j+9))]} "
			prout=${prout}${prouttemp}
			# If match found go to the end of prstat output and in main loop
			j=prlen
		else
			# if no match found then proceed to next item in prstat output
			((j=j+1))
		fi
	done
	# Go to next process Id
	((i=i+1))
done
# Echo out the final output
echo $prout


