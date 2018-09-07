export DataSource=AnalyticsWeb
export UserID=20
export testName=Nov11_OBIS_Con_PavelSQLs
export perID=5

#needs these two env vars to enable the nqcmd features for testing
export SA_NQCMD_ADVANCED=yes
export NQS_NQSODBC_NOBIND=true

export logDir=./logs_${testName}_${Users}
if [ ! -d $logDir ]; then
  mkdir $logDir
  echo folder [$logDir] created
else
  echo folder [$logDir] exists.  No need to create it again.
fi
echo logDir=$logDir
echo testName=$testName

  for (( u=1;u<=UserID;u++))
  do
	for (( i=1;i<=perID;i++))
	do
     echo $u, $i
     echo nqcmd -d $DataSource -u CVBUYER${u} -p Welcome1 -s pavel_sqls.txt -o ${logDir}/${testName}_User${u}_${i} -td 7200 -qsel r -ds 20 -q -T -t 1 -login -n 30  -utf16 &
     #./nqcmd -d $DataSource -u CVBUYER${u} -p Welcome1 -s pavel_sqls.txt -o ${logDir}/${testName}_User${u}_${i} -td 7200 -qsel r -ds 20 -q -T -t 1 -login -n 30 -utf16 &
     sleep 1
	done
  done

  