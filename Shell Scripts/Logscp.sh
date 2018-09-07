#!/bin/bash
today=$(date +"%d%b%g")
mkdir ${today}_004
mkdir ${today}_005
date >>/u01/common/general/psr/BI_PSR_Daily_Status/atin/cp.log
ssh acrmx0004 "cp --backup=t -puv  /u02/local/oracle/BIInstance/diagnostics/logs/OracleBIPresentationServicesComponent/coreapplication_obips1/sawlog*.log /u01/common/general/psr/BI_PSR_Daily_Status/atin/${today}_004/ >>/u01/common/general/psr/BI_PSR_Daily_Status/atin/cp.log"
ssh acrmx0005 "cp --backup=t -puv  /u02/local/oracle/BIInstance/diagnostics/logs/OracleBIPresentationServicesComponent/coreapplication_obips1/sawlog*.log /u01/common/general/psr/BI_PSR_Daily_Status/atin/${today}_005/ >>/u01/common/general/psr/BI_PSR_Daily_Status/atin/cp.log"
exit